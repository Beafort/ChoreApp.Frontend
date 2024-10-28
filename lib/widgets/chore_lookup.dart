import 'package:choreapp_frontend/clients/chore_client.dart';
import 'package:choreapp_frontend/models/chore.dart';
import 'package:flutter/material.dart';

class ChoreLookup extends StatefulWidget {
  const ChoreLookup({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChoreLookup();
  }
}

class _ChoreLookup extends State<ChoreLookup> {
  ChoreClient choreClient = ChoreClient();
  Future<Chore>? futureChore; // Initialize as nullable
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding for better spacing
      child: Row(
        children: [
          Expanded(
            child: FutureBuilder<Chore>(
              future: futureChore,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Text(snapshot.data!.name);
                } else if (snapshot.hasError) {
                  final errorMessage = snapshot.error.toString();
                  return Text(errorMessage.replaceFirst('Exception: ', ''));
                }
                // When futureChore is null, show a placeholder
                return const Text('Enter a chore ID and press Reload');
              },
            ),
          ),
          const SizedBox(width: 16), // Add spacing between widgets
          Expanded(
            flex: 2, // Adjust the ratio of space the TextField takes
            child: TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: myController,
            ),
          ),
          const SizedBox(width: 16), // Add spacing between widgets
          TextButton(
            onPressed: reload,
            child: const Text('Reload'),
          ),
        ],
      ),
    );
  }

  void reload() {
    setState(() {
      futureChore = ChoreClient().getChoreById(int.parse(myController.text));
    });
  }
}
