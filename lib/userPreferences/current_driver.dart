
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:get/get.dart';

import '../model/driver.dart';

class CurrentUser extends GetxController{

Rx<Driver> _currentUser =  Driver(0, '', '', '', 0, '', 0.0).obs;
Driver get user => _currentUser.value;

getUserInfo() async{
  Driver? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
  _currentUser.value = getUserInfoFromLocalStorage!;
}


}