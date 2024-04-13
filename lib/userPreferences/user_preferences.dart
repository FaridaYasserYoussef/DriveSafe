import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/driver.dart';

class RememberUserPrefs{


  static Future<void> storeUserInfo(Driver userInfo) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

 static Future<Driver?> readUserInfo() async{
    Driver? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if(userInfo != null){
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = Driver.fromJson(userDataMap);
    }
    return currentUserInfo;

 }

 static Future<void> removeUserInfo() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
 }

}