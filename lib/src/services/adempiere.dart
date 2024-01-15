import 'package:postgres/postgres.dart';

class AdempiereConn{

   Future<List> conn(String placa,List<dynamic> datos) async{

    try{
    final conn = await Connection.open(
    Endpoint(
      host: 'losroques',
      port: 5434,
      database: 'adempiere',
      username: 'adempiere',
      password: 'ad3mp13r3sf1d4.*',
    ),
    // The postgres server hosted locally doesn't have SSL by default. If you're
    // accessing a postgres server over the Internet, the server should support
    // SSL and you should swap out the mode with `SslMode.verifyFull`.
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
  
  final result = await conn.execute(
    Sql.named('SELECT cb.value as codigo_socio, cb.name as nombre_socio, ms.name as nombre_transporte, fv.VehiclePlate as placa, fv.Name as nombre_vehiculo FROM C_BPartner cb JOIN M_Shipper ms on ms.C_BPartner_ID = cb.C_BPartner_ID JOIN FTA_Vehicle fv on fv.M_Shipper_ID = ms.M_Shipper_ID where fv.VehiclePlate=@placa'),
    parameters: {'placa': '$placa'},
  );
  
    List<Map<String, dynamic>> data = [];

    for (var row in result) {
      data.add({
        'codigoSocio': row[0],
        'nombreSocio': row[1],
        'nombreTransporte': row[2],
        'placa': row[3],
        'nombreVehiculo': row[4],
      });
    }

  datos.addAll(data);

   await conn.close();
   return data;
   } 
   catch (e) {
      List<Map<String, dynamic>> data = [];
      print('Error de conexión: $e');
       return data;// La conexión falló
    }
   }
  }