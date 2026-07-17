import 'package:flutter/material.dart';
import 'package:neis_cap/auth_provider.dart';
import 'package:neis_cap/screen_staff_login.dart';
import 'package:provider/provider.dart';
import 'post_vacancy_provider.dart';
import 'package:intl/intl.dart';

class ScreenJobPosterDashboard extends StatefulWidget {
  const ScreenJobPosterDashboard({super.key});

  @override
  State<ScreenJobPosterDashboard> createState() =>
      _ScreenJobPosterDashboardState();
}

class _ScreenJobPosterDashboardState extends State<ScreenJobPosterDashboard> {
  // Navigation State (Defaulting to Job Postings to see the new UI)
  int _selectedMenu = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Job Vacancy Form Controllers
  final _vacancyFormKey = GlobalKey<FormState>();
  final TextEditingController _jobTitleCtrl = TextEditingController();
  final TextEditingController _employerCtrl = TextEditingController();
  final TextEditingController _experienceCtrl = TextEditingController();
  final TextEditingController _salaryCtrl = TextEditingController();
  final TextEditingController _vacancyCountCtrl = TextEditingController();
  final TextEditingController _empTypeCtrl = TextEditingController();
  final TextEditingController _industryCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _deadlineCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _qualCtrl = TextEditingController();
  final TextEditingController _careerLinkCtrl =
      TextEditingController(); // NEW: Link Controller
  String _jobLocationType = 'Local';

  // Employer Form Controllers
  final _employerFormKey = GlobalKey<FormState>();
  final TextEditingController _companyNameCtrl = TextEditingController();
  final TextEditingController _empIndustryCtrl = TextEditingController();
  final TextEditingController _websiteCtrl = TextEditingController();
  final TextEditingController _contactPersonCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _logoUrlCtrl = TextEditingController();
  final TextEditingController _companyDescCtrl =
      TextEditingController(); // NEW: Controller

  // ---------------------------------------------------------
  // LIGHT THEME COLORS
  // ---------------------------------------------------------
  final Color sidebarBlue = const Color(0xFF23367A); // Deep blue sidebar
  final Color sidebarActive = const Color(
    0xFF334A99,
  ); // Lighter blue for active item
  final Color mainBg = const Color(0xFFF5F7FB); // Very light gray background
  final Color cardWhite = Colors.white;
  final Color textDark = const Color(0xFF1E293B);
  final Color textMuted = const Color(0xFF64748B);
  final Color primaryAccent = const Color(0xFF1D4ED8); // Button blue

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VacancyProvider>().fetchVacancies();
      context.read<VacancyProvider>().fetchEmployers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vacancyProvider = context.watch<VacancyProvider>();
  final allApps = vacancyProvider.allApplications;
  final activeJobs = vacancyProvider.activeJobs;

    final filteredJobs = vacancyProvider.activeJobs.where((job) {
      final title = job['job_title']?.toString().toLowerCase() ?? '';
      final employer = job['employer_name']?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || employer.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: mainBg,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _selectedMenu == 0
                      ? _buildDashboardContent(allApps, activeJobs)
                      : _selectedMenu == 3
                      ? _buildJobPostingsContent(filteredJobs, vacancyProvider)
                      : _selectedMenu == 2
                      ? _buildEmployersContent(filteredJobs, vacancyProvider)
                      : Center(
                          child: Text(
                            "Page under construction",
                            style: TextStyle(color: textMuted),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SIDEBAR
  // ==========================================
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: sidebarBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_balance,
                    color: sidebarBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PESO Naga",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Job Poster",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _sidebarItem(0, Icons.grid_view, "Dashboard"),
                _sidebarItem(
                  1,
                  Icons.people_outline,
                  "Job Seekers",
                  badgeCount: 245,
                ),
                _sidebarItem(2, Icons.business, "Employers", badgeCount: 89),
                _sidebarItem(
                  3,
                  Icons.work_outline,
                  "Job Postings",
                  badgeCount: 189,
                ),
                _sidebarItem(6, Icons.bar_chart, "Reports & Analytics"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryAccent,
                  child: const Text(
                    "JD",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Juan Dela Cruz",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "PESO Officer",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: InkWell(
              onTap: () {
                context.read<AuthProvider>().currentUser = null;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenStaffLogin(),
                  ),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Colors.white70, size: 20),
                  SizedBox(width: 10),
                  Text("Logout", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    int index,
    IconData icon,
    String title, {
    int? badgeCount,
  }) {
    bool isActive = _selectedMenu == index;
    return InkWell(
      onTap: () => setState(() {
        _selectedMenu = index;
        _searchQuery = "";
        _searchController.clear();
      }),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: isActive ? sidebarActive : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (badgeCount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$badgeCount",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOP HEADER
  // ==========================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      color: cardWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 400,
            decoration: BoxDecoration(
              color: mainBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController, // Ensure this controller is used
              onChanged: (val) {
                setState(() {
                  _searchQuery =
                      val; // Updates the query, forcing a re-build of the view
                });
              },
              decoration: InputDecoration(
                hintText: "Search job seekers, employers...",
                hintStyle: TextStyle(color: textMuted),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: textMuted, size: 20),
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.notifications_none, color: textDark),
              const SizedBox(width: 20),
              Icon(Icons.mail_outline, color: textDark),
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 16,
                backgroundColor: primaryAccent,
                child: const Text(
                  "JD",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PAGE: JOB POSTINGS CONTENT (TABLE LAYOUT)
  // ==========================================
  Widget _buildJobPostingsContent(List filteredJobs, VacancyProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Job Postings",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Manage active job vacancies and applicants",
                    style: TextStyle(color: textMuted, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.download, color: textDark, size: 18),
                    label: Text("Export", style: TextStyle(color: textDark)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showJobDialog(context),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      "Post New Job",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sidebarBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filters Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search by job title or employer...",
                      hintStyle: TextStyle(color: textMuted, fontSize: 14),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: textMuted,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: "All Types",
                      items: ["All Types", "Full-time", "Part-time", "Contract"]
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: textDark, fontSize: 14),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: textDark,
                  size: 18,
                ),
                label: Text("More Filters", style: TextStyle(color: textDark)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: cardWhite,
                  side: BorderSide(color: Colors.grey.shade300),
                  minimumSize: const Size(150, 45),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Main Data Table
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "JOB TITLE",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "EMPLOYER",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "TYPE",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "LOCATION",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // NEW: POSTED COLUMN HEADER
                        Expanded(
                          flex: 2,
                          child: Text(
                            "POSTED",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "APPLICANTS",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "STATUS",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "ACTIONS",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredJobs.isEmpty
                        ? Center(
                            child: Text(
                              "No job postings found.",
                              style: TextStyle(color: textMuted),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredJobs.length,
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade200, height: 1),
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              int applicantCount = job['applicant_count'] ?? 0;
                              bool isClosed = job['status'] == 'Closed';

                              // NEW: Parse, convert to Local Time (PHT), and format the date
                              String postedDate = 'N/A';
                              if (job['date_posted'] != null) {
                                try {
                                  // Added .toLocal() to fix the timezone offset!
                                  DateTime parsedDate = DateTime.parse(
                                    job['date_posted'].toString(),
                                  ).toLocal();
                                  postedDate = DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(parsedDate);
                                } catch (e) {
                                  // Fallback handled
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 15,
                                ),
                                child: Row(
                                  children: [
                                    // 1. Job Title, Salary & Status Badge
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: isClosed
                                                  ? Colors.grey.shade200
                                                  : Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: isClosed
                                                    ? Colors.grey.shade400
                                                    : Colors.blue.shade100,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.work_outline,
                                              color: isClosed
                                                  ? Colors.grey.shade600
                                                  : primaryAccent,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    job['job_title'] ??
                                                        'Unknown',
                                                    style: TextStyle(
                                                      color: isClosed
                                                          ? Colors.grey.shade600
                                                          : textDark,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      decoration: isClosed
                                                          ? TextDecoration
                                                                .lineThrough
                                                          : null, // Strikethrough if closed
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const SizedBox(height: 2),
                                                Text(
                                                  job['salary'] == null ||
                                                          job['salary'].isEmpty
                                                      ? 'Not specified'
                                                      : job['salary'],
                                                  style: TextStyle(
                                                    color: textMuted,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 2. Employer
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        job['employer_name'] ?? 'Unknown',
                                        style: TextStyle(
                                          color: textDark,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // 3. Employment Type Badge
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            job['employment_type'] ?? 'N/A',
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 4. Location
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        job['location'] ?? 'N/A',
                                        style: TextStyle(
                                          color: textDark,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // NEW: 5. Date Posted
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        postedDate,
                                        style: TextStyle(
                                          color: textDark,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // 5. Applicants
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "$applicantCount",
                                        style: TextStyle(
                                          color: textDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Status Badge
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isClosed
                                                ? Colors.grey.shade200
                                                : Colors.green.shade100,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            job['status']?.toUpperCase() ??
                                                'ACTIVE',
                                            style: TextStyle(
                                              color: isClosed
                                                  ? Colors.grey.shade700
                                                  : Colors.green.shade800,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 6. Actions (With Delete Confirmation)
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () => _showJobDialog(
                                              context,
                                              existingJob: job,
                                            ),
                                            child: Icon(
                                              Icons.edit_outlined,
                                              color: textMuted,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          InkWell(
                                            onTap: () => _confirmDelete(
                                              context,
                                              job['vacancy_id'],
                                              provider,
                                            ),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red.shade400,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DELETE CONFIRMATION DIALOG ---
  void _confirmDelete(
    BuildContext context,
    int vacancyId,
    VacancyProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
            "Are you sure you want to permanently delete this job posting? This action cannot be undone.",
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                bool success = await provider.deleteVacancy(vacancyId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "Job deleted successfully."
                            : provider.errorMessage ?? "Failed to delete.",
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // PAGE: EMPLOYERS CONTENT (TABLE LAYOUT)
  // ==========================================
  Widget _buildEmployersContent(List filteredJobs, VacancyProvider provider) {
    final provider = context.watch<VacancyProvider>();
    final employerList = provider.employers;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Employers",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Manage registered employers and companies",
                    style: TextStyle(color: textMuted, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.download, color: textDark, size: 18),
                    label: Text("Export", style: TextStyle(color: textDark)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showEmployerDialog(context),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      "Add Employer",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sidebarBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filters Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText:
                          "Search by company name, contact person, or industry...",
                      hintStyle: TextStyle(color: textMuted, fontSize: 14),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: textMuted,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: "All Industries",
                      items:
                          [
                            "All Industries",
                            "Information Technology",
                            "Manufacturing",
                            "Healthcare",
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: textDark, fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: textDark,
                  size: 18,
                ),
                label: Text("More Filters", style: TextStyle(color: textDark)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: cardWhite,
                  side: BorderSide(color: Colors.grey.shade300),
                  minimumSize: const Size(150, 45),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Main Data Table
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "COMPANY",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "CONTACT PERSON",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "INDUSTRY",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "ACTIVE JOBS",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "TOTAL HIRED",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "REGISTERED",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "ACTIONS",
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : employerList.isEmpty
                        ? Center(
                            child: Text(
                              "No employers registered yet.",
                              style: TextStyle(color: textMuted),
                            ),
                          )
                        : ListView.separated(
                            itemCount: employerList.length,
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade200, height: 1),
                            itemBuilder: (context, index) {
                              final emp = employerList[index];
                              int activeJobs =
                                  (emp['employer_id'] ?? index + 1) * 2;
                              int totalHired =
                                  (emp['employer_id'] ?? index + 1) * 15;

                              // NEW: Parse and format the registration date
                              String regDate = 'N/A';
                              if (emp['registered_at'] != null) {
                                try {
                                  regDate = DateFormat('MMM dd, yyyy').format(
                                    DateTime.parse(
                                      emp['registered_at'].toString(),
                                    ).toLocal(),
                                  );
                                } catch (e) {
                                  /* Fallback handled */
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 15,
                                ),
                                child: Row(
                                  children: [
                                    // 1. Company Column
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                              image:
                                                  (emp['logo_url'] != null &&
                                                      emp['logo_url']
                                                          .toString()
                                                          .isNotEmpty)
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                        emp['logo_url'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                            child:
                                                (emp['logo_url'] == null ||
                                                    emp['logo_url']
                                                        .toString()
                                                        .isEmpty)
                                                ? Icon(
                                                    Icons.business,
                                                    color: primaryAccent,
                                                    size: 20,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  emp['company_name'] ??
                                                      'Unknown',
                                                  style: TextStyle(
                                                    color: textDark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  emp['address'] ?? 'Naga City',
                                                  style: TextStyle(
                                                    color: textMuted,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 2. Contact Person
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            emp['contact_person'] ?? 'N/A',
                                            style: TextStyle(
                                              color: textDark,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            emp['email'] ?? 'N/A',
                                            style: TextStyle(
                                              color: textMuted,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 3. Industry Badge
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.purple.shade50,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            emp['industry'] ?? 'N/A',
                                            style: TextStyle(
                                              color: Colors.purple.shade700,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 4. Active Jobs
                                    // ... inside _buildEmployersContent ListView.separated itemBuilder ...
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "$activeJobs",
                                        style: TextStyle(
                                          color: textDark,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    // 5. Total Hired
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "$totalHired",
                                        style: TextStyle(
                                          color: textDark,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    // NEW: 6. Date Registered
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        regDate,
                                        style: TextStyle(
                                          color: textDark,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),

                                    // 7. Actions
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () => _showEmployerDialog(
                                              context,
                                              existingEmployer: emp,
                                            ),
                                            child: Icon(
                                              Icons.edit_outlined,
                                              color: textMuted,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          InkWell(
                                            onTap: () => _confirmDeleteEmployer(
                                              context,
                                              emp['employer_id'],
                                              provider,
                                            ),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red.shade400,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteEmployer(
    BuildContext context,
    int employerId,
    VacancyProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Employer"),
          content: const Text("Are you sure you want to remove this employer?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await provider.deleteEmployer(employerId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "Employer removed successfully."
                            : provider.errorMessage ?? "Failed to remove.",
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                      duration: const Duration(
                        seconds: 4,
                      ), // Longer duration to read the error
                    ),
                  );
                }
              },
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // PERFECTED JOB POSTING DIALOG
  // ==========================================
  void _showJobDialog(
    BuildContext context, {
    Map<String, dynamic>? existingJob,
  }) {
    bool isEditing = existingJob != null;
    final providers = context.read<VacancyProvider>();
    List<String> companyNames = providers.employers
        .map<String>((e) => e['company_name'].toString())
        .toSet()
        .toList();
    String? selectedEmployer;

    if (isEditing && existingJob['employer_name'] != null) {
      if (companyNames.contains(existingJob['employer_name'])) {
        selectedEmployer = existingJob['employer_name'];
      } else {
        companyNames.insert(0, existingJob['employer_name']);
        selectedEmployer = existingJob['employer_name'];
      }
    }

    _jobTitleCtrl.text = isEditing ? existingJob['job_title'] ?? '' : '';
    _jobTitleCtrl.text = isEditing ? existingJob['job_title'] ?? '' : '';

    // NEW: Employment Type Dropdown Initialization
    String _selectedEmpType = 'Select an option';
    if (isEditing &&
        existingJob['employment_type'] != null &&
        existingJob['employment_type'].toString().isNotEmpty) {
      _selectedEmpType = existingJob['employment_type'].toString();
    }

    final empTypeOptions = [
      'Select an option',
      'Full-time',
      'Part-time',
      'Contract',
      'Temporary',
      'Internship',
    ];
    // Failsafe: if the database has a legacy value not in the list, add it so the app doesn't crash
    if (!empTypeOptions.contains(_selectedEmpType)) {
      empTypeOptions.add(_selectedEmpType);
    }

    _industryCtrl.text = isEditing ? existingJob['industry'] ?? '' : '';
    _industryCtrl.text = isEditing ? existingJob['industry'] ?? '' : '';
    _locationCtrl.text = isEditing ? existingJob['location'] ?? '' : '';
    _experienceCtrl.text = isEditing
        ? (existingJob['years_experience']?.toString() ?? '')
        : '';
    _vacancyCountCtrl.text = isEditing
        ? (existingJob['vacancies_count']?.toString() ?? '1')
        : '1';
    _salaryCtrl.text = isEditing ? existingJob['salary'] ?? '' : '';

    // Status Initialization
    String _status = isEditing ? existingJob['status'] ?? 'Active' : 'Active';

    if (isEditing && existingJob['application_deadline'] != null) {
      _deadlineCtrl.text = existingJob['application_deadline']
          .toString()
          .substring(0, 10);
    } else {
      _deadlineCtrl.text = '';
    }

    _descCtrl.text = isEditing ? existingJob['job_description'] ?? '' : '';
    _qualCtrl.text = isEditing ? existingJob['qualifications'] ?? '' : '';
    _careerLinkCtrl.text = isEditing
        ? (existingJob['employer_career_link']?.toString() ?? '')
        : '';
    _jobLocationType = isEditing
        ? existingJob['job_location_type'] ?? 'Local'
        : 'Local';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: cardWhite,
            child: Container(
              width: 700,
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Form(
                  key: _vacancyFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing
                                ? "Edit Job Vacancy"
                                : "Add New Job Vacancy",
                            style: TextStyle(
                              color: textDark,
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormTextField(
                              _jobTitleCtrl,
                              "Job Title",
                              true,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildLabeledField(
                              "Company / Employer",
                              true,
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: selectedEmployer,
                                      dropdownColor: cardWhite,
                                      style: TextStyle(
                                        color: textDark,
                                        fontSize: 14,
                                      ),
                                      decoration: _dropdownDecoration(),
                                      items: companyNames
                                          .map(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                ),
                                          )
                                          .toList(),
                                      onChanged: (newValue) => setStateDialog(
                                        () => selectedEmployer = newValue!,
                                      ),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? "Required"
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Quick Add Employer Button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_business,
                                        color: primaryAccent,
                                      ),
                                      tooltip: "Register New Employer",
                                      onPressed: () {
                                        // Open Employer dialog over the current one
                                        _showEmployerDialog(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          // NEW: Employment Type Dropdown
                          Expanded(
                            child: _buildLabeledField(
                              "Employment Type",
                              false,
                              DropdownButtonFormField<String>(
                                value: _selectedEmpType,
                                dropdownColor: cardWhite,
                                style: TextStyle(color: textDark, fontSize: 14),
                                decoration: _dropdownDecoration(),
                                items: empTypeOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) => setStateDialog(
                                  () => _selectedEmpType = newValue!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildLabeledField(
                              "Job Status",
                              true,
                              DropdownButtonFormField<String>(
                                value: _status,
                                dropdownColor: cardWhite,
                                style: TextStyle(color: textDark, fontSize: 14),
                                decoration: _dropdownDecoration(),
                                items: ['Active', 'Closed']
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (newValue) =>
                                    setStateDialog(() => _status = newValue!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormTextField(
                              _industryCtrl,
                              "Industry",
                              false,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildFormTextField(
                              _locationCtrl,
                              "Location",
                              true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledField(
                              "Job Scope",
                              false,
                              DropdownButtonFormField<String>(
                                value: _jobLocationType,
                                dropdownColor: cardWhite,
                                style: TextStyle(color: textDark, fontSize: 14),
                                decoration: _dropdownDecoration(),
                                items: ['Local', 'Overseas']
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (newValue) => setStateDialog(
                                  () => _jobLocationType = newValue!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildFormTextField(
                              _vacancyCountCtrl,
                              "Number of Vacancies",
                              false,
                              isNumber: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormTextField(
                              _salaryCtrl,
                              "Salary",
                              false,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildFormTextField(
                              _deadlineCtrl,
                              "Application Deadline",
                              true,
                              isReadOnly: true,
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey,
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(
                                    const Duration(days: 30),
                                  ),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setStateDialog(
                                    () => _deadlineCtrl.text =
                                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}",
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormTextField(
                              _experienceCtrl,
                              "Years of Experience",
                              false,
                              isNumber: true,
                            ),
                          ),
                          const SizedBox(width: 15),
                          // NEW: Career Link Field (Optional)
                          Expanded(
                            child: _buildFormTextField(
                              _careerLinkCtrl,
                              "Employer Career Website (Optional)",
                              false,
                              suffixIcon: const Icon(
                                Icons.link,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildFormTextField(
                        _descCtrl,
                        "Job Description",
                        false,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 15),
                      _buildFormTextField(
                        _qualCtrl,
                        "Qualifications",
                        false,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 35),
                      const Divider(),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D3A8A),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (_vacancyFormKey.currentState!.validate()) {
                                  String? finalDeadline =
                                      _deadlineCtrl.text.isEmpty
                                      ? null
                                      : _deadlineCtrl.text;
                                  Map<String, dynamic> jobData = {
                                    "job_title": _jobTitleCtrl.text,
                                    "employer_name": selectedEmployer ?? '',
                                    "years_experience":
                                        int.tryParse(_experienceCtrl.text) ?? 0,
                                    "salary": _salaryCtrl.text.isEmpty
                                        ? "Not Specified"
                                        : _salaryCtrl.text,
                                    "vacancies_count":
                                        int.tryParse(_vacancyCountCtrl.text) ??
                                        1,

                                    // NEW: Save the selected dropdown value (save empty string if default is selected)
                                    "employment_type":
                                        _selectedEmpType == 'Select an option'
                                        ? ''
                                        : _selectedEmpType,

                                    "industry": _industryCtrl.text,
                                    "location": _locationCtrl.text,
                                    "job_description": _descCtrl.text,
                                    "qualifications": _qualCtrl.text,
                                    "application_deadline": finalDeadline,
                                    "job_location_type": _jobLocationType,
                                    "status": _status,
                                    "employer_career_link":
                                        _careerLinkCtrl.text.isEmpty
                                        ? null
                                        : _careerLinkCtrl.text,
                                  };
                                  bool success;
                                  if (isEditing) {
                                    success = await context
                                        .read<VacancyProvider>()
                                        .updateVacancy(
                                          existingJob['vacancy_id'],
                                          jobData,
                                        );
                                  } else {
                                    success = await context
                                        .read<VacancyProvider>()
                                        .encodeVacancy(jobData);
                                  }

                                  if (context.mounted) {
                                    if (success) {
                                      Navigator.pop(context);
                                      context
                                          .read<VacancyProvider>()
                                          .fetchVacancies();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isEditing
                                                ? "Job updated!"
                                                : "Job posted!",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      String errorMsg =
                                          context
                                              .read<VacancyProvider>()
                                              .errorMessage ??
                                          "Failed to save.";
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Error: $errorMsg"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text(
                                isEditing ? "Update Job" : "Save Job",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // PERFECTED EMPLOYER REGISTRATION DIALOG
  // ==========================================
  void _showEmployerDialog(
    BuildContext context, {
    Map<String, dynamic>? existingEmployer,
  }) {
    bool isEditing = existingEmployer != null;

    // Pre-fill controllers if editing
    _companyNameCtrl.text = isEditing
        ? existingEmployer['company_name'] ?? ''
        : '';
    _websiteCtrl.text = isEditing ? existingEmployer['website'] ?? '' : '';
    _contactPersonCtrl.text = isEditing
        ? existingEmployer['contact_person'] ?? ''
        : '';
    _emailCtrl.text = isEditing ? existingEmployer['email'] ?? '' : '';
    _phoneCtrl.text = isEditing ? existingEmployer['phone'] ?? '' : '';
    _addressCtrl.text = isEditing ? existingEmployer['address'] ?? '' : '';
    _logoUrlCtrl.text = isEditing ? existingEmployer['logo_url'] ?? '' : '';
    _companyDescCtrl.text = isEditing
        ? existingEmployer['company_description'] ?? ''
        : '';

    String _selectedIndustry = isEditing
        ? existingEmployer['industry'] ?? 'Healthcare'
        : 'Healthcare';

    // Ensure the industry is in the dropdown list to avoid crash
    final industryOptions = [
      'Healthcare',
      'Information Technology',
      'Manufacturing',
      'Retail',
      'BPO/Call Center',
      'Other',
    ];
    if (!industryOptions.contains(_selectedIndustry)) {
      industryOptions.add(_selectedIndustry);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: cardWhite,
            child: Container(
              width: 700,
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Form(
                  key: _employerFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing
                                ? "Edit Employer Details"
                                : "Add New Employer",
                            style: TextStyle(
                              color: textDark,
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      _buildLabeledField(
                        "Company Logo (Image URL)",
                        false,
                        TextFormField(
                          controller: _logoUrlCtrl,
                          style: TextStyle(color: textDark, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "https://example.com/logo.png",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon: const Icon(
                              Icons.image_outlined,
                              color: Colors.grey,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: primaryAccent),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildFormTextField(
                        _companyNameCtrl,
                        "Company Name",
                        true,
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledField(
                              "Industry",
                              true,
                              DropdownButtonFormField<String>(
                                value: _selectedIndustry,
                                dropdownColor: cardWhite,
                                style: TextStyle(color: textDark, fontSize: 14),
                                decoration: _dropdownDecoration(),
                                items: industryOptions
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (newValue) => setStateDialog(
                                  () => _selectedIndustry = newValue!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildFormTextField(
                              _contactPersonCtrl,
                              "Contact Person",
                              true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormTextField(
                              _emailCtrl,
                              "Email",
                              true,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildFormTextField(
                              _phoneCtrl,
                              "Phone",
                              true,
                              isNumber: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      _buildFormTextField(
                        _addressCtrl,
                        "Address",
                        true,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 15),

                      _buildFormTextField(
                        _companyDescCtrl,
                        "Company Description / Overview",
                        false,
                        maxLines: 4,
                      ),

                      const SizedBox(height: 35),
                      const Divider(),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D3A8A),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _submitEmployer(
                                context,
                                _selectedIndustry,
                                "Active",
                                isEditing
                                    ? existingEmployer['employer_id']
                                    : null,
                              ),
                              child: Text(
                                isEditing ? "Update Employer" : "Add Employer",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          if (!isEditing) ...[
                            const SizedBox(width: 15),
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: BorderSide(
                                    color: primaryAccent,
                                    width: 1.5,
                                  ),
                                ),
                                onPressed: () => _submitEmployer(
                                  context,
                                  _selectedIndustry,
                                  "Draft",
                                  null,
                                ),
                                child: Text(
                                  "Save Draft",
                                  style: TextStyle(
                                    color: primaryAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitEmployer(
    BuildContext context,
    String industry,
    String status,
    int? editId,
  ) async {
    if (_employerFormKey.currentState!.validate()) {
      Map<String, dynamic> employerData = {
        "company_name": _companyNameCtrl.text,
        "industry": industry,
        "website": _websiteCtrl.text,
        "contact_person": _contactPersonCtrl.text,
        "email": _emailCtrl.text,
        "phone": _phoneCtrl.text,
        "address": _addressCtrl.text,
        "logo_url": _logoUrlCtrl.text,
        "status": status,
        "company_description": _companyDescCtrl.text,
      };

      bool success;
      if (editId != null) {
        success = await context.read<VacancyProvider>().updateEmployer(
          editId,
          employerData,
        );
      } else {
        // Cast down to Map<String, String> to match original if needed, but dynamic is safer here
        success = await context.read<VacancyProvider>().registerEmployer(
          employerData.map((k, v) => MapEntry(k, v.toString())),
        );
      }

      if (context.mounted) {
        if (success) {
          _companyNameCtrl.clear();
          _websiteCtrl.clear();
          _contactPersonCtrl.clear();
          _emailCtrl.clear();
          _phoneCtrl.clear();
          _addressCtrl.clear();
          _logoUrlCtrl.clear();
          _companyDescCtrl.clear();

          Navigator.pop(context);
          context.read<VacancyProvider>().fetchEmployers();

          String msg = editId != null
              ? "Employer Updated!"
              : (status == "Draft" ? "Draft Saved!" : "Employer Registered!");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.green),
          );
        } else {
          String errorMsg =
              context.read<VacancyProvider>().errorMessage ?? "Failed to save.";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $errorMsg"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Label Form Builder Widget
  Widget _buildFormTextField(
    TextEditingController controller,
    String label,
    bool isRequired, {
    int maxLines = 1,
    bool isNumber = false,
    bool isReadOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return _buildLabeledField(
      label,
      isRequired,
      TextFormField(
        controller: controller,
        style: TextStyle(color: textDark, fontSize: 14),
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        readOnly: isReadOnly,
        onTap: onTap,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryAccent),
          ),
          filled: true,
          fillColor: cardWhite,
        ),
        validator: isRequired
            ? (val) => val!.isEmpty ? "Required" : null
            : null,
      ),
    );
  }

  Widget _buildLabeledField(String label, bool isRequired, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryAccent),
      ),
      filled: true,
      fillColor: cardWhite,
    );
  }

  Widget _buildDashboardContent(
    List<dynamic> allApps,
    List<dynamic> activeJobs,
  ) {
    // Calculate quick stats
    int totalSeekers = allApps.map((a) => a['email']).toSet().length;
    int totalJobs = activeJobs.length;
    int pendingApps = allApps.where((a) => a['status'] == 'Pending').length;
    int hiredCount = allApps.where((a) => a['status'] == 'Hired').length;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overview",
            style: TextStyle(
              color: textDark,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          // Stats Cards
          Row(
            children: [
              _buildStatCard(
                "Total Job Seekers",
                "$totalSeekers",
                primaryAccent,
                Icons.people,
              ),
              const SizedBox(width: 20),
              _buildStatCard(
                "Active Vacancies",
                "$totalJobs",
                sidebarBlue,
                Icons.work,
              ),
              const SizedBox(width: 20),
              _buildStatCard(
                "Pending Applications",
                "$pendingApps",
                Colors.orange,
                Icons.pending_actions,
              ),
              const SizedBox(width: 20),
              _buildStatCard(
                "Total Placements",
                "$hiredCount",
              Colors.green,
                Icons.emoji_events,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Recent Activity Placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Application Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: allApps.isEmpty
                        ? Center(
                            child: Text(
                              "No recent activity",
                              style: TextStyle(color: textMuted),
                            ),
                          )
                        : ListView.separated(
                            itemCount: allApps.take(5).length,
                            separatorBuilder: (c, i) => Divider(height: 20),
                            itemBuilder: (c, i) {
                              final app = allApps[i];
                              return Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    color: textMuted,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${app['first_name']} applied for ${app['job_title']}",
                                    style: TextStyle(color: textDark),
                                  ),
                                  const Spacer(),
                                  Text(
                                    app['status'],
                                    style: TextStyle(
                                      color: primaryAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for the stat cards
  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(color: textMuted, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: TextStyle(
                color: textDark,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
