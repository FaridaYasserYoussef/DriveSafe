import 'package:drivesafe/authentication/login_screen.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter/cupertino.dart';
import "Fragments/dashboardOfFragments.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:drivesafe/Controllers/WebsocketService.dart';


void main() async{

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

 await FirebaseAppCheck.instance.activate(
    // Set androidProvider to `AndroidProvider.debug`
    androidProvider: AndroidProvider.debug,
  );

  //   Get.put(WebSocketService(
  //   WebSocketChannel.connect(
  //     Uri.parse('ws://192.168.1.4:8000/ws/socket-server/'),
  //   ),
  // ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    // // For TESTING without Login
    // return GetMaterialApp(
    //   // home: AdminDashboardOfFragments()
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
