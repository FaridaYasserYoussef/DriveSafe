import 'package:drivesafe/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:drivesafe/model/driver.dart';
import 'package:drivesafe/model/vehicle.dart';
import 'package:http/http.dart' as http;
import 'package:drivesafe/api_connection/api_connection.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';




class ProfileFragmentScreen extends StatefulWidget {
  const ProfileFragmentScreen({super.key});

  @override
  State<ProfileFragmentScreen> createState() => _ProfileFragmentScreenState();
}

class _ProfileFragmentScreenState extends State<ProfileFragmentScreen> {

  Driver? currentDriver;
  Vehicle? currentVehicle;

  void editProfileInfo(){

  }
  Future<void> get_vehicle_and_driver_info() async{
    currentDriver = await RememberUserPrefs.readUserInfo();
    var res = await http.post(Uri.parse(API.getVehicleByDriver), 
    body:{
      'driver': currentDriver!.id.toString()
    });
    
    if(res.statusCode == 200){
       var responseBody = jsonDecode(res.body);
       if(responseBody["success"] == true){
         
          currentVehicle = Vehicle.fromJson(responseBody["vehicleData"]);

          
          
          
        }
        else if(responseBody["success"] == false){
          Fluttertoast.showToast(msg: "Was not able to fetch vehicle data", backgroundColor: Color(0xFFDDA87E));
        }
    }

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: RememberUserPrefs.readUserInfo(), builder: (context, snapshot){

    if(snapshot.data ==  null){
      return const LoginScreen();
    }
    else{
      return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white, 
        centerTitle: true,
        title: Text("Profile", 
        style: TextStyle(
          color: Color(0xFF2b7f70), 
          fontWeight: FontWeight.bold,
          fontSize: 35)),),
          body: Column(children: [
            
          ],),
      );
    }
    });
  }
}