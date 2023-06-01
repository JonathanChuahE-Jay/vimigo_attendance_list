import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NewAttendance extends StatefulWidget {
  const NewAttendance({Key? key}) : super(key: key);

  @override
  State<NewAttendance> createState() => _NewAttendanceState();
}

class _NewAttendanceState extends State<NewAttendance> {
  String enteredName = '';
  String enteredPhoneNumber = '';

  Future<Database> openDatabaseConnection() async {
    final databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'attendance.db');
    return openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE attendance(
            id INTEGER PRIMARY KEY,
            name TEXT,
            phoneNumber TEXT,
            time TEXT
          )
        ''');
    });
  }

  Future<void> saveData(BuildContext context) async {
    final name = enteredName;
    final phoneNumber = enteredPhoneNumber;
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(DateTime.now());

    final database = await openDatabaseConnection();
    final data = {
      'name': name,
      'phoneNumber': phoneNumber,
      'time': timestamp,
    };

    try {
      await database.insert('attendance', data);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('User entered successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Failed to save data: $error');
    } finally {
      await database.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Vimigos Attendance lists'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/display');
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name: ",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      enteredName = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Phone Number: ",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      enteredPhoneNumber = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Current time is: ",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(DateTime.now()),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => saveData(context),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
