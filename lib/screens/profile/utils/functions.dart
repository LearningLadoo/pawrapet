
import '../../../utils/functions/common.dart';

Future<bool> saveProfileDetails(Map details)async{
  try {
    return true;
  } catch (e) {
    xPrint(e.toString(), header: "saveProfileDetails");
    return false;
  }
}
Map getDefaultProfileMap(){
  return {
    "name": null,
    "type": null,
    "colour": null,
    "breed": null,
    "gender": null,
    "birthDate": null,
    "personality": null,
    "description": null,
    "height": null,
    "weight": null,
    "amount": null,
    "assets": {
      "icon_0": {
        "ext": null,
        "url": null,
      },
      "main_0": {
        "ext": null,
        "url": null,
      },
    }
  };
}