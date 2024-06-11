// class API{
//   // connection to api service
//   static const hostConnect = "http://192.168.1.4:8000";
  
//   static const hostConnectAuth = "$hostConnect/authentication";
//     static const hostConnectTrip = "$hostConnect/trips";

//   static const signup = "$hostConnectAuth/signup/";
//   static const login = "$hostConnectAuth/login/";
//   static const validateEmail = "$hostConnectAuth/validate_email/";
//   static const getVehicleByDriver = "$hostConnectAuth/get_vehicle_by_driver/";
//   static const editProfile = "$hostConnectAuth/editProfile/";
//   static const uploadsensordata = "$hostConnectAuth/upload_sensor_data/";
// static const uploadvideodata = "$hostConnectAuth/upload_video_data/"; 
// static const saveTrip = "$hostConnectTrip/save_trip/"; 
// static const getDriverTrips = "$hostConnectTrip/get_driver_trips/"; 


//   // static const hostConnect = "https://drivesafeapp-a301fe33a058.herokuapp.com/";
//   // static const validateEmail = "$hostConnectAuth/validate_email/";
//   // static const getVehicleByDriver = "$hostConnectAuth/get_vehicle_by_driver/";



// }



class API {
  // Private constructor
  API._();

  // Singleton instance
  static late API _instance;

  // Getter for singleton instance
  static API get instance {
    // Create instance if it doesn't exist
    _instance ??= API._();
    return _instance;
  }

  // Connection to API service
  static const String _hostConnect = "http://192.168.92.80:8000";

  static const String _hostConnectAuth = "$_hostConnect/authentication";
  static const String _hostConnectTrip = "$_hostConnect/trips";

  static const String signup = "$_hostConnectAuth/signup/";
  static const String login = "$_hostConnectAuth/login/";
  static const String validateEmail = "$_hostConnectAuth/validate_email/";
  static const String getVehicleByDriver = "$_hostConnectAuth/get_vehicle_by_driver/";
  static const String editProfile = "$_hostConnectAuth/editProfile/";
  static const String uploadsensordata = "$_hostConnectAuth/upload_sensor_data/";
  static const String uploadvideodata = "$_hostConnectAuth/upload_video_data/";
  static const String saveTrip = "$_hostConnectTrip/save_trip/";
  static const String getTripEvents = "$_hostConnectTrip/get_trip_events/";
  static const String getDriverTrips = "$_hostConnectTrip/get_driver_trips/";
}
