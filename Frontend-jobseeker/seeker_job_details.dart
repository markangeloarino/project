import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neis_cap/Frontend-jobposting/post_vacancy_provider.dart';
import 'package:neis_cap/Frontend-jobseeker/seeker_profile.dart';
import 'package:neis_cap/Frontend-jobseeker/seeker_dashboard.dart';
import 'package:neis_cap/auth_provider.dart';
import 'package:neis_cap/screen_login.dart';
import 'package:neis_cap/screen_singup.dart';
import 'package:provider/provider.dart';

class ScreenSeekerJobDetails extends StatefulWidget {
  final Map<String, dynamic> job;

  const ScreenSeekerJobDetails({super.key, required this.job});

  @override
  State<ScreenSeekerJobDetails> createState() => _ScreenSeekerJobDetailsState();
}

class _ScreenSeekerJobDetailsState extends State<ScreenSeekerJobDetails> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final vacancyProvider = context.watch<VacancyProvider>();
    final user = authProvider.currentUser;

    // Parse Date
    String postedDate = 'N/A';
    if (widget.job['date_posted'] != null) {
      postedDate = DateFormat(
        'd MMMM yyyy',
      ).format(DateTime.parse(widget.job['date_posted'].toString()).toLocal());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0,
        toolbarHeight: 85,
        automaticallyImplyLeading: false,
        titleSpacing: 0, // Removes default edge padding so it aligns perfectly
        centerTitle: true,
        title: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ), // Matches the body container
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Matches body padding
            child: Row(
              children: [
                // Official Seals / Logos
                Image.asset('assets/naga.png', height: 70, fit: BoxFit.contain),
                const SizedBox(width: 10),
                Image.asset('assets/peso.png', height: 70, fit: BoxFit.contain),
                const SizedBox(width: 15),
                // Logo Text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Naga Job",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 1.2,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Dashboard Navigation Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenSeekerDashboard(),
                      ),
                    );
                  },
                  child: const Text(
                    "Dashboard",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Profile Navigation Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenSeekerProfile(),
                      ),
                    );
                  },
                  child: const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Dropdown Menu triggered by the Profile Picture Circle (Now only for Logout)
                PopupMenuButton<String>(
                  offset: const Offset(
                    0,
                    50,
                  ), // Pushes the dropdown slightly below the app bar
                  tooltip: 'Account Menu',
                  onSelected: (String value) {
                    if (value == 'logout') {
                      authProvider.currentUser = null;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScreenLogin(),
                        ),
                      );
                    }
                  },
                  // The Profile Picture Circle
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF0D47A1),
                      ), // Using an icon until a real image is added
                    ),
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: ListTile(
                            leading: Icon(Icons.logout, color: Colors.red),
                            title: Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        // Centers the content
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ), // Matches AppBar constraint
          child: SingleChildScrollView(
            // Removed horizontal padding here to allow the ConstrainedBox to handle alignment
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageHeader(),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT COLUMN
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderCard(),
                          const SizedBox(height: 20),
                          _buildContentCard(
                            "Job Description",
                            widget.job['job_description'] ?? 'No description.',
                            postedDate,
                          ),
                          _buildContentCard(
                            "Qualifications",
                            widget.job['qualifications'] ??
                                'No qualifications.',
                            null,
                          ),

                          // NEW: Additional Meta Details
                          Row(
                            children: [
                              Expanded(
                                child: _buildContentCard(
                                  "Industry",
                                  widget.job['industry'] ?? 'N/A',
                                  null,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildContentCard(
                                  "Job Scope",
                                  widget.job['job_location_type'] ?? 'N/A',
                                  null,
                                ),
                              ),
                            ],
                          ),
                          _buildContentCard(
                            "Employment Type",
                            widget.job['employment_type'] ?? 'N/A',
                            null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),

                    // RIGHT COLUMN: Sidebar
                    Expanded(
                      flex: 1,
                      child: _buildSidebar(context, user, vacancyProvider),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Job details",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            color: Colors.grey.shade200,
            child: const Icon(Icons.business, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job['job_title']?.toUpperCase() ?? 'JOB TITLE',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  widget.job['employer_name'] ?? 'EMPLOYER NAME',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.job['location'] ?? 'Location not specified',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add this to your ScreenJobDetails class
  Widget _buildContentCard(String title, String content, String? date) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (date != null)
                Text(
                  "Posted on $date",
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
          const Divider(height: 30),
          Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    Map<String, dynamic>? user,
    VacancyProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Apply Button - Now functional
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue,
            ),
            onPressed: () => _apply(user, widget.job, provider),
            child: const Text(
              "APPLY NOW",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          // Job Stats (rest of your sidebar items...)
          _buildSidebarItem(
            "Years of Experience",
            widget.job['years_experience']?.toString() ?? '0',
          ),
          _buildSidebarItem("Salary", widget.job['salary'] ?? 'Not specified'),
          _buildSidebarItem(
            "Vacancies",
            widget.job['vacancies_count']?.toString() ?? '1',
          ),
          _buildSidebarItem("Job Status", widget.job['status'] ?? 'Active'),

          const Divider(height: 30),

          // Employer Career Website (Optional)
          if (widget.job['employer_career_link'] != null &&
              widget.job['employer_career_link'].toString().isNotEmpty) ...[
            const Text(
              "Career Website",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                /* Add URL launcher here */
              },
              child: Text(widget.job['employer_career_link']),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ==========================================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.yellow,
      elevation: 0,
      toolbarHeight: 85,
      automaticallyImplyLeading: false,
      titleSpacing: 0, // Removes default edge padding so it aligns perfectly
      centerTitle: true,
      title: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1200,
        ), // Matches the body container
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ), // Matches body padding
          child: Row(
            children: [
              // Official Seals / Logos
              Image.asset('assets/naga.png', height: 70, fit: BoxFit.contain),
              const SizedBox(width: 10),
              Image.asset('assets/peso.png', height: 70, fit: BoxFit.contain),
              const SizedBox(width: 15),
              // Logo Text
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Naga Job",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 1.2,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Nav Links
              _buildNavLink("Home", isActive: true),
              _buildNavLink("Jobs"),
              const SizedBox(width: 20),
              // Action Buttons (Moved inside the ConstrainedBox)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenSignup(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  side: const BorderSide(color: Colors.black, width: 2.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenLogin(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                child: Text("LOGIN", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(String text, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  // Refactored apply logic for cleanliness
  Future<void> _apply(
    Map<String, dynamic>? user,
    Map<String, dynamic> job,
    VacancyProvider provider,
  ) async {
    final seekerId = user?['seeker_id'] ?? user?['id'];
    if (seekerId != null) {
      bool success = await provider.applyForJob(seekerId, job['vacancy_id']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? "Applied successfully!"
                  : provider.errorMessage ?? "Error",
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
