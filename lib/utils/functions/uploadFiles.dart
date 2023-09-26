import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/functions/common.dart';

// returns final file
Future<File?> xPickCropCompressSaveImage({List<CropAspectRatioPreset>? cropRatios, required ImageSource source, required String path}) async {
  imageCache.clear();
  try {
    // step 1- picking the image
    final ImagePicker _picker = ImagePicker();
    XFile? image;
    image = await _picker.pickImage(source: source);
    // returning null if something went wrong
    if (image == null) {
      return null;
    }
    //Step 2- cropping the image
    CroppedFile? croppedImg = await ImageCropper().cropImage(
      // compressQuality: 90, this compressor does not work if image is not edited
      sourcePath: image.path,
      aspectRatioPresets: cropRatios??[CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: xSurface,
          toolbarWidgetColor: xPrimary,
          backgroundColor: xSurface,
          activeControlsWidgetColor: xOnPrimary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    // handle error while cropping
    if (croppedImg == null) {
      // deleting the chosen image
      File(image.path).deleteSync(recursive: true);
      return null;
    }

    //Step 3- compressing and saving the image in desired location and delete the auto generated location
    XFile? finalImg = await FlutterImageCompress.compressAndGetFile(
      croppedImg.path,
      path,
      quality: 90,
    );

    // checking
    if (!File(path).existsSync()) {
      return null;
    }

    //deleting unwanted images
    File(image.path).deleteSync(recursive: true);
    File(croppedImg.path).deleteSync(recursive: true);

    return File(path);
  } catch (e) {
    xPrint("image pick error - ${e.toString()}");
  }
}
