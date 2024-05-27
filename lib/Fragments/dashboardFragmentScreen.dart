import 'package:flutter/material.dart';
import 'package:drivesafe/reusableWidgets/DrivingTipCard.dart';
import 'package:drivesafe/reusableWidgets/DashboardComponent.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:drivesafe/authentication/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:drivesafe/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';

class DashboardFragmentScreen extends StatelessWidget {

  List<String> listOfTips = ["Content of tip 1 ", "Content of Tip 2", "Content of Tip 3", "Content of Tip 4"];
 void logout() async{
        await RememberUserPrefs.removeUserInfo();
        FirebaseAuth.instance.signOut();
        Get.to(()=> const LoginScreen());
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: RememberUserPrefs.readUserInfo(), builder: (context, snapshot){
    if(snapshot.data == null ){
      return const  LoginScreen();
    }
    else{
      return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed:logout, icon: const Icon(Icons.logout), color: const Color(0xFF207868),)],
        backgroundColor: Colors.white, 
        centerTitle: true,
        title: Text("Dashboard", 
        style: TextStyle(
          color: Color(0xFF2b7f70), 
          fontWeight: FontWeight.bold,
          fontSize: 35)),),

    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      DashboardComponent(compValue: snapshot.data!.safety_score.toStringAsFixed(0), icon: Icons.scale, description: "Overall Average \n         Score", dim: 200, valueSize: 40,iconSize: 75, descriptionSize: 20,),
        
  
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ellipse with projected discount
           DashboardComponent(compValue: "25", icon: Icons.percent, description: "Projected \n Discount", dim: 170, valueSize: 34, iconSize: 63.75, descriptionSize: 17,),

            // ellipse with Total Kilometers
          DashboardComponent(compValue: "1000", icon: Icons.directions, description: "    Total \nKilometers", dim: 170, valueSize: 34, iconSize: 63.75, descriptionSize: 17,),

          ],
        ),

        SizedBox(height: 50,),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Driving Tips", style: TextStyle(
                color: Color(0xFF2b7f70), 
                fontWeight: FontWeight.bold,
                fontSize: 20)),
            ],
          ),
        ),
    
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: listOfTips.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return DrivingTipCard(messageContent: listOfTips[index],);
              },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: new BoxDecoration(
          color: Color(0xFF2b7f70),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.black, // Change to the color you desire
              width: 2.0,),
              ),
            child: SizedBox(
                  width: double.infinity,
        
              child: ElevatedButton(onPressed: (){},
               child: Text("Start Trip"),
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2b7f70))
               ),
                    
               ),
            )
             ),
        )
    
      ],
    ),
    );
    }
    });
    
  }
}

