import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<ConnectivityResult> get isConnected;
}

class NetworkInfoImp implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  // final Future<ConnectivityResult> result = Connectivity().checkConnectivity();

  NetworkInfoImp(this.connectionChecker);

  @override
  Future<ConnectivityResult> get isConnected =>
      Connectivity().checkConnectivity();
  // Future<bool> get isConnected => connectionChecker.hasConnection;
}
