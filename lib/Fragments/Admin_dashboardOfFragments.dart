import 'package:flutter/material.dart';
import 'Admin_UsersFragmentScreen.dart';
import 'Admin_VehiclesFragmentScreen.dart';
import 'package:get/get.dart';
import 'package:drivesafe/authentication/login_screen.dart'; // Import the login screen

class AdminDashboardOfFragments extends StatelessWidget {
  final List<Widget> _fragmentScreens = [
    UsersFragmentScreen(),
    VehiclesFragmentScreen(),
  ];

  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Users"
    },
    {
      "active_icon": Icons.directions_car,
      "non_active_icon": Icons.directions_car_outlined,
      "label": "Vehicles"
    },
  ];

  final RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate back to the login screen
              Get.offAll(LoginScreen());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => _fragmentScreens[_indexNumber.value],
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
        items: List.generate(_navigationButtonsProperties.length, (index) {
          var navBtnProperty = _navigationButtonsProperties[index];
          return BottomNavigationBarItem(
            activeIcon: Icon(navBtnProperty["active_icon"]),
            label: navBtnProperty["label"],
            icon: Icon(navBtnProperty["non_active_icon"]),
            backgroundColor: const Color(0xffffffff),
          );
        }),
      )),
    );
  }
}
