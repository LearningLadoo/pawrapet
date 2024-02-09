import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:http/http.dart' as http;

Future<ImageProvider?> xPickCropCompressSaveImage({List<CropAspectRatioPreset>? cropRatios,CropAspectRatio? cropAspectRatio, required ImageSource source, required String path}) async {
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
      aspectRatio: cropAspectRatio,
      aspectRatioPresets: cropRatios ?? [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'PAWRAPET',
          toolbarColor: xOnPrimary,
          toolbarWidgetColor: xPrimary,
          backgroundColor: xOnPrimary,
          activeControlsWidgetColor: const Color(0xff43a047),
          cropGridColor: xOnPrimary,
          cropFrameColor: xOnPrimary,
          dimmedLayerColor: xPrimary.withOpacity(0.1),
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'PAWRAPET',
        ),
      ],
    );
    // handle error while cropping
    if (croppedImg == null) {
      // deleting the chosen image
      File(image.path).deleteSync(recursive: true);
      return null;
    }
    //Step 3- compressing
    List<int>? finalImgList = await FlutterImageCompress.compressWithFile(
      croppedImg.path,
      quality: 90,
    );

    // checking
    if (finalImgList == null) {
      // deleting the chosen image
      File(image.path).deleteSync(recursive: true);
      // deleting the cropped image
      File(croppedImg.path).deleteSync(recursive: true);
      return null;
    }
    // step 4-saving the image in desired location
    await File(path).writeAsBytes(finalImgList, flush: true);
    //deleting unwanted images
    File(image.path).deleteSync(recursive: true);
    File(croppedImg.path).deleteSync(recursive: true);
    // return
    return MemoryImage(Uint8List.fromList(finalImgList));
  } catch (e) {
    xPrint("image pick error - ${e.toString()}");
    return null;
  }
}
Future<Uint8List> getImageBytesFromUrl(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    // Image successfully fetched, convert to bytes
    List<int> imageBytes = response.bodyBytes;
    Uint8List unit8List = Uint8List.fromList(imageBytes);
    return unit8List;
  } else {
    // Handle error (e.g., image not found, server error)
    throw Exception('Failed to load image');
  }
}
