import 'package:drivesafe/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'mapFragmentScreen.dart';
import 'tripFragmentScreen.dart';
import 'dashboardFragmentScreen.dart';
import 'profileFragmentScreen.dart';
import 'package:get/get.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:drivesafe/authentication/firebase_auth_implementation/firebase_auth_services.dart';

import 'package:firebase_auth/firebase_auth.dart';

class DashboardOfFragments extends StatelessWidget {



List<Widget> _fragmentScreens = [
    DashboardFragmentScreen(),
    MapFragmentScreen(),
    TripFragmentScreen(),
    ProfileFragmentScreen()
    
   ];
  List _navigationButtonsProperties = [
     {
       "active_icon": Icons.dashboard,
       "non_active_icon": Icons.dashboard_outlined,
       "label" : "Dashboard"
     },

     {
       "active_icon": Icons.map,
       "non_active_icon": Icons.map_outlined,
       "label" : "Map"
     },

     {
       "active_icon": Icons.car_crash,
       "non_active_icon": Icons.car_crash_outlined,
       "label" : "Trips"
     },

     {
       "active_icon": Icons.person_2,
       "non_active_icon": Icons.person_2_outlined,
       "label" : "Profile"
     }

   ];

      RxInt _indexNumber = 0.obs;

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
         child: Obx(
               ()=> _fragmentScreens[_indexNumber.value]
           ),
        
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          currentIndex: _indexNumber.value,
          onTap: (value) {
            _indexNumber.value = value;
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: const Color(0xFF207868),
          unselectedItemColor: const Color(0xFF788896),
          items: List.generate(4, (index) {
             var navBtnProperty = _navigationButtonsProperties[index];
                 return BottomNavigationBarItem(
                     activeIcon: Icon(navBtnProperty["active_icon"]),
                     label: navBtnProperty["label"],
                     icon: Icon(navBtnProperty["non_active_icon"]),
                      backgroundColor: const Color(0xffffffff) );
          }),
        )),
    );
  }
}