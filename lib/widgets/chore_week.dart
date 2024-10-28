import 'package:choreapp_frontend/models/group.dart';
import 'package:choreapp_frontend/widgets/chore_display.dart';
import 'package:choreapp_frontend/widgets/chore_form.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ChoreWeek extends StatefulWidget {
  final void Function(DateTime? selectedDay)? onDaySelected;
  final DateTime? oldSelect;
  final Group group;
  const ChoreWeek(
      {super.key, this.onDaySelected, this.oldSelect, required this.group});

  @override
  State<ChoreWeek> createState() => _ChoreWeekState();
}

class _ChoreWeekState extends State<ChoreWeek> {
  DateTime date = DateUtils.dateOnly(DateTime.now());

  /// Get the Sunday of the current week
  DateTime getLastSunday() {
    int daysToSubtract = date.weekday % 7; // days since last Sunday
    return date.subtract(Duration(days: daysToSubtract));
  }

  /// Get the Saturday of the next week
  DateTime getNextSaturday() {
    int daysToNextSaturday =
        (6 - date.weekday + 7) % 7 + 7; // days to next Saturday
    return date.add(Duration(days: daysToNextSaturday));
  }

  DateTime _focusedDay = DateTime.now();
 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarFormat: CalendarFormat.week, // Default to week view
          availableCalendarFormats: const {
            CalendarFormat.week: 'Week', // Only week view allowed
          },

          focusedDay: _focusedDay,
          firstDay: getLastSunday(), // Start from last Sunday
          lastDay: getNextSaturday(), // End at next Saturday
          selectedDayPredicate: (day) {
            return isSameDay(widget.oldSelect, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            widget.onDaySelected?.call(selectedDay); // Call the callback
            if (!isSameDay(widget.oldSelect, selectedDay)) {
              setState(() {
                
                _focusedDay = focusedDay;
              });
            } else {
              setState(() {
                
                _focusedDay = focusedDay;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        if (widget.oldSelect != null)
          Flexible(
              child: ChoreDisplay(
            widget.oldSelect!,
            group: widget.group,
          )),
        if (widget.oldSelect != null)
          Row(
            children: [
              Flexible(
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => ChoreFormPopup(
                            selectedDay: widget.oldSelect,
                            group: widget.group,
                            onSave: () => _refreshChoreDisplay(),
                          ),
                        );
                      },
                      child: const Text('New Chore')))
            ],
          )
      ],
    );
  }

  void _refreshChoreDisplay() {
    if (mounted) {
      setState(() {});
    }
  }

  DateTime? getSelectedDay() {
    return widget.oldSelect;
  }
}
