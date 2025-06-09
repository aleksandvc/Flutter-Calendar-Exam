import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_exam/login/login_page.dart';
import 'package:flutter_calendar_exam/viewmodels/auth_viewmodel.dart';
import 'package:flutter_calendar_exam/viewmodels/event_viewmodel.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authViewModel = Provider.of<AuthViewModel>(context);
    final eventViewModel = Provider.of<EventViewModel>(context);
    final userEvents = eventViewModel.events.where((e) => e.createdBy == user?.uid).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: user == null
            ? const Center(child: Text("No user logged in."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${user.displayName ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Email: ${user.email}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      
                      authViewModel.logout();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                  const SizedBox(height: 24),
                  const Text("My Events:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: userEvents.isEmpty
                        ? const Text("You have not created any events.")
                        : ListView.builder(
                            itemCount: userEvents.length,
                            itemBuilder: (_, index) {
                              final event = userEvents[index];
                              return ListTile(
                                title: Text(event.title),
                                subtitle: Text(event.startTime.toLocal().toString()),
                              );
                            },
                          ),
                  )
                ],
              ),
      ),
    );
  }
}
