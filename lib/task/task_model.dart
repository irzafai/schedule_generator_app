import 'package:flutter/material.dart';

class Task {
  String title;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String description;
  DateTime createdAt;

  Task({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.createdAt,
  });
}
