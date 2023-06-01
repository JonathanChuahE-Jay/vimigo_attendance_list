import 'package:flutter/material.dart';
import 'package:vimigo_attendance_list/pages/New%20attendee.dart';
import 'package:vimigo_attendance_list/pages/display_attendance.dart';
import 'package:vimigo_attendance_list/pages/home.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/display' : (context) => DisplayAttendance(),
      '/newattendee' : (context) => NewAttendance(),
    },
  ));
}

