class API{
  // connection to api service
  static const hostConnect = "http://192.168.1.34:8000";
  
  static const hostConnectAuth = "$hostConnect/authentication";
  static const signup = "$hostConnectAuth/signup/";
  static const login = "$hostConnectAuth/login/";
  static const validateEmail = "$hostConnectAuth/validate_email/";


  // static const hostConnect = "https://drivesafeapp-a301fe33a058.herokuapp.com/";
  // static const validateEmail = "$hostConnectAuth/validate_email/";
  // static const getVehicleByDriver = "$hostConnectAuth/get_vehicle_by_driver/";



}