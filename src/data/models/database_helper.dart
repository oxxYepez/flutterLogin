// // database_helper.dart
// import 'package:postgres/legacy.dart';
// import 'package:postgres/postgres.dart';





// class DatabaseHelper {
//   late PostgreSQLConnection _connection;

//   DatabaseHelper({
//     required String host,
//     required int port,
//     required String databaseName,
//     required String username,
//     required String password,
//   }) {
//     PostgreSQLConnection(
//     host,
//     port,
//     databaseName, {
//     username,
//     password,
//     timeoutInSeconds = 30,
//     queryTimeoutInSeconds = 30,
//     timeZone = 'UTC',
//     useSSL = false,
//     isUnixSocket = false,
//   }) {
//     _connectionState = _PostgreSQLConnectionStateClosed();
//     _connectionState.connection = this;
//   }


//   Future<void> connect() async {
//     await _connection.open();
//   }

//   Future<Map<String, dynamic>> loginUser(String username, String password) async {
//     final result = await _connection.query(
//       'SELECT * FROM users WHERE username = @username AND password = @password',
//       substitutionValues: {'username': username, 'password': password},
//     );

//     if (result.isNotEmpty) {
//       final row = result.first;
//       return {
//         'userId': row[0], // Reemplaza con el índice correcto según tu esquema de base de datos
//         'username': row[1], // Reemplaza con el índice correcto según tu esquema de base de datos
//         // Agrega más campos según sea necesario
//       };
//     } else {
//       throw Exception('Error al iniciar sesión');
//     }
//   }

//   Future<void> sendLocation(Map<String, dynamic> locationData) async {
//     await _connection.query(
//       'INSERT INTO location_data (latitude, longitude, driver_id, date_time) VALUES (@latitude, @longitude, @driverId, @dateTime)',
//       substitutionValues: {
//         'latitude': locationData['latitude'],
//         'longitude': locationData['longitude'],
//         'driverId': locationData['driverId'],
//         'dateTime': locationData['dateTime'],
//       },
//     );
//   }

//   Future<void> close() async {
//     await _connection.close();
//   }
// }