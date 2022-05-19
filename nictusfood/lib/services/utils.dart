import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Util {
  Future<bool> isConnected() async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.wifi) {
      if (await InternetConnectionChecker().hasConnection) {
        // print("Wifi connection detected and fonctionne");
        return true;
      } else {
        // print("Not connection wifi");
        return false;
      }
    } else if (connectivity == ConnectivityResult.mobile) {
      if (await InternetConnectionChecker().hasConnection) {
        // print("Mobile connection detected and fonctionne");
        return true;
      } else {
        // print("Not connection mobile");
        return false;
      }
    } else {
      // print("Not connection ");
      return false;
    }
  }
}
