import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_calendar_exam/models/event.dart';

class EventService {
  final _eventsCollection = FirebaseFirestore.instance.collection('events');

  Future<void> addEvent(EventModel event) async {
    await _eventsCollection.add(event.toMap());
  }

  Future<void> updateEvent(String id, EventModel event) async {
    await _eventsCollection.doc(id).update(event.toMap());
  }

  Future<void> deleteEvent(String id) async {
    await _eventsCollection.doc(id).delete();
  }

  Stream<List<EventModel>> getEventsStream({String? createdBy}) {
    Query query = _eventsCollection.orderBy('startTime');

    if (createdBy != null) {
      query = query.where('createdBy', isEqualTo: createdBy);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<List<EventModel>> getEventsForDay(DateTime day, {String? createdBy}) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    Query query = _eventsCollection
        .where('startTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('startTime', isLessThan: endOfDay.toIso8601String());

    if (createdBy != null) {
      query = query.where('createdBy', isEqualTo: createdBy);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
