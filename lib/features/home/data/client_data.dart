import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchClients() async {
  String username = 'c513e16bfad60ed5';
  String password = 'lNxtrRja7W9CtpYT8objV4aA4gxZcJvHyV6bwwZsuf3G';
  String url = 'http://mqtt.onwords.in:18083/api/v5/clients';

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  var headers = <String, String>{
    'content-type': 'application/json',
    'authorization': basicAuth,
  };

  try {
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> clients = data['data'] ?? [];

      List<Map<String, dynamic>> clientDataList = [];

      for (var client in clients) {
        var clientId = client['clientid'];
        var connectedAt = client['connected_at'];
        var ipAddress = client['ip_address'];

        var clientData = {
          'clientId': clientId,
          'connectedAt': connectedAt,
          'ipAddress': ipAddress,
        };

        clientDataList.add(clientData);
      }

      return clientDataList;
    } else {
      // Handle the error as needed
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    // Handle the exception as needed
    throw Exception('Exception occurred: $e');
  }
}
