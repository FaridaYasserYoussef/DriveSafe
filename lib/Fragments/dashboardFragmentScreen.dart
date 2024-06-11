
import 'package:flutter/material.dart';
import 'package:drivesafe/reusableWidgets/DrivingTipCard.dart';
import 'package:drivesafe/reusableWidgets/DashboardComponent.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:drivesafe/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:drivesafe/Controllers/SseController.dart';

class DashboardFragmentScreen extends StatefulWidget {
  @override
  _DashboardFragmentScreenState createState() => _DashboardFragmentScreenState();
}

class _DashboardFragmentScreenState extends State<DashboardFragmentScreen> {
  List<String> listOfTips = ["Content of tip 1 ", "Content of Tip 2", "Content of Tip 3", "Content of Tip 4"];
  final SseController sseController = Get.put(SseController());

  void logout() async {
    await RememberUserPrefs.removeUserInfo();
    FirebaseAuth.instance.signOut();
    Get.to(() => const LoginScreen());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout), color: const Color(0xFF207868),)
        ],
        backgroundColor: Colors.white, 
        centerTitle: true,
        title: Text("Dashboard", style: TextStyle(
          color: Color(0xFF2b7f70), 
          fontWeight: FontWeight.bold,
          fontSize: 35)),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<String>(
                stream: sseController.scoreStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data == ''){
                      return Text("No score has been calculated");

                    }else{
                      return DashboardComponent(
                      compValue: snapshot.data!,
                      icon: Icons.scale,
                      description: "Overall Average \n         Score",
                      dim: 200,
                      valueSize: 40,
                      iconSize: 75,
                      descriptionSize: 20,
                    );
                    }
                  } else {
                    // Handle when data is not available
                    return CircularProgressIndicator();
                  }
                },
              )
            ,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardComponent(
                    compValue: "25",
                    icon: Icons.percent,
                    description: "Projected \n Discount",
                    dim: 170,
                    valueSize: 34,
                    iconSize: 63.75,
                    descriptionSize: 17,
                  ),
                  DashboardComponent(
                    compValue: "1000",
                    icon: Icons.directions,
                    description: "    Total \nKilometers",
                    dim: 170,
                    valueSize: 34,
                    iconSize: 63.75,
                    descriptionSize: 17,
                  ),
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
                    return DrivingTipCard(messageContent: listOfTips[index]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}






















// import 'package:flutter/material.dart';
// import 'package:drivesafe/reusableWidgets/DrivingTipCard.dart';
// import 'package:drivesafe/reusableWidgets/DashboardComponent.dart';
// import 'package:drivesafe/userPreferences/user_preferences.dart';
// // import 'package:drivesafe/authentication/firebase_auth_implementation/firebase_auth_services.dart';
// import 'package:drivesafe/authentication/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:drivesafe/Controllers/SseController.dart';

// class DashboardFragmentScreen extends StatefulWidget {
//   @override
//   _DashboardFragmentScreenState createState() => _DashboardFragmentScreenState();
// }

// class _DashboardFragmentScreenState extends State<DashboardFragmentScreen> {
//   List<String> listOfTips = ["Content of tip 1 ", "Content of Tip 2", "Content of Tip 3", "Content of Tip 4"];
//     final SseController sseController = Get.put(SseController());

//   void logout() async {
//     await RememberUserPrefs.removeUserInfo();
//     FirebaseAuth.instance.signOut();
//     Get.to(() => const LoginScreen());
//   }


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//         // _initializeCamera();

//   }

//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }
 

//  @override
//   Widget build(BuildContext context) {

//     return FutureBuilder(
//       future: RememberUserPrefs.readUserInfo(),
//       builder: (context, snapshot) {
//         if (snapshot.data == null) {
//           return const LoginScreen();
//         } else {
//           return Scaffold(
//             appBar: AppBar(
//               actions: [
//                 IconButton(onPressed: logout, icon: const Icon(Icons.logout), color: const Color(0xFF207868),)
//               ],
//               backgroundColor: Colors.white, 
//               centerTitle: true,
//               title: Text("Dashboard", style: TextStyle(
//                 color: Color(0xFF2b7f70), 
//                 fontWeight: FontWeight.bold,
//                 fontSize: 35)),
//             ),
//             body: Stack(
//               children: [
//               Obx(() =>     Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     DashboardComponent(
//                       compValue: sseController.score.value,
//                       icon: Icons.scale,
//                       description: "Overall Average \n         Score",
//                       dim: 200,
//                       valueSize: 40,
//                       iconSize: 75,
//                       descriptionSize: 20,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         DashboardComponent(
//                           compValue: "25",
//                           icon: Icons.percent,
//                           description: "Projected \n Discount",
//                           dim: 170,
//                           valueSize: 34,
//                           iconSize: 63.75,
//                           descriptionSize: 17,
//                         ),
//                         DashboardComponent(
//                           compValue: "1000",
//                           icon: Icons.directions,
//                           description: "    Total \nKilometers",
//                           dim: 170,
//                           valueSize: 34,
//                           iconSize: 63.75,
//                           descriptionSize: 17,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 50,),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text("Driving Tips", style: TextStyle(
//                             color: Color(0xFF2b7f70), 
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20)),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         itemCount: listOfTips.length,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           return DrivingTipCard(messageContent: listOfTips[index]);
//                         },
//                       ),
//                     ),
                  
//                   ],
//                 ),)
    
      
//               ],
//             ),
//           );
//         }
//       });
//       }



// }


