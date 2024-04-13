import 'dart:ffi';

class Vehicle {
  int id;
  String license_plate;
  int type;
  int driver;



  Vehicle(this.id, this.license_plate, this.type, this.driver);
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
      int.parse(json["id"]),
      json["license_plate"],
      json["type"],
      json["driver"]);

  Map<String, dynamic> toJson() => {
    'id' : id.toString(),
    'license_plate' : license_plate,
    'type' : type.toString(),
    'driver' : driver.toString()
  };
}