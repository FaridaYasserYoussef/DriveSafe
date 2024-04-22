import 'package:drivesafe/authentication/login_screen.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter/cupertino.dart';
import "Fragments/dashboardOfFragments.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    // For TESTING without Login
    // return GetMaterialApp(
    //   home: DashboardOfFragments()
    // );
    
    return GetMaterialApp(
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, snapshot){
          if(snapshot.data == null){
            return LoginScreen();
          }
          else{
            return DashboardOfFragments();
          }
        },
      ),
    );
  }
}

