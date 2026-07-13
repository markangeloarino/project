import 'package:flutter/material.dart';
import 'package:neis_cap/Frontend-jobpoting/screen_encode_vacancy.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart'; 
import '../screen_staff_login.dart';

class ScreenStaffDashboard extends StatelessWidget {
  const ScreenStaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mediated Entry Staff Portal"),
        backgroundColor: Colors.green.shade700, 
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().currentUser = null;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ScreenStaffLogin()));
            },
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome, ${user?['name'] ?? 'Staff Officer'}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const Text("Select a module below to process employer requests and assist job seekers.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 40),
                
                Row(
                  children: [
                    _buildStaffCard(
                      context,
                      title: "Encode Vacancy\n(For Employers)",
                      icon: Icons.post_add,
                      color: Colors.green.shade700,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScreenEncodeVacancy())),
                    ),
                    const SizedBox(width: 20),
                    _buildStaffCard(
                      context,
                      title: "Job Matching\n(Review Applicants)",
                      icon: Icons.handshake,
                      color: Colors.teal.shade600,
                      onTap: () {
                        // TODO: Route to Job Matching Module once completed
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job Matching module under construction.")));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Column(
              children: [
                Icon(icon, size: 60, color: color),
                const SizedBox(height: 20),
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}