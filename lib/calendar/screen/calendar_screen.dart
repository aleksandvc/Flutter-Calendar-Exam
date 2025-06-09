import 'package:flutter/material.dart';
import 'package:flutter_calendar_exam/event/screen/event_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../viewmodels/event_viewmodel.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventViewModel>(context);
    final events = viewModel.events;
    final selectedDate = viewModel.selectedDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDate,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: (selected, focused) {
              viewModel.setDate(selected);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text("No events for this day."))
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.startTime.toLocal().toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventFormScreen(event: event),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                viewModel.deleteEvent(event.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EventFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
