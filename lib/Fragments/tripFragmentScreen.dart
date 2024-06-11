import 'dart:convert';
import 'package:drivesafe/api_connection/api_connection.dart';
import 'package:drivesafe/model/driver.dart';
import 'package:drivesafe/reusableWidgets/ViewTripDetail.dart';
import 'package:drivesafe/viewtripsdetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:drivesafe/userPreferences/current_driver.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:get/get.dart';
import 'package:drivesafe/model/trip.dart';
import 'package:drivesafe/constants/styles.dart';
import 'package:drivesafe/Controllers/SseController.dart';

class TripFragmentScreen extends StatefulWidget {
  const TripFragmentScreen({super.key});

  @override
  State<TripFragmentScreen> createState() => _TripFragmentScreenState();
}

class _TripFragmentScreenState extends State<TripFragmentScreen> {
        final SseController sseController = Get.put(SseController());

  Future<List<Trip>> getDriverTrips() async {
    List<Trip> tripList = [];

    Driver? current_driver = await RememberUserPrefs.readUserInfo();

    try {
      print("The driver id is ${current_driver!.id.toString()}");

      var res = await http.post(
        Uri.parse(API.getDriverTrips),
        body: {
          "driver_id": current_driver.id.toString()
        }
      );

      if (res.statusCode == 200) {
        var decodedResponseBody = jsonDecode(res.body);
        if (decodedResponseBody["success"] == true) {
          print("trips fetched");
          print("Trips Response body ${decodedResponseBody['tripData']}");
          for (Map<String, dynamic> eachTripItem in decodedResponseBody['tripData']) {
            tripList.add(Trip.fromJson(eachTripItem));
          }
        tripList = tripList.reversed.toList();
        }
      } else {
        Fluttertoast.showToast(msg: "No Trips were found for this user", backgroundColor: Color(0xFFDDA87E));
      }
    } catch (e, stackTrace) {
      print('Exception caught: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Color(0xFFDDA87E));
    }
    print("trips list is $tripList");
    return tripList;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Trips", style: TextStyle(
          color: Color(0xFF2b7f70),
          fontWeight: FontWeight.bold,
          fontSize: 35
        )),
      ),
      body: StreamBuilder<List<Trip>>(
        stream: sseController.tripsStream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Text("No trips were Found");
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xffd2e4e1),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                  height: 100,
                  child: ListTile(
                    leading: const Image(image: AssetImage("images/car.png")),
                    title: Text("Trip #" + snapshot.data![index].id.toString(), style: TripNumstyle,),
                    subtitle: Text(snapshot.data![index].startTime.toString()),
                    trailing: GestureDetector(
                      child: Icon(Icons.arrow_forward),
                      onTap: () {
                        Get.to(ViewTripDetails(snapshot.data![index]));
                      },
                    ),
                  ),
                );
              }
            );
          }
        },
      ),
    );
  }
}
