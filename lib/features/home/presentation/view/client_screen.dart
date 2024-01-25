import 'package:flutter/material.dart';
import '../../data/client_data.dart';

class ClientScreen extends StatefulWidget {
  final List<Map<String, dynamic>> clients;

  ClientScreen({required this.clients});

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  List<Map<String, dynamic>> clientsData = [];
  int totalConnections = 0;

  @override
  void initState() {
    super.initState();
    clientsData = widget.clients;
    totalConnections = clientsData.length;
  }

  void searchClients(String searchText) {
    setState(() {
      clientsData = widget.clients.where((client) {
        String clientId = (client['clientId'] ?? '').toLowerCase();
        return clientId.contains(searchText.toLowerCase());
      }).toList();
      totalConnections = clientsData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Data'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ClientSearchDelegate(widget.clients),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TotalConnectionsCircle(totalConnections: totalConnections),
            SizedBox(height: 20),
            Text(
              'Total Connections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: clientsData.length,
                itemBuilder: (context, index) {
                  var client = clientsData[index];
                  var clientId = client['clientId'] ?? 'N/A';
                  var connectedAt = client['connectedAt'] ?? 'N/A';
                  var ipAddress = client['ipAddress'] ?? 'N/A';

                  // Format the connection time for better readability
                  DateTime connectionTime = DateTime.parse(connectedAt);
                  String formattedTime =
                      "${connectionTime.year}-${connectionTime.month}-${connectionTime.day} ${connectionTime.hour}:${connectionTime.minute}:${connectionTime.second}";

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        '$clientId',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IP - $ipAddress',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'Connected At - $formattedTime',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TotalConnectionsCircle extends StatelessWidget {
  final int totalConnections;

  TotalConnectionsCircle({required this.totalConnections});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.purple],
        ),
      ),
      child: Center(
        child: Text(
          '$totalConnections',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ClientSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> clients;

  ClientSearchDelegate(this.clients);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> suggestionList = query.isEmpty
        ? []
        : clients.where((client) {
            String clientId = (client['clientId'] ?? '').toLowerCase();
            return clientId.contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        var client = suggestionList[index];
        var clientId = client['clientId'] ?? 'N/A';
        var connectedAt = client['connectedAt'] ?? 'N/A';
        var ipAddress = client['ipAddress'] ?? 'N/A';

        // Format the connection time for better readability
        DateTime connectionTime = DateTime.parse(connectedAt);
        String formattedTime =
            "${connectionTime.year}-${connectionTime.month}-${connectionTime.day} ${connectionTime.hour}:${connectionTime.minute}:${connectionTime.second}";

        return Card(
          elevation: 4,
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              '$clientId',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IP - $ipAddress',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Connected At - $formattedTime',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
