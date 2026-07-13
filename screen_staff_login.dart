import 'package:flutter/material.dart';
import 'package:neis_cap/Frontend-admin/screen_admin_dashboard.dart';
import 'package:neis_cap/Frontend-jobpoting/screen_staff_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:neis_cap/auth_provider.dart';
import 'Frontend-admin/screen_admin_dashboard.dart' as admin; // It is in the same folder
import 'Frontend-jobpoting/screen_staff_dashboard.dart'
    as staff; // Going up one level, then into the staff folder

// admin@naga.gov.ph
// admin123


class ScreenStaffLogin extends StatefulWidget {
  const ScreenStaffLogin({super.key});

  @override
  State<ScreenStaffLogin> createState() => _ScreenStaffLoginState();
}

class _ScreenStaffLoginState extends State<ScreenStaffLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            margin: const EdgeInsets.all(30.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 80,
                  color: Colors.blue.shade900,
                ),
                const SizedBox(height: 20),
                Text(
                  "Metro PESO Portal",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Staff Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                if (authProvider.errorMessage != null)
                  Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue.shade900,
                          foregroundColor: Colors.white,
                        ),
                        // Make sure to import both dashboards at the top of your login screen:

                        // Inside your login button's onPressed:
                        onPressed: () async {
                          String? role = await context
                              .read<AuthProvider>()
                              .staffLogin(
                                _emailController.text,
                                _passwordController.text,
                              );

                          if (!mounted) return;

                          // ... inside the login onPressed function:
                          if (role == 'Admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenAdminDashboard(),
                              ),
                            );
                          } else if (role == 'Staff') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenStaffDashboard(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Admin Login",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
