import 'package:flutter/material.dart';
import 'package:neis_cap/Frontend-jobpoting/vacancy_provider.dart';
import 'package:neis_cap/auth_provider.dart';
import 'package:provider/provider.dart'; 
import '../screen_login.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  
  @override
  void initState() {
    super.initState();
    // Fetch the jobs exactly when this screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VacancyProvider>().fetchVacancies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final vacancyProvider = context.watch<VacancyProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Metro PESO - Public Job Board"),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authProvider.currentUser = null;
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const ScreenLogin())
              );
            },
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Text(
                  "Welcome, ${user?['first_name'] ?? 'Job Seeker'}!", 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Latest opportunities encoded by Metro PESO:",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 20),
              
              // The Live Job List
              Expanded(
                child: vacancyProvider.isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : vacancyProvider.errorMessage != null
                      ? Center(child: Text(vacancyProvider.errorMessage!, style: const TextStyle(color: Colors.red)))
                      : vacancyProvider.activeJobs.isEmpty
                          ? const Center(child: Text("No jobs posted yet. Check back later!", style: TextStyle(fontSize: 16)))
                          : ListView.builder(
                              itemCount: vacancyProvider.activeJobs.length,
                              itemBuilder: (context, index) {
                                final job = vacancyProvider.activeJobs[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(20),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.blue.shade100,
                                      child: Icon(Icons.work, color: Colors.blue.shade900),
                                    ),
                                    title: Text(
                                      job['job_title'] ?? 'Unknown Title', 
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Employer: ${job['employer_name'] ?? 'Unknown'}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () async {
                                        // Ensure we have a logged-in user with an ID
                                        final seekerId = user?['seeker_id'] ?? user?['id']; 
                                        final vacancyId = job['vacancy_id'];

                                        if (seekerId != null && vacancyId != null) {
                                          bool success = await vacancyProvider.applyForJob(seekerId, vacancyId);
                                          
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(success 
                                                  ? "Application submitted successfully!" 
                                                  : vacancyProvider.errorMessage ?? "Error occurred"),
                                                backgroundColor: success ? Colors.green : Colors.red,
                                              )
                                            );
                                          }
                                        } else {
                                           ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Error: Missing user or job data."))
                                           );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      ),
                                      child: const Text("Apply Now", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                );
                              },
                            ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}