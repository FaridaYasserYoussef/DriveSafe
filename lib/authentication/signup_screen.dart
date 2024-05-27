import 'dart:convert';
import 'dart:core';
import 'package:drivesafe/api_connection/api_connection.dart';
import 'package:drivesafe/authentication/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:drivesafe/authentication/login_screen.dart';
import 'package:drivesafe/model/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final FirebaseAuthService _auth =  FirebaseAuthService();
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


  var isObscure = true.obs;
   String selectedValue = "Male";
String selectedValueVehicle = "Car";
   registerAndSaveUserRecord() async{

    print("in register");

    // Driver userModel = Driver(
    //     1,
    //     nameController.text.trim(),
    //     emailController.text.trim(),
    //     passwordController.text.trim()
    // );

    try{

      User? user = await  _auth.signUpWithEmailAndPassword(emailController.text.trim(),  passwordController.text.trim());

      if(user == null){

                 Fluttertoast.showToast(msg: "An error occurred while signing you up, please try again.", backgroundColor: Color(0xFFDDA87E));
                 return;

      }

      
      
      var res = await http.post(
       Uri.parse(API.signup),
       body: {
          'email': emailController.text.trim(),
          'license_plate': licenseNumberController.text + thirdLetterController.text + secondLetterController.text + firstLetterController.text,
          'password': passwordController.text.trim(),
          'username': usernameController.text.trim(),
          'age': ageController.text.trim().toString(),
          "gender": selectedValue,
          "vehicle_type": selectedValueVehicle


       }
      );

      if(res.statusCode == 200){
        print("in status code if");
       var resBodyOfSignup = jsonDecode(res.body);
       print(resBodyOfSignup);
       if(resBodyOfSignup["success"] == true){
         Fluttertoast.showToast(msg: "Registered Successfully", backgroundColor: Color(0xFFDDA87E));
         setState(() {
           usernameController.clear();
           emailController.clear();
           passwordController.clear();
           ageController.clear();
         });
       }
       else{
         Fluttertoast.showToast(msg: "An error occurred while signing you up, please try again.", backgroundColor: Color(0xFFDDA87E));

       }


      }
      
    }

    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Color(0xFFDDA87E));
    }


  }

  validateUserEmail() async{

    try{
     var res =  await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'email': emailController.text.trim(),
         'license_plate': licenseNumberController.text + thirdLetterController.text + secondLetterController.text + firstLetterController.text,
      

        }
      );


      if(res.statusCode == 200){
        var resBodyOfValidateEmail = jsonDecode(res.body);
        print("response body is ");
        print(resBodyOfValidateEmail);
        if(resBodyOfValidateEmail["validated"] == false){ // success is equal to true
          Fluttertoast.showToast(msg: "Email is already in use. Try another email.", backgroundColor: Color(0xFFDDA87E));

        }
        else{
           registerAndSaveUserRecord();
        }

      }

    }
    catch(e){
      print("in validate catch");
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString(), backgroundColor: Color(0xFFDDA87E));
    }

  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd2e4e1),
      appBar: AppBar(
        title: Text('Signup',
        style: TextStyle(
          color: Color(0xFF2b7f70), 
          fontWeight: FontWeight.bold,
          fontSize: 35)
        
        ),
        
        centerTitle: true,
        foregroundColor: Color(0xFF2b7f70),
        backgroundColor: Color(0xffd2e4e1) ,
      ),
      body:
      LayoutBuilder(
        
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: constraints.maxHeight
            ),
            child: SingleChildScrollView(
              
              child: Column(
                
                children: [

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child:    Image(width: MediaQuery.of(context).size.width, fit: BoxFit.cover ,image: AssetImage('images/logo.jpg'),),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.all(
                              Radius.circular(60)
                          ),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, -3)
                            )
                          ]
                      ),

                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                                          mainAxisSize: MainAxisSize.min,

                                children: [


                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      child: TextFormField(
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                            hintText: 'Username',
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.black,
                                  
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                            fillColor: Colors.white,
                                            filled: true
                                        ),
                                      ),
                                    ),
                                  ),
                                
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: ageController,
                                        validator: (val) => val == "" ? "Please write your age" : null ,
                                        decoration: InputDecoration(
                                            hintText: 'Age',
                                            prefixIcon: Icon(
                                              Icons.numbers,
                                              color: Colors.black,
                                
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                            fillColor: Colors.white,
                                            filled: true
                                        ),
                                      ),
                                    ),
                                ),

                                  Flexible(
                                    child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            child: DropdownButtonFormField<String>(
                                              
                                              value: selectedValue, // selectedValue should be a String variable holding the current selected value
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedValue = newValue!; // Update the selected value when the user selects a new value
                                                });
                                              },
                                              validator: (value) => value == null ? "Please select your gender" : null,
                                              items: <String>['Male', 'Female'] // Replace these with your specific values
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                hintText: 'Gender',
                                                prefixIcon: Icon(
                                                selectedValue == "Male"? Icons.male : selectedValue == "Female"?  Icons.female : Icons.person,
                                                  color: Colors.black,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                fillColor: Colors.white,
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                  ),

                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            child: DropdownButtonFormField<String>(
                                              
                                              value: selectedValueVehicle, // selectedValue should be a String variable holding the current selected value
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedValueVehicle = newValue!; // Update the selected value when the user selects a new value
                                                });
                                              },
                                              validator: (value) => value == null ? "Please select your Vehicle type" : null,
                                              items: <String>['Car', 'Bus', 'Truck'] // Replace these with your specific values
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                hintText: 'Vehicle Type',
                                                prefixIcon: Icon(
                                                selectedValueVehicle == "Car"? Icons.car_repair : selectedValueVehicle == "Bus"?  Icons.bus_alert : Icons.fire_truck,
                                                  color: Colors.black,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white60),
                                                ),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                fillColor: Colors.white,
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Row(
                                          children: [
                                          
                                          Flexible(
                                            flex: 3,
                                  child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20, left: 7, top: 20, right: 7),
                                      child: TextFormField(
                                        maxLength: 4,
                                        keyboardType: TextInputType.number,
                                        focusNode: licensenumberFocusNode,
                                        controller: licenseNumberController,
                                    
                                        validator: (val) => val == "" ? "Please write the license plate number" : null ,
                                        decoration: InputDecoration(
                                            hintText: '9296',
                                            prefixIcon: Icon(
                                              Icons.numbers,
                                              color: Colors.black,
                                
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                            fillColor: Colors.white,
                                            filled: true
                                        ),
                                      ),
                                    ),
                                ),

                                          Flexible(
                                            flex: 1,
                                      child: TextFormField(
                                         inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[ا-ي]')), // Allow Arabic characters only
                                                ],
                                        
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                           textAlign: TextAlign.center,

                                      controller: thirdLetterController,
                                      // validator: (val) => val == "" ? "Please write your username" : null ,
                                      focusNode: thirdletterFocusNode,

                                      onChanged: (value) {
                                        FocusScope.of(context).requestFocus(licensenumberFocusNode);
                                        print(thirdLetterController.text);
                                      },
                                      maxLength: 1,
                                      decoration: InputDecoration(
                                                                      hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                        hintText: 'ه',
                                                                        
                                                                        // prefixIcon: Icon(
                                                                        //   Icons.person,
                                                                        //   color: Colors.black,
                                                                    
                                                                        // ),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        disabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                                        fillColor: Colors.white,
                                                                        filled: true
                                      ),
                                                                                                        ),
                                    ),
                                    SizedBox(width: 5,),
                                          Flexible(
                                            flex: 1,
                                      child: TextFormField(
                                         inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[ا-ي]')), // Allow Arabic characters only
                                                ],
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                          textAlign: TextAlign.center,

                                      controller: secondLetterController,
                                      focusNode: secondletterFocusNode,

                                      onChanged: (value) {
                                        FocusScope.of(context).requestFocus(thirdletterFocusNode);
                                          print(secondLetterController.text);

                                      },
                                      // validator: (val) => val == "" ? "Please write your username" : null ,
                                      maxLength: 1,
                                      decoration: InputDecoration(
                                                                      
                                                                        hintText: 'ع',
                                                                        
                                                                        // prefixIcon: Icon(
                                                                        //   Icons.person,
                                                                        //   color: Colors.black,
                                                                    
                                                                        // ),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        disabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                                        fillColor: Colors.white,
                                                                        filled: true
                                      ),
                                                                                                        ),
                                    ),
                                         SizedBox(width: 5,),
                                    Flexible(
                                      flex: 1,
                                      child: TextFormField(
                                         inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[ا-ي]')), // Allow Arabic characters only
                                                ],
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                      textAlign: TextAlign.center,

                                      controller: firstLetterController,
                                       focusNode: firstletterFocusNode,

                                      onChanged: (value) {
                                        FocusScope.of(context).requestFocus(secondletterFocusNode);
                                         print(firstLetterController.text);

                                      },
                                      // validator: (val) => val == "" ? "Please write your username" : null ,
                                      maxLength: 1,
                                      decoration: InputDecoration(
                                                                      
                                                                        hintText: 'أ',
                                                                        
                                                                        // prefixIcon: Icon(
                                                                        //   Icons.person,
                                                                        //   color: Colors.black,
                                                                    
                                                                        // ),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        disabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            borderSide: BorderSide(color: Colors.white60)
                                                                        ),
                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                                        fillColor: Colors.white,
                                                                        filled: true
                                      ),
                                                                                                        ),
                                    ),
                                          
                                        ],),


                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      child: TextFormField(
                                        controller: emailController,
                                        validator: (val) => val == "" ? "Please write an email" : null ,
                                        decoration: InputDecoration(
                                            hintText: 'Email',
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.black,
                                  
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.white60)
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                            fillColor: Colors.white,
                                            filled: true
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      child: Obx(
                                              ()=> TextFormField(
                                            obscureText: isObscure.value,
                                            controller: passwordController,
                                            validator: (val) => val == "" ? "Please write a password" : null ,
                                            decoration: InputDecoration(
                                                hintText: 'Password',
                                                prefixIcon: Icon(
                                                  Icons.vpn_key_sharp,
                                                  color: Colors.black,
                                  
                                                ),
                                                suffixIcon: Obx(
                                                      ()=> GestureDetector(
                                                    onTap: (){
                                                      isObscure.value = !isObscure.value;
                                                    },
                                                    child: Icon(
                                                      isObscure.value ? Icons.visibility_off : Icons.visibility,
                                                      color: Colors.black ,
                                                    ),
                                                  ),
                                  
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                    borderSide: BorderSide(color: Colors.white60)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                    borderSide: BorderSide(color: Colors.white60)
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                    borderSide: BorderSide(color: Colors.white60)
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                    borderSide: BorderSide(color: Colors.white60)
                                                ),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                fillColor: Colors.white,
                                                filled: true
                                            ),
                                          )
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 25,),


                                  Material(
                                    color:  Color(0xFFDDA87E),
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if(formKey.currentState!.validate()){
                                          validateUserEmail();
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
                                          child: Text('Signup',
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

                            SizedBox(height: 16,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account?', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                                TextButton(onPressed: (){
                                  Get.to(LoginScreen());
                                },
                                    child: Text('Login Here', style: TextStyle(color:  Color(0xFF2b7f70), fontSize: 16), ))
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),

            ),
          );
        },
      ),
    );
  }
}