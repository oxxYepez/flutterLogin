import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocateapp/src/services/locateServices.dart';
import 'package:geolocateapp/src/services/nevada.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocateScreen extends StatefulWidget {
   final List datos;

  GeoLocateScreen({required this.datos});
  
   @override
  _GeoLocateScreenState createState() => _GeoLocateScreenState(datos: datos);
}


  class _GeoLocateScreenState extends State<GeoLocateScreen> {
  final List datos;
  late Timer timer;
  _GeoLocateScreenState({required this.datos});
  StreamSubscription<Position>? positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    obtenerPermisosYUbicacion();
    // Inicia el temporizador para actualizar la posición cada 5 segundos
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      obtenerYMostrarPosicion();
    });
  }
              
  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    timer.cancel();
    super.dispose();
  }

    Future<void> obtenerPermisosYUbicacion() async {
      var status = await Permission.location.status;
      var services = false;
      LocateServices servicesLocate = LocateServices();
       try{
        bool  status_services = await servicesLocate.statusServices();
        if (status_services)  services=true; 
        }catch(error){
          _mostrarDialogo(context, error);
        }

      if (status.isGranted && services) {
        // Permiso concedido, puedes obtener la ubicación
        obtenerYMostrarPosicion();
      } else {
        // Si el permiso no está concedido, solicítalo
        await Permission.location.request();
      }
    }


  Future<void> obtenerYMostrarPosicion() async {
      try {
        LocateServices servicesLocate = LocateServices();
        NevadaConn nevadaConn = NevadaConn();

      positionStreamSubscription?.cancel();

      positionStreamSubscription = servicesLocate.getPositionStream().listen((Position position) {
      print('Posición: ${position.latitude}, ${position.longitude}');

      setState(() {
        datos[0]['latitud'] = position.latitude;
        datos[0]['longitud'] = position.longitude;
      });
      
      nevadaConn.insertarDatosEnBaseDeDatos(position.latitude, position.longitude, datos);
      });
      
      } catch (error) {
     
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error al obtener la posición', style: TextStyle(color: Colors.white),),
            backgroundColor: const Color.fromARGB(255, 207, 23, 9),
            content: Text(error.toString(), style:TextStyle(color: Colors.white),),
            actions: [
              TextButton(
                  style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 207, 23, 9), // Color del botón
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  child: Text('OK'),
                  ),
            ],
          );
        },
      );
    }


    }
    
    @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('GeoLocalización', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 207, 23, 9),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              _mostrarDialogoSalir(context);
            },
          ),
        ],
      ),
      
      body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 65.0),
                child: ListView.builder(
                  itemCount: datos.length,
                  itemBuilder: (context, index) {
                    final item = datos[index];
                    return ListTile(
                      title: Text(
                        'Código de Socio: ${item['codigoSocio']}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre de Socio: ${item['nombreSocio']}', style: TextStyle(fontSize: 16.0)),
                          Text('Nombre de Transporte: ${item['nombreTransporte']}', style: TextStyle(fontSize: 16.0)),
                          Text('Placa: ${item['placa']}', style: TextStyle(fontSize: 16.0)),
                          Text('Nombre de Vehículo: ${item['nombreVehiculo']}', style: TextStyle(fontSize: 16.0)),
                          Text('Latitud: ${item['latitud']}', style: TextStyle(fontSize: 16.0)),
                          Text('Longitud: ${item['longitud']}', style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                      // Puedes agregar más personalización según tus necesidades
                    );
                  },
                ),
              ),
            ),

          ],
        ),
        );

  }

  }

  void _mostrarDialogo(BuildContext context, error) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,),
              backgroundColor: Color.fromARGB(255, 189, 180, 180),
              content: Text('$error'),
              actions: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 207, 23, 9), // Color del botón
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }

  Future<void> _mostrarDialogoSalir(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera del diálogo
      builder: (BuildContext context) {
        return AlertDialog(
        title: Text(
          '¿Realmente quieres salir?',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromARGB(255, 189, 180, 180),
        content: ButtonBar(
          alignment: MainAxisAlignment.center, // Centra los botones
          children: [
            TextButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 207, 23, 9), // Color del botón
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              // Color del botón
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 207, 23, 9), // Color del botón
              ),
              child: Text(
                'Salir',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                SystemNavigator.pop();// Cierra la App
              },
            ),
          ],
        ),
      );
      },
      );
    }




