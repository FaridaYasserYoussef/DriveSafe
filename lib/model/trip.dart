import 'dart:ffi';

class Trip{
int id;
int driver_id;
int vehicle_id;
double initial_lat;
double initial_long;
double last_lat;
double last_long;
String duration;
double distance;
String csvPath;
String videoPath;
String endTime;
String startTime;
bool sensorProcessed;
bool videoProcessed;
String safety_score;



Trip(this.id, this.driver_id, this.vehicle_id, this.initial_lat, this.initial_long, this.last_lat, this.last_long, this.duration
, this.distance, this.csvPath, this.videoPath, this.endTime, this.startTime, this.sensorProcessed, this.videoProcessed, this.safety_score);

factory Trip.fromJson(Map<String, dynamic> json) =>Trip(
  int.parse(json['id']), 
  int.parse(json['driver_id']), 
  int.parse(json['vehicle_id']), 
  double.parse(json['initial_lat']), 
  double.parse(json['initial_long']), 
  double.parse(json['last_lat']), 
  double.parse(json['last_long']), 
  json['duration'], 
  double.parse(json['distance']), 
  json['csvPath'].toString(), 
  json['videoPath'].toString(), 
  json['endTime'].toString(), 
  json['startTime'].toString(),
  json['sensorProcessed'],
  json["videoProcessed"], 
  json["tripScore"]
  );


  Map<String, dynamic> toJson() =>{
    'id': id.toString(),
    'driver_id': driver_id.toString(),
    'vehicle_id': vehicle_id.toString(),
    'initial_lat': initial_lat.toString(),
    'initial_long': initial_long.toString(),
    'last_lat': last_lat.toString(),
    'last_long': last_long.toString(),
    'duration': duration.toString(),
    'distance': distance.toString(),
    'csvPath': csvPath,
    'videoPath': videoPath,
    'endTime': endTime,
    'startTime': startTime,
    'sensorProcessed': sensorProcessed,
    'videoProcessed': videoProcessed,
    'tripScore': safety_score

  };

}