import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class DisplayAttendance extends StatefulWidget {
  const DisplayAttendance({Key? key}) : super(key: key);

  @override
  State<DisplayAttendance> createState() => _DisplayAttendanceState();
}

class _DisplayAttendanceState extends State<DisplayAttendance> {
  List<String> names = [];
  List<String> phoneNumbers = [];
  List<DateTime> dates = [];
  List<bool> showTimeAgo = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    final databasePath = await getDatabasesPath();
    final String path = join(databasePath!, 'attendance.db');
    final database = await openDatabase(path);

    final List<Map<String, dynamic>> queryResult =
    await database.query('attendance', orderBy: 'time DESC');

    setState(() {
      names = queryResult.map((entry) => entry['name'] as String).toList();
      phoneNumbers =
          queryResult.map((entry) => entry['phoneNumber'] as String).toList();
      dates = queryResult
          .map((entry) => DateTime.parse(entry['time'] as String))
          .toList();
      showTimeAgo = List<bool>.filled(dates.length, false);
    });

    await database.close();
  }

  void toggleDisplay(int index) {
    setState(() {
      showTimeAgo[index] = !showTimeAgo[index];
    });
  }

  List<int> getFilteredIndexes() {
    if (searchQuery.isEmpty) {
      return List.generate(names.length, (index) => index);
    } else {
      final filteredIndexes = <int>[];
      for (int i = 0; i < names.length; i++) {
        if (names[i].toLowerCase().contains(searchQuery.toLowerCase())) {
          filteredIndexes.add(i);
        }
      }
      return filteredIndexes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredIndexes = getFilteredIndexes();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Vimigos Attendance lists'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.grey[300],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Phone Number',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          for (int i = 0; i < showTimeAgo.length; i++) {
                            setState(() {
                              showTimeAgo[i] = !showTimeAgo[i];
                            });
                          }
                        },
                        child: Icon(
                          showTimeAgo.contains(true)
                              ? Icons.timer
                              : Icons.access_time,
                          size: 20,
                          color: showTimeAgo.contains(true)
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredIndexes.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredIndexes.length) {
                  return const ListTile(
                    title: Center(
                      child: Text(
                        "You've reached the end of the list",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                final dataIndex = filteredIndexes[index];
                final malaysiaTime = dates[dataIndex];
                final formattedDate =
                DateFormat('yyyy-MM-dd').format(malaysiaTime);
                final formattedTime =
                DateFormat('HH:mm').format(malaysiaTime);

                final timeDisplay = showTimeAgo[dataIndex]
                    ? timeago.format(malaysiaTime)
                    : '$formattedDate $formattedTime';

                return ListTile(
                  title: GestureDetector(
                    onTap: () => toggleDisplay(dataIndex),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(names[dataIndex]),
                          ),
                          Expanded(
                            child: Text(phoneNumbers[dataIndex]),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                timeDisplay,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newattendee');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
