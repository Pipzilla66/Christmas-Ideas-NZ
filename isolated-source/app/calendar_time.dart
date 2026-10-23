import 'package:flutter/material.dart';

DateTime nzCalendarToday([DateTime? clock]) {
  final utc = (clock ?? DateTime.now()).toUtc();
  DateTime transition(int year, int month) {
    final end = DateTime.utc(year, month + 1, 0);
    final first = DateTime.utc(year, month, 1);
    final sunday = month == 4 ? first.add(Duration(days: (7-first.weekday)%7)) : end.subtract(Duration(days: end.weekday % 7));
    return sunday
        .subtract(const Duration(days: 1))
        .add(const Duration(hours: 14));
  }

  final summer = !utc.isBefore(transition(utc.year,9)) || utc.isBefore(transition(utc.year,4));
  return DateUtils.dateOnly(utc.add(Duration(hours: summer ? 13 : 12)));
}

