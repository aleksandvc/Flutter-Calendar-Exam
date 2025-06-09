import 'package:flutter/material.dart';
import 'package:flutter_calendar_exam/models/event.dart';
import '../services/event_service.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  String? _currentUserId;
  bool _showOnlyMyEvents = false;

  EventViewModel() {
    fetchEventsForDate(DateTime.now());
  }

  void toggleEventFilter(bool showMyEvents, String? userId) {
    _showOnlyMyEvents = showMyEvents;
    _currentUserId = showMyEvents ? userId : null;
    fetchEventsForDate(_selectedDate);
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    fetchEventsForDate(_selectedDate);
  }

  Future<void> fetchEventsForDate(DateTime date) async {
    _events = await _eventService.getEventsForDay(
      date,
      createdBy: _showOnlyMyEvents ? _currentUserId : null,
    );
    notifyListeners();
  }

  Future<void> addEvent(EventModel event) async {
    await _eventService.addEvent(event);
    fetchEventsForDate(_selectedDate);
  }

  Future<void> updateEvent(String id, EventModel event) async {
    await _eventService.updateEvent(id, event);
    fetchEventsForDate(_selectedDate);
  }

  Future<void> deleteEvent(String id) async {
    await _eventService.deleteEvent(id);
    fetchEventsForDate(_selectedDate);
  }
}
