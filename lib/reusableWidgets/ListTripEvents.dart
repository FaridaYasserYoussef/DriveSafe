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


class ListTripEvents extends StatefulWidget {
  int trip_id;
   ListTripEvents(this.trip_id);

  @override
  State<ListTripEvents> createState() => _ListTripEventsState();
}

class _ListTripEventsState extends State<ListTripEvents> {


   Future<List<Map<String, String>>> getTripEvents() async {
    List<Map<String, String>> eventList = [];


    try {

      var res = await http.post(
        Uri.parse(API.getTripEvents),
        body: {
          "trip_id": widget.trip_id.toString()
        }
      );

      if (res.statusCode == 200) {
        var decodedResponseBody = jsonDecode(res.body);
        if (decodedResponseBody["success"] == true) {
          print("trip events fetched");
          print("Trip event Response body ${decodedResponseBody['eventData']}");
          for (String eachTripEvent in decodedResponseBody['eventData']) {
            Map<String, String> label_path_map = {};
            if (eachTripEvent == "OneHand"){
              label_path_map["label"] = "One Hand";
              label_path_map["path"] = "images/OneHand.jpeg";
            } 
            else if(eachTripEvent == "TwoHands"){
                label_path_map["label"] = "Two Hands";
              label_path_map["path"] = "images/TwoHands.jpeg";

            }
            else if(eachTripEvent == "Drinking"){
                label_path_map["label"] = "Drinking";
              label_path_map["path"] = "images/Drinking.jpeg";

            }
            else if(eachTripEvent == "Smoking"){
                label_path_map["label"] = "Smoking";
              label_path_map["path"] = "images/Smoking.jpeg";

            }
            else if(eachTripEvent == "Eating"){
                label_path_map["label"] = "Eating";
              label_path_map["path"] = "images/Eating.jpeg";

            }
              else if(eachTripEvent == "PhoneCall"){
                  label_path_map["label"] = "Phone Call";
              label_path_map["path"] = "images/PhoneCall.jpeg";

            }
             else if(eachTripEvent == "PhoneUse"){
                label_path_map["label"] = "Phone Use";
              label_path_map["path"] = "images/PhoneUse.jpeg";

            }
            else if(eachTripEvent == "NoHanded"){
                label_path_map["label"] = "No Hands";
              label_path_map["path"] = "images/NoHands.jpeg";

            }
            else if(eachTripEvent == "zigzag"){
                label_path_map["label"] = "Zigzag";
              label_path_map["path"] = "images/zigzag.jpeg";

            }
            else if(eachTripEvent == "sharpturn"){
                label_path_map["label"] = "Sharp Turn";
              label_path_map["path"] = "images/sharpturn.jpeg";

            }
            else if(eachTripEvent == "suddenbarking"){
                label_path_map["label"] = "Sudden Braking";
              label_path_map["path"] = "images/suddenbraking.jpeg";

            }
             else if(eachTripEvent == "pothole"){
                label_path_map["label"] = "Pothole";
              label_path_map["path"] = "images/pothole.jpeg";

            }
            eventList.add(label_path_map);
          }
        // tripList = tripList.reversed.toList();
        }
      } else {
        Fluttertoast.showToast(msg: "No Trips were found for this user", backgroundColor: Color(0xFFDDA87E));
      }
    } catch (e, stackTrace) {
      print('Exception caught: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Color(0xFFDDA87E));
    }
    print("trips list is $eventList");
    return eventList;
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Placeholder();
  // }

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
      body: FutureBuilder(
        future: getTripEvents(),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return CircularProgressIndicator();
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
                    leading:  Image(image: AssetImage(snapshot.data![index]["path"].toString())),
                    title: Text(snapshot.data![index]["label"].toString(), style: TripNumstyle,),
                    
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