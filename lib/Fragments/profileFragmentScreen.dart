import 'package:drivesafe/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:drivesafe/model/driver.dart';
import 'package:drivesafe/model/vehicle.dart';
import 'package:get/get.dart';
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

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var ageController = TextEditingController();
  var firstLetterController = TextEditingController();
  var secondLetterController = TextEditingController();
  var thirdLetterController = TextEditingController();
  var licenseNumberController = TextEditingController();
  FocusNode firstletterFocusNode = FocusNode();
  FocusNode secondletterFocusNode = FocusNode();
  FocusNode thirdletterFocusNode = FocusNode();
  FocusNode licensenumberFocusNode = FocusNode();
    int? currentAge;
  String? username;
  bool boxesState = false;
  String? buttonState = "change";
  String? userName;
  int? age;


  var isObscure = true.obs;
  String? selectedValue;

  void editProfileInfo(int id) async{
   var res = await http.post(
          Uri.parse(API.editProfile),
          body: {
            'id': id.toString(),
            'username': usernameController.text.trim(),
            'age' : ageController.text.trim()
          }
      );



      if(res.statusCode == 200){
        var responseBodyOfLogin = jsonDecode(res.body);
        if(responseBodyOfLogin["success"] == true){
          Fluttertoast.showToast(msg: "Profile Info Edited Successfully", backgroundColor: Color(0xFFDDA87E));
          usernameController.clear();
          ageController.clear();
          Driver userInfo = Driver.fromJson(responseBodyOfLogin["driverData"]);
          print("username");

          print(userInfo.username);
                    print("age");

          print(userInfo.age);
          await RememberUserPrefs.storeUserInfo(userInfo);

          setState(() {
            buttonState = "change";
            boxesState = false;
            userName = userInfo.username;
            age = userInfo.age;

          });
          
          
        }
        else if(responseBodyOfLogin["success"] == false){
          Fluttertoast.showToast(msg: "Invalid Email or Password", backgroundColor: Color(0xFFDDA87E));
        }

      }


  }



   void enableFields(){

    setState(() {
      boxesState = true;
      buttonState = "edit";
    });
   }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            selectedValue = snapshot.data!.gender;
            userName = snapshot.data!.username;
            age = snapshot.data!.age;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text("Profile",
                    style: TextStyle(
                        color: Color(0xFF2b7f70),
                        fontWeight: FontWeight.bold,
                        fontSize: 35)),
              ),
              body: LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: snapshot.data!.gender == "Female"
                                ? AssetImage("images/Female.png")
                                : AssetImage("images/Male.png"),
                            radius: 110,
                          ),
                          SizedBox(height: 20),
                          Form(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: TextFormField(
                                    enabled: boxesState,
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                        hintText: 'Username: ' +  userName.toString(),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        fillColor: Colors.white,
                                        filled: true),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: TextFormField(
                                    enabled: boxesState,
                                    keyboardType: TextInputType.number,
                                    controller: ageController,
                                    validator: (val) => val == ""
                                        ? "Please write your age"
                                        : null,
                                    decoration: InputDecoration(
                                        hintText: 'Age: ' + age.toString(),
                                        prefixIcon: Icon(
                                          Icons.numbers,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        fillColor: Colors.white,
                                        filled: true),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: TextFormField(
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    validator: (val) => val == ""
                                        ? "Please write your age"
                                        : null,
                                    decoration: InputDecoration(
                                        hintText: 'Safety Score: ' + snapshot.data!.safety_score.toString(),
                                        prefixIcon: Icon(
                                          Icons.numbers,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60)),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        fillColor: Colors.white,
                                        filled: true),
                                  ),
                                ),
                               Material(
                                    color: buttonState == "change"? Colors.red: Color(0xFF207868),
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if(buttonState == "change"){
                                          enableFields();
                                        }
                                        else if(buttonState == "edit"){
                                          editProfileInfo(snapshot.data!.id);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:  10,
                                            horizontal: 28
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Text(buttonState == "change"? "Change Your Info": "Make Changes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }
        });
  }
}
