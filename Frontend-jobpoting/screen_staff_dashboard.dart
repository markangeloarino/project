import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import 'screen_encode_vacancy.dart'; // From Frontend-staff

class ScreenStaffDashboard extends StatelessWidget {
  const ScreenStaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mediated Entry Staff Portal"),
        backgroundColor: Colors.green.shade700, // Different color to distinguish from Admin
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().currentUser = null;
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, ${user?['name'] ?? 'Staff Officer'}", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit_document),
              label: const Text("Encode Job Vacancy"),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScreenEncodeVacancy()));
              },
            ),
          ],
        ),
      ),
    );
  }
}