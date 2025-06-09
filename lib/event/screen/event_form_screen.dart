import 'package:flutter/material.dart';
import 'package:flutter_calendar_exam/models/event.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/event_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventFormScreen extends StatefulWidget {
  final EventModel? event;

  const EventFormScreen({super.key, this.event});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descController = TextEditingController(text: widget.event?.description ?? '');
    _startTime = widget.event?.startTime ?? _startTime;
    _endTime = widget.event?.endTime ?? _endTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startTime : _endTime;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (time == null) return;

    final selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _startTime = selected;
        if (_endTime.isBefore(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = selected;
      }
    });
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() != true) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final event = EventModel(
      id: widget.event?.id ?? '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      startTime: _startTime,
      endTime: _endTime,
      createdBy: uid,
      createdAt: widget.event?.createdAt ?? DateTime.now(),
    );

    final vm = Provider.of<EventViewModel>(context, listen: false);

    if (widget.event == null) {
      vm.addEvent(event);
    } else {
      vm.updateEvent(widget.event!.id, event);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Event' : 'Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description (optional)'),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text('Start: ${_startTime.toLocal()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, true),
              ),
              ListTile(
                title: Text('End: ${_endTime.toLocal()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submit(context),
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}