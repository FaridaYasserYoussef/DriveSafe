import 'package:drivesafe/reusableWidgets/ListTripEvents.dart';
import 'package:flutter/material.dart';
import 'package:drivesafe/model/trip.dart';
import 'package:drivesafe/constants/styles.dart';
import 'package:get/get.dart';
class ViewTripDetails extends StatefulWidget {
  final Trip trip;

  ViewTripDetails(this.trip);

  @override
  State<ViewTripDetails> createState() => _ViewTripDetailsState();
}

class _ViewTripDetailsState extends State<ViewTripDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Trip#" + widget.trip.id.toString(),
          style: TextStyle(
            color: Color(0xFF2b7f70),
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: CircleAvatar(
                child: Icon(
                  Icons.car_rental,
                  size: 90,
                  color: Color(0xFF2b7f70),
                ),
                radius: 90,
                backgroundColor: Color(0xffd2e4e1),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.all(Radius.circular(60)),
              border: Border.all(
                color: Color(0xFF2b7f70),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Color(0xffd2e4e1),
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Start Time: ",
                            style: TripInfotitle,
                          ),
                          TextSpan(
                            text: widget.trip.startTime,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "End Time: ",
                            style: TripInfotitle,
                          ),
                          TextSpan(
                            text: widget.trip.endTime,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Duration (minutes:seconds) : ",
                            style:TripInfotitle,
                          ),
                          TextSpan(
                            text: widget.trip.duration.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Distance in Kilometers: ",
                            style: TripInfotitle,
                          ),
                          TextSpan(
                            text: widget.trip.distance.toStringAsFixed(2),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if(widget.trip.sensorProcessed == true && widget.trip.videoProcessed == true)...[
              Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color:  Color(0xFF2b7f70),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: (){
                                 Get.to(()=>ListTripEvents(widget.trip.id));
                                  
                                },
                                child: Text("View Trip Events"),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2b7f70)),
                                ),
                              ),
                            ),
                          ),
                        ),

        ]
        ],
      ),
    );
  }
}
