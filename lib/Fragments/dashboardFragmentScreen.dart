<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:drivesafe/reusableWidgets/DrivingTipCard.dart';
import 'package:drivesafe/reusableWidgets/DashboardComponent.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:drivesafe/authentication/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:drivesafe/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:drivesafe/api_connection/api_connection.dart';

class DashboardFragmentScreen extends StatefulWidget {
  @override
  _DashboardFragmentScreenState createState() => _DashboardFragmentScreenState();
}

class _DashboardFragmentScreenState extends State<DashboardFragmentScreen> {
  List<String> listOfTips = ["Content of tip 1 ", "Content of Tip 2", "Content of Tip 3", "Content of Tip 4"];
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  List<List<double>> _sensorData = [];
  bool _isRecording = false;
  late String _filePath;

  void logout() async {
    await RememberUserPrefs.removeUserInfo();
    FirebaseAuth.instance.signOut();
    Get.to(() => const LoginScreen());
  }

  Future<void> _startCollectingSensorData() async {
    _sensorData.clear();
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/sensor_data.csv';

    _userAccelerometerSubscription = userAccelerometerEvents.listen((event) {
      _sensorData.add([event.x, event.y, event.z, 0.0, 0.0, 0.0]); // Placeholder for gyroscope
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      if (_sensorData.isNotEmpty) {
        var lastData = _sensorData.last;
        _sensorData[_sensorData.length - 1] = [lastData[0], lastData[1], lastData[2], event.x, event.y, event.z];
      }
    });
  }

  Future<void> _stopCollectingSensorData() async {
    _userAccelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();

    if (_sensorData.isNotEmpty) {
      final csvData = const ListToCsvConverter().convert(_sensorData);
      final csvFile = File(_filePath);
      await csvFile.writeAsString(csvData);

      final request = http.MultipartRequest('POST', Uri.parse(API.uploadsensordata));
      request.files.add(await http.MultipartFile.fromPath('file', csvFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');
        await csvFile.delete();  // Delete the file after successful upload
      } else {
        print('File upload failed');
      }
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startCollectingSensorData();
      } else {
        _stopCollectingSensorData();
      }
    });
=======
// Original Code

// import 'package:flutter/material.dart';
// import 'mapFragmentScreen.dart';
// import 'tripFragmentScreen.dart';
// import 'dashboardFragmentScreen.dart';
// import 'package:get/get.dart';

// class DashboardOfFragments extends StatelessWidget {

// List<Widget> _fragmentScreens = [
//     DashboardFragmentScreen(),
//     MapFragmentScreen(),
//     TripFragmentScreen()
//    ];
//   List _navigationButtonsProperties = [
//      {
//        "active_icon": Icons.dashboard,
//        "non_active_icon": Icons.dashboard_outlined,
//        "label" : "Dashboard"
//      },

//      {
//        "active_icon": Icons.map,
//        "non_active_icon": Icons.map_outlined,
//        "label" : "Map"
//      },

//      {
//        "active_icon": Icons.car_crash,
//        "non_active_icon": Icons.car_crash_outlined,
//        "label" : "Trips"
//      }

//    ];

//       RxInt _indexNumber = 0.obs;


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//          child: Obx(
//                ()=> _fragmentScreens[_indexNumber.value]
//            ),
        
//         ),
//         bottomNavigationBar: Obx(() => BottomNavigationBar(
//           currentIndex: _indexNumber.value,
//           onTap: (value) {
//             _indexNumber.value = value;
//           },
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           selectedItemColor: const Color(0xFF207868),
//           unselectedItemColor: const Color(0xFF788896),
//           items: List.generate(3, (index) {
//              var navBtnProperty = _navigationButtonsProperties[index];
//                  return BottomNavigationBarItem(
//                      activeIcon: Icon(navBtnProperty["active_icon"]),
//                      label: navBtnProperty["label"],
//                      icon: Icon(navBtnProperty["non_active_icon"]),
//                       backgroundColor: const Color(0xffffffff) );
//           }),
//         )),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:drivesafe/reusableWidgets/DashboardComponent.dart';
import 'package:drivesafe/reusableWidgets/DrivingTipCard.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Storage Permission in Android(11,12 and 13)',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (await _requestPermission(Permission.storage)) {
              print("Permission is granted");
            } else {
              print("permission is not granted");
            }
          },
          child: Text('click'),
        ),
      ),
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }
}

class DashboardFragmentScreen extends StatefulWidget {
  @override
  _DashboardFragmentScreenState createState() =>
      _DashboardFragmentScreenState();
}

class _DashboardFragmentScreenState extends State<DashboardFragmentScreen> {
  late CameraController _controller;
  bool _showCamera = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> listOfTips = [
    "Content of tip 1 ",
    "Content of Tip 2",
    "Content of Tip 3",
    "Content of Tip 4"
  ];

  void _toggleTrip() async {
    if (_showCamera) {
      final videoFile = await _controller.stopVideoRecording();
      _showCamera = false;
      _isRecording = false;

      final appDir = await getExternalStorageDirectory();
      final fileName =
          'trip_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final filePath = join(appDir!.path, fileName);
      await videoFile.saveTo(filePath);

      print('Video saved to: $filePath');

      _controller.dispose();
      _initializeCamera();
    } else {
      _showCamera = true;
      await _controller.startVideoRecording();
      _isRecording = true;
    }
    setState(() {});
>>>>>>> 83ce61148f8a238d8a108bcbf309dec8142a2af3
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return FutureBuilder(
      future: RememberUserPrefs.readUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const LoginScreen();
        } else {
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
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DashboardComponent(
                  compValue: snapshot.data!.safety_score.toStringAsFixed(0),
                  icon: Icons.scale,
                  description: "Overall Average \n         Score",
                  dim: 200,
                  valueSize: 40,
                  iconSize: 75,
                  descriptionSize: 20,
                ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Color(0xFF2b7f70),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _toggleRecording,
                        child: Text(_isRecording ? "End Trip" : "Start Trip"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(_isRecording ? Colors.red : Color(0xFF2b7f70)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
=======
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(
              color: Color(0xFF2b7f70),
              fontWeight: FontWeight.bold,
              fontSize: 35),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DashboardComponent(
                compValue: "95",
                icon: Icons.scale,
                description: "Overall Average \n         Score",
                dim: 200,
                valueSize: 40,
                iconSize: 75,
                descriptionSize: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ellipse with projected discount
                  DashboardComponent(
                    compValue: "25",
                    icon: Icons.percent,
                    description: "Projected \n Discount",
                    dim: 170,
                    valueSize: 34,
                    iconSize: 63.75,
                    descriptionSize: 17,
                  ),
                  // ellipse with Total Kilometers
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
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Driving Tips",
                        style: TextStyle(
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
                    return DrivingTipCard(
                      messageContent: listOfTips[index],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2b7f70),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _toggleTrip,
                      child: Text(_showCamera ? "End Trip" : "Start Trip"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF2b7f70)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showCamera && _controller.value.isInitialized)
            Positioned(
              top: 10,
              left: 10,
              child: Column(
                children: [
                  Container(
                    width: 60, // Adjust width as needed
                    height: 90, // Adjust height as needed
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CameraPreview(_controller), // Camera preview widget
                    ),
                  ),
                  Icon(
                    Icons.fiber_manual_record,
                    color: Colors.red,
                    size: 24,
                  ),
                ],
              ),
            ),
        ],
      ),
>>>>>>> 83ce61148f8a238d8a108bcbf309dec8142a2af3
    );
  }
}
