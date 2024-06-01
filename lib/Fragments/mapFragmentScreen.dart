import 'package:drivesafe/model/driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:drivesafe/api_connection/api_connection.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'dart:convert';



class MapFragmentScreen extends StatefulWidget {
  const MapFragmentScreen({super.key});

  @override
  State<MapFragmentScreen> createState() => _MapFragmentScreenState();
}

class _MapFragmentScreenState extends State<MapFragmentScreen> {

StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  List<List<double>> _sensorData = [];
  bool _isRecording = false;
  late String _filePath;
    late CameraController _cameracontroller;
  bool _showCamera = false;
String videoPath = "media/videos/";
String csvPath = "media/uploads/";
  bool runTheRest = false;
   Position? lastPosition;
     Position? initialPosition;
       bool _isPaused = false;

       Timer? movementTimer;
  Timer? pauseTimer;


  DateTime? lastPositionTime;
  double totalDistance = 0.0;
  Duration totalTimeElapsed = Duration.zero;
  StreamSubscription<Position>? positionStream;

MapBoxNavigationViewController? _controller;
  String? _instruction;
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _arrived = false;
  late MapBoxOptions _navigationOption;


      void _initializeCamera() async {
    final cameras = await availableCameras();
    _cameracontroller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    await _cameracontroller.initialize();
    setState(() {});
  }


  Future<void> initialize() async {
    if (!mounted) return;
    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.initialLatitude = 37.7749;
    _navigationOption.initialLongitude = -122.4194;
    _navigationOption.mode = MapBoxNavigationMode.driving;
    MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
  }

void stopListening() async{

            positionStream?.cancel();

            Driver? currentDriver = await RememberUserPrefs.readUserInfo(); 
   var vehicle =  await http.post(Uri.parse(API.getVehicleByDriver),
             body: {
            'driver': currentDriver!.id.toString()
          }
            
            );

print(vehicle.statusCode);
            if(vehicle.statusCode == 200){
              print("vehicle found");
        var responseBodyOfVehicle= jsonDecode(vehicle.body);
            // Vehicle driverVehicle = Vehicle.fromJson(responseBodyOfVehicle["vehicleData"]);
            // print("the vehicle id is: " + driverVehicle.id.toString());
            var res =  await http.post(Uri.parse(API.saveTrip),
             body: {
            'driver_id': currentDriver.id.toString(),
            'vehicle_id': responseBodyOfVehicle["vehicleData"]['driver'].toString(),
            'initial_lat': initialPosition!.latitude.toString(),
            'initial_long':initialPosition!.longitude.toString(),
            'last_lat':lastPosition!.latitude.toString(),
            'last_long': lastPosition!.longitude.toString(),
            'duration': totalTimeElapsed.inMinutes.toString(),
            'distance': (totalDistance/1000).toString(),
            'csvPath': csvPath,
            'videoPath': videoPath
          }
            
            );


            if(res.statusCode == 200){
              Fluttertoast.showToast(
          msg: "Trip Data successfully saved", backgroundColor: Color(0xFFDDA87E));
            }

            }


}

 void _pauseRecording() {
    _userAccelerometerSubscription?.pause();
    _gyroscopeSubscription?.pause();
    _cameracontroller.pauseVideoRecording();
    _isPaused = true;
    print('Recording paused');
  }

  void _resumeRecording(){
    _userAccelerometerSubscription?.resume();
    _gyroscopeSubscription?.resume();
    _cameracontroller.pauseVideoRecording();
    _isPaused = false;
    
  }

  void startListening() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      if (initialPosition == null) {
        initialPosition = position;
        lastPosition = position;
        lastPositionTime = DateTime.now();
      } else {
        double distance = Geolocator.distanceBetween(
          lastPosition!.latitude,
          lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance > 0) {
            if(_isPaused){
             _resumeRecording();
            }

          totalDistance += distance;
          Duration elapsedTime = DateTime.now().difference(lastPositionTime!);
          totalTimeElapsed += elapsedTime;
          lastPositionTime = DateTime.now();
          lastPosition = position;
        } else if (DateTime.now().difference(lastPositionTime!) > Duration(seconds: 30)) {
          _pauseRecording();
           pauseTimer = Timer(Duration(minutes: 15), () {
            if (_isPaused) {
              _stopRecordingAndSendData();
            }
          });
          print('ended trip');
          print('Initial position: ${initialPosition!.latitude}, ${initialPosition!.longitude}');
          print('Total distance travelled: $totalDistance meters');
          print('Total time elapsed: ${totalTimeElapsed.inSeconds} seconds');
        

        }
      }

      setState(() {
        lastPosition = position;
      });
    });
  }


  void _stopRecordingAndSendData() async{
     _toggleRecording();
    _toggleTrip();
    if(runTheRest == true){
    stopListening();
    }
    setState(() {});
  }

   void _startRecordingAndCollectData() async{
     _toggleRecording();
    _toggleTrip();
    startListening();
    setState(() {});
  }

  
  @override
  void initState() {
    initialize();
  _initializeCamera();

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
        _cameracontroller.dispose();

    super.dispose();
  }

 void _toggleTrip() async {
    if (_showCamera) {
      final videoFile = await _cameracontroller.stopVideoRecording();
      _showCamera = false;
      _isRecording = false;

      final appDir = await getExternalStorageDirectory();
      Driver? currentDriver =  await RememberUserPrefs.readUserInfo();
      final fileName =
          'trip_video_${DateTime.now().millisecondsSinceEpoch}'+ currentDriver!.id.toString() + '.mp4';
          videoPath += fileName;
      final filePath = join(appDir!.path, fileName);
      await videoFile.saveTo(filePath);

      print('Video saved to: $filePath');
      await _uploadVideo(filePath);

      _cameracontroller.dispose();
      _initializeCamera();
    } else {
      _showCamera = true;
      await _cameracontroller.startVideoRecording();
      _isRecording = true;
    }
    setState(() {});
  }


Future<void> _uploadVideo(String filePath) async {
    final request = http.MultipartRequest('POST', Uri.parse(API.uploadvideodata));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Video uploaded successfully');
      final videoFile = File(filePath);
      await videoFile.delete(); // Delete the video file after successful upload
      runTheRest =  true;

    } else {
      print('Video upload failed');
    }
  }



   Future<void> _startCollectingSensorData() async {
    _sensorData.clear();
    final directory = await getApplicationDocumentsDirectory();
          Driver? currentDriver =  await RememberUserPrefs.readUserInfo();

     final datafileName =
          'trip_sensordata_${DateTime.now().millisecondsSinceEpoch}'+ currentDriver!.id.toString() + '.csv';
      csvPath += datafileName;
    _filePath = '${directory.path}/' + datafileName;

    _userAccelerometerSubscription = userAccelerometerEvents.listen((event) {
            print(event);

    _sensorData.add([event.x, event.y, event.z, 0.0, 0.0, 0.0]); // Placeholder for gyroscope
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      if (_sensorData.isNotEmpty) {
        var lastData = _sensorData.last;
              print(event);

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

  }



 @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Container(
                  color: Colors.grey[100],
                  child: MapBoxNavigationView(
                    options: _navigationOption,
                    onRouteEvent: _onRouteEvent,
                    onCreated: (MapBoxNavigationViewController controller) async {
                      _controller = controller;
                      controller.initialize();
                    },
                  ),
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
                                onPressed: (){
                                 
                                  if(_isRecording == true){
                                    _startRecordingAndCollectData();
                                  }else{
                                    _stopRecordingAndSendData();
                                  }

                                },
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
if (_showCamera && _cameracontroller.value.isInitialized)
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
                      child: CameraPreview(_cameracontroller), // Camera preview widget
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
    );
  }

  Future<void> _onRouteEvent(e) async {

    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        _routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        _routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        _isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        _routeBuilt = false;
        _isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }



  
}


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

