import 'package:choreapp_frontend/clients/group_client.dart';
import 'package:choreapp_frontend/clients/user_client.dart';
import 'package:choreapp_frontend/models/group.dart';
import 'package:choreapp_frontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:choreapp_frontend/widgets/chore_week.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
UserClient userClient = UserClient();
GroupClient groupClient = GroupClient();
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? dayString;
  DateTime? day;
  User? user;
  Group? group;
  int? groupId;
  DateTime? _selectedDay; // Moved this to parent
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // Retrieve groupId from the route arguments
    groupId = ModalRoute.of(context)?.settings.arguments as int?;

    user = await userClient.getUser();
    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return; 
    }
    if (groupId != null) {
      group = await groupClient.getGroupById(groupId!);
    } else {
      
      List<Group> userGroups = await user!.getGroups();
      
      if (userGroups.isNotEmpty) {
        group = userGroups[0]; 
      }
    }
    
    if (mounted) {
      setState(() {});
    }
  }
  void _handleDaySelected(DateTime? selectedDay) {
    if (selectedDay != null) {
      dayString = formatDate(selectedDay);
      day = selectedDay;
      _selectedDay = selectedDay; // Store the selected day here
    } else {
      dayString = 'No day selected';
      day = null;
      _selectedDay = null; // Reset if no day is selected
    }
    setState(() {}); // Rebuild when the day is selected
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chore Distribution App (Very early development)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        key: GlobalKey(),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Text(user == null ? 'null' : user!.name),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                userClient.logout();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red),),
              child: const Text("Log out"),
            ),
    // You can add more buttons or widgets here if needed
  ],
        ),
        body: Column(
          children: [
            Row(children: [
              const SizedBox(width: 20,),
              Text(group == null ? "" : group!.name),
              const SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () {
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/group');
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen),),
                child: const Text("Choose Group")
              ),
              const SizedBox(width: 20,),
              ElevatedButton(
                  onPressed: () {
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(
                      context, 
                      '/group/view',
                      arguments: group, // Passing the group variable as arguments
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen),
                  ),
                  child: const Text("View Group"),
                )
              ],
            ),
            Expanded(
              child: group != null
                  ? ChoreWeek(
                      onDaySelected: _handleDaySelected,
                      oldSelect: _selectedDay, // Pass the selected day to ChoreWeek
                      group: group!,
                    )
                  : const Center(child: Text("CHOOSE A GROUP")),
            ),
            if (dayString != null)
              Text("Chores for day of: ${dayString!}"), // Show the selected day
          ],
        ),
      ),
    );
  }
}


