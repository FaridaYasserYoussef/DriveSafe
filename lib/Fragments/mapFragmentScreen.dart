import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import GoogleMapsFlutter
// import 'package:flutter_application_1/pages/map_page.dart'; // No longer needed

class MapFragmentScreen extends StatelessWidget {
  const MapFragmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Color Toggling Button',
      home: ColorToggleButton(),
    );
  }
}

class ColorToggleButton extends StatefulWidget {
  const ColorToggleButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ColorToggleButtonState createState() => _ColorToggleButtonState();
}

class _ColorToggleButtonState extends State<ColorToggleButton> {
  bool _isGreen = true; // Indicates whether the button is green or red
  String elapsedTime = "00:00:00"; // Formatted elapsed time
  Timer? _timer; // Timer to track elapsed time
  int _elapsedSeconds = 0; // Elapsed seconds for calculation

  void _toggleColor() {
    setState(() {
      _isGreen = !_isGreen;

      if (_isGreen) {
        // When the button turns green (Start Trip), reset the elapsed time
        _resetTimer();
      } else {
        // When the button turns red (End Trip), start counting elapsed time
        _startTimer();
      }
    });
  }

  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        elapsedTime = _formatTime(_elapsedSeconds);
      });
    });
  }

  void _resetTimer() {
    // Cancel the existing timer and reset elapsed time
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      elapsedTime = "00:00:00";
    });
  }

  // Helper function to format elapsed time
  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}'
        ':${minutes.toString().padLeft(2, '0')}'
        ':${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Light gray rectangle at the top
          Container(
            width: double.infinity,
            height: 100.0, // Adjust the height as desired
            color: Colors.grey[200], // Light gray color
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Elapsed Time: $elapsedTime',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const Text(
                    'Distance: 0 km | Speed: 0 km/s',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const Text(
                    'Longitude: 0° | Latitude: 0°',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Embed GoogleMap widget
          Expanded(
            child: Scaffold(
              body: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.4223, -122.0848), // Adjust initial position as desired
                  zoom: 13,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60.0,
            child: ElevatedButton(
              onPressed: _toggleColor,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    _isGreen ? Colors.green : Colors.red),
              ),
              child: Text(
                _isGreen ? 'Start Trip' : 'End Trip',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
