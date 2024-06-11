import 'dart:convert';
import 'dart:async';
import 'package:drivesafe/userPreferences/user_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:drivesafe/model/trip.dart';
import 'package:drivesafe/model/driver.dart';

// sse_controller.dart

class SseController extends GetxController {
  var score = ''.obs;
  var trips = <Trip>[].obs;
  var eventStreamSubscription;

  StreamController<String> scoreStreamController = StreamController<String>.broadcast();
  StreamController<List<Trip>> tripsStreamController = StreamController<List<Trip>>.broadcast();

    Stream<String> get scoreStream => scoreStreamController.stream;
  Stream<List<Trip>> get tripsStream => tripsStreamController.stream;

  @override
  void onInit() {
    super.onInit();
    _connectToSse();
  }

  void _connectToSse() async {
    Driver? current_driver = await RememberUserPrefs.readUserInfo();
    int driverId = current_driver!.id;
    final url = 'http://192.168.92.80:8000/trips/sse-stream/$driverId'; // Replace with your SSE endpoint URL
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(url));
    final response = await client.send(request);

    eventStreamSubscription = response.stream
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen((String line) {
      if (line.startsWith('data: ')) {
        var data = line.substring(6);
        var decodedData = json.decode(data);

        if (decodedData['type'] == 'string') {
          score.value = decodedData['data'];
          scoreStreamController.add(decodedData['data']); // Update the score stream
        } else if (decodedData['type'] == 'trips') {
          var tripsList = (json.decode(decodedData['data']) as List).map((item) => Trip.fromJson(item)).toList();
          tripsList = tripsList.reversed.toList(); // Reverse the list
          trips.value = tripsList;
          tripsStreamController.add(tripsList); // Update the trips stream
        }
      }
    });
  }

  @override
  void onClose() {
    eventStreamSubscription.cancel();
    scoreStreamController.close();
    tripsStreamController.close();
    super.onClose();
  }
}
