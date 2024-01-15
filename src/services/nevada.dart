import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';


class NevadaConn {

  Future<void> insertarDatosEnBaseDeDatos(double latitud, double longitud, List<dynamic> datos) async {

  try {
    final conn = await Connection.open(
    Endpoint(
      host: 'VMNevada',
      port: 5434,
      database: 'transporte',
      username: 'admin',
      password: '14nc4r1n4*',
    ),
    // The postgres server hosted locally doesn't have SSL by default. If you're
    // accessing a postgres server over the Internet, the server should support
    // SSL and you should swap out the mode with `SslMode.verifyFull`.
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );

    var date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  
    final result = await conn.execute(
      Sql.named('INSERT INTO chofer (cod_socio, nombre_socio, nombre_transporte, placa, nombre_vehiculo, latitud, longitud, fecha) VALUES (@cod_socio, @nombre_socio, @nombre_transporte, @placa, @nombre_vehiculo, @latitud, @longitud, @fecha)'),
      parameters: {
      'cod_socio': '${datos[0]['codigoSocio']}',
      'nombre_socio': '${datos[0]['nombreSocio']}',
      'nombre_transporte': '${datos[0]['nombreTransporte']}',
      'placa': '${datos[0]['placa']}',
      'nombre_vehiculo': '${datos[0]['nombreVehiculo']}', 
      'latitud': '$latitud',
      'longitud': '$longitud',
      'fecha': date
      },
    );
    print('Filas insertadas: ${result.affectedRows}');

     await conn.close();


  } catch (e) {
    print('Error al insertar datos en la base de datos: $e');
  } 
}


}