import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocateServices{
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
    Future<bool> statusServices() async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Servicio de localizacion no disponible.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Denegado permiso de Localizacion');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permiso de localizacion permanentemente denegado.');
    }

    return serviceEnabled;
  }  


    Stream<Position> getPositionStream() {
      try {
      return Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 1,
        intervalDuration: const Duration(seconds: 20),
        forceAndroidLocationManager: true,
      );
    } catch (error) {
      print('Error en la obtención de la posición: $error');
      throw error;
    }
    }
}