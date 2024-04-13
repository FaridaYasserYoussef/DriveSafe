import 'dart:ffi';

class Driver {
  int id;
  String username;
  String email;
  String password;
  int age;
  String gender;
  double safety_score;


  Driver(this.id, this.username, this.email, this.password, this.age, this.gender, this.safety_score);
  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
      int.parse(json["id"]),
      json["username"],
      json["email"],
      json["password"],
      json["age"],
      json["gender"],
      json["safety_score"]
      );

  Map<String, dynamic> toJson() => {
    'id' : id.toString(),
    'username' : username,
    'email' : email,
    'password' : password,
    'age' : age.toString(),
    'gender' : gender,
    'safety_score' : safety_score.toString()

  };
}