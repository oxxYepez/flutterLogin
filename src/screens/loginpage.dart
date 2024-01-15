import 'package:flutter/material.dart';
import 'package:geolocateapp/src/screens/geolocate.dart';
import 'package:geolocateapp/src/services/adempiere.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _placaController = TextEditingController();
  AdempiereConn _adempiereConn = AdempiereConn();
  late List<dynamic> datos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 180, 180),
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 207, 23, 9),
        centerTitle: true,
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Container(
              margin: EdgeInsets.only(top: 70.0),
              child: const Image(
                image: AssetImage('lib/assets/MaryLogo-removebg-preview.png'), 
                width: 200,
                height: 200,
                alignment: Alignment.topCenter,),
                ),
            TextField(
              controller: _placaController,
              cursorColor: Colors.white,
              textAlign: TextAlign.center,
              style: TextStyle(
              color: Colors.white, // Cambia el color del texto ingresado
            ),
              decoration: const InputDecoration(
                labelText: 'Ingrese Placa del Vehiculo',
                labelStyle: TextStyle(color: Colors.white),
                floatingLabelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), 
                  ),
                enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
                fillColor: Colors.white,
                
            ),
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _login(),
              style: ElevatedButton.styleFrom(
              primary:Color.fromARGB(255, 207, 23, 9),// Color del botón
            ),
              child: Text('Iniciar sesión', 
              style: TextStyle(
              color: Colors.white, // Color del texto
            ),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    String placa = _placaController.text;
   
    await _adempiereConn.conn(placa, datos);

    if (datos.isNotEmpty) {
      // Navegar a la pantalla vacía si la conexión fue exitosa
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GeoLocateScreen(datos:datos)),
      );
    } else {
      // Mostrar mensaje de error si la conexión falló
       showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 189, 180, 180),
          title: Text('Error', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
          content: Text('Error de conexión. Verifica la placa ingresada.', style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
              primary:Color.fromARGB(255, 207, 23, 9),// Color del botón
            ),
              onPressed: () => Navigator.pop(context),
              child: Text('Aceptar', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );
    }
  }
}