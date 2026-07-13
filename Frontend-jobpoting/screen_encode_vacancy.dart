import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vacancy_provider.dart';

class ScreenEncodeVacancy extends StatefulWidget {
  const ScreenEncodeVacancy({super.key});

  @override
  State<ScreenEncodeVacancy> createState() => _ScreenEncodeVacancyState();
}

class _ScreenEncodeVacancyState extends State<ScreenEncodeVacancy> {
  // Navigation State (Defaulting to Job Postings to see the new UI)
  int _selectedMenu = 3;

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

  // ---------------------------------------------------------
  // NEW LIGHT THEME COLORS (Matching the Image)
  // ---------------------------------------------------------
  final Color sidebarBlue = const Color(0xFF23367A); // Deep blue sidebar
  final Color sidebarActive = const Color(0xFF334A99); // Lighter blue for active item
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
                  child: _selectedMenu == 3
                      ? _buildJobPostingsContent(filteredJobs, vacancyProvider)
                      : _selectedMenu == 2
                      ? _buildEmployersContent()
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
          // Logo Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_balance, color: sidebarBlue, size: 20),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PESO Naga", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Admin Portal", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _sidebarItem(0, Icons.grid_view, "Dashboard"),
                _sidebarItem(1, Icons.people_outline, "Job Seekers", badgeCount: 245),
                _sidebarItem(2, Icons.business, "Employers", badgeCount: 89),
                _sidebarItem(3, Icons.work_outline, "Job Postings", badgeCount: 189),
                _sidebarItem(4, Icons.compare_arrows, "Job Matching"),
                _sidebarItem(5, Icons.school_outlined, "SPES Applications", badgeCount: 45),
                _sidebarItem(6, Icons.bar_chart, "Reports & Analytics"),
              ],
            ),
          ),

          // User Profile at Bottom
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryAccent,
                  child: const Text("JD", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Juan Dela Cruz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text("PESO Officer", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: InkWell(
              onTap: () {}, 
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

  Widget _sidebarItem(int index, IconData icon, String title, {int? badgeCount}) {
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
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  "$badgeCount",
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
            decoration: BoxDecoration(color: mainBg, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(color: textDark, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Search job seekers, employers, programs...",
                hintStyle: TextStyle(color: textMuted),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: textMuted, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.notifications_none, color: textDark),
              const SizedBox(width: 20),
              Icon(Icons.mail_outline, color: textDark),
              const SizedBox(width: 20),
              CircleAvatar(radius: 16, backgroundColor: primaryAccent, child: const Text("JD", style: TextStyle(color: Colors.white, fontSize: 12))),
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
          // Top Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Job Postings", style: TextStyle(color: textDark, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Manage active job vacancies and applicants", style: TextStyle(color: textMuted, fontSize: 14)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showJobDialog(context),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text("Post New Job", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sidebarBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  decoration: BoxDecoration(color: cardWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search by job title or employer...",
                      hintStyle: TextStyle(color: textMuted, fontSize: 14),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: textMuted, size: 20),
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
                  decoration: BoxDecoration(color: cardWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: "All Types",
                      items: ["All Types", "Full-time", "Part-time", "Contract"].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(color: textDark, fontSize: 14)));
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.filter_alt_outlined, color: textDark, size: 18),
                label: Text("More Filters", style: TextStyle(color: textDark)),
                style: OutlinedButton.styleFrom(backgroundColor: cardWhite, side: BorderSide(color: Colors.grey.shade300), minimumSize: const Size(150, 45)),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 4 Metric Cards
          Row(
            children: [
              _buildMetricCard("Total Jobs", "${filteredJobs.length}", textDark),
              const SizedBox(width: 15),
              _buildMetricCard("Active", "${filteredJobs.length}", Colors.blue), 
              const SizedBox(width: 15),
              _buildMetricCard("Total Applicants", "128", Colors.orange), // Placeholder
              const SizedBox(width: 15),
              _buildMetricCard("New This Week", "5", Colors.green), // Placeholder
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
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text("JOB TITLE", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 2, child: Text("EMPLOYER", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 2, child: Text("TYPE", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 2, child: Text("LOCATION", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 1, child: Text("APPLICANTS", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 1, child: Text("ACTIONS", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredJobs.isEmpty
                        ? Center(child: Text("No job postings found.", style: TextStyle(color: textMuted)))
                        : ListView.separated(
                            itemCount: filteredJobs.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1),
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              int applicantCount = job['applicant_count'] ?? 0;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                child: Row(
                                  children: [
                                    // 1. Job Title & Salary
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.blue.shade100),
                                            ),
                                            child: Icon(Icons.work_outline, color: primaryAccent, size: 20),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  job['job_title'] ?? 'Unknown',
                                                  style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 14),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  job['salary'] == null || job['salary'].isEmpty ? 'Not specified' : job['salary'],
                                                  style: TextStyle(color: textMuted, fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
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
                                        style: TextStyle(color: textDark, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // 3. Employment Type Badge
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            job['employment_type'] ?? 'N/A',
                                            style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 4. Location
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        job['location'] ?? 'N/A',
                                        style: TextStyle(color: textDark, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // 5. Applicants
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "$applicantCount",
                                        style: TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    // 6. Actions
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () => _showJobDialog(context, existingJob: job),
                                            child: Icon(Icons.edit_outlined, color: textMuted, size: 18),
                                          ),
                                          const SizedBox(width: 15),
                                          InkWell(
                                            onTap: () => provider.deleteVacancy(job['vacancy_id']),
                                            child: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 18),
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

  // ==========================================
  // PAGE: EMPLOYERS CONTENT (TABLE LAYOUT)
  // ==========================================
  Widget _buildEmployersContent() {
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
                  Text("Employers", style: TextStyle(color: textDark, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Manage registered employers and companies", style: TextStyle(color: textMuted, fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.download, color: textDark, size: 18),
                    label: Text("Export", style: TextStyle(color: textDark)),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showEmployerDialog(context),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text("Add Employer", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: sidebarBlue, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
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
                  decoration: BoxDecoration(color: cardWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by company name, contact person, or industry...",
                      hintStyle: TextStyle(color: textMuted, fontSize: 14),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: textMuted, size: 20),
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
                  decoration: BoxDecoration(color: cardWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: "All Industries",
                      items: ["All Industries", "Information Technology", "Manufacturing", "Healthcare"].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(color: textDark, fontSize: 14)));
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.filter_alt_outlined, color: textDark, size: 18),
                label: Text("More Filters", style: TextStyle(color: textDark)),
                style: OutlinedButton.styleFrom(backgroundColor: cardWhite, side: BorderSide(color: Colors.grey.shade300), minimumSize: const Size(150, 45)),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 4 Metric Cards
          Row(
            children: [
              _buildMetricCard("Total Employers", "${employerList.length}", textDark),
              const SizedBox(width: 15),
              _buildMetricCard("Active Postings", "43", Colors.blue), 
              const SizedBox(width: 15),
              _buildMetricCard("Total Hires", "499", Colors.green), 
              const SizedBox(width: 15),
              _buildMetricCard("New This Month", "12", Colors.purple), 
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
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text("COMPANY", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 2, child: Text("CONTACT PERSON", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 2, child: Text("INDUSTRY", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 1, child: Text("ACTIVE JOBS", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 1, child: Text("TOTAL HIRED", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(flex: 1, child: Text("ACTIONS", style: TextStyle(color: textMuted, fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : employerList.isEmpty
                        ? Center(child: Text("No employers registered yet.", style: TextStyle(color: textMuted)))
                        : ListView.separated(
                            itemCount: employerList.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1),
                            itemBuilder: (context, index) {
                              final emp = employerList[index];
                              int activeJobs = (emp['employer_id'] ?? index + 1) * 2;
                              int totalHired = (emp['employer_id'] ?? index + 1) * 15;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey.shade200),
                                              image: (emp['logo_url'] != null && emp['logo_url'].toString().isNotEmpty)
                                                  ? DecorationImage(image: NetworkImage(emp['logo_url']), fit: BoxFit.cover)
                                                  : null,
                                            ),
                                            child: (emp['logo_url'] == null || emp['logo_url'].toString().isEmpty)
                                                ? Icon(Icons.business, color: primaryAccent, size: 20)
                                                : null,
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  emp['company_name'] ?? 'Unknown',
                                                  style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 14),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  emp['address'] ?? 'Naga City',
                                                  style: TextStyle(color: textMuted, fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(emp['contact_person'] ?? 'N/A', style: TextStyle(color: textDark, fontSize: 14)),
                                          Text(emp['email'] ?? 'N/A', style: TextStyle(color: textMuted, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    // 3. Industry Badge
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(20)),
                                          child: Text(emp['industry'] ?? 'N/A', style: TextStyle(color: Colors.purple.shade700, fontSize: 12, fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                    // 4. Active Jobs
                                    Expanded(flex: 1, child: Text("$activeJobs", style: TextStyle(color: textDark, fontSize: 14))),
                                    // 5. Total Hired
                                    Expanded(flex: 1, child: Text("$totalHired", style: TextStyle(color: textDark, fontSize: 14))),
                                    // 6. Actions
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Icon(Icons.remove_red_eye_outlined, color: primaryAccent, size: 18),
                                          const SizedBox(width: 15),
                                          Icon(Icons.edit_outlined, color: textMuted, size: 18),
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

  // Metric Card Helper
  Widget _buildMetricCard(String title, String value, Color valueColor) {
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
            Text(title, style: TextStyle(color: textMuted, fontSize: 13)),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // PERFECTED JOB POSTING DIALOG
  // ==========================================
  void _showJobDialog(BuildContext context, {Map<String, dynamic>? existingJob}) {
    bool isEditing = existingJob != null;
    final providers = context.read<VacancyProvider>();
    List<String> companyNames = providers.employers.map<String>((e) => e['company_name'].toString()).toSet().toList();
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
    _empTypeCtrl.text = isEditing ? existingJob['employment_type'] ?? '' : '';
    _industryCtrl.text = isEditing ? existingJob['industry'] ?? '' : '';
    _locationCtrl.text = isEditing ? existingJob['location'] ?? '' : '';
    _experienceCtrl.text = isEditing ? (existingJob['years_experience']?.toString() ?? '') : '';
    _vacancyCountCtrl.text = isEditing ? (existingJob['vacancies_count']?.toString() ?? '1') : '1';
    _salaryCtrl.text = isEditing ? existingJob['salary'] ?? '' : '';

    if (isEditing && existingJob['application_deadline'] != null) {
      _deadlineCtrl.text = existingJob['application_deadline'].toString().substring(0, 10);
    } else {
      _deadlineCtrl.text = '';
    }

    _descCtrl.text = isEditing ? existingJob['job_description'] ?? '' : '';
    _qualCtrl.text = isEditing ? existingJob['qualifications'] ?? '' : '';
    _jobLocationType = isEditing ? existingJob['job_location_type'] ?? 'Local' : 'Local';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          Text(isEditing ? "Edit Job Vacancy" : "Add New Job Vacancy", style: TextStyle(color: textDark, fontSize: 22, fontWeight: FontWeight.w400)),
                          IconButton(icon: const Icon(Icons.close, color: Colors.black54), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(child: _buildFormTextField(_jobTitleCtrl, "Job Title", true)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildLabeledField(
                              "Company / Employer",
                              true,
                              DropdownButtonFormField<String>(
                                value: selectedEmployer,
                                dropdownColor: cardWhite,
                                style: TextStyle(color: textDark, fontSize: 14),
                                decoration: _dropdownDecoration(),
                                items: companyNames.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                                onChanged: (newValue) => setStateDialog(() => selectedEmployer = newValue!),
                                validator: (value) => value == null || value.isEmpty ? "Required" : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: _buildFormTextField(_empTypeCtrl, "Employment Type", false)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildFormTextField(_industryCtrl, "Industry", false)),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: _buildFormTextField(_locationCtrl, "Location", true)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildLabeledField(
                              "Job Scope",
                              false,
                              DropdownButtonFormField<String>(
                                value: _jobLocationType,
                                dropdownColor: cardWhite,
                                style: TextStyle(color: textDark, fontSize: 14),
                                decoration: _dropdownDecoration(),
                                items: ['Local', 'Overseas'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                                onChanged: (newValue) => setStateDialog(() => _jobLocationType = newValue!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: _buildFormTextField(_experienceCtrl, "Years of Experience", false, isNumber: true)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildFormTextField(_vacancyCountCtrl, "Number of Vacancies", false, isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: _buildFormTextField(_salaryCtrl, "Salary", false)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildFormTextField(
                              _deadlineCtrl,
                              "Application Deadline",
                              true,
                              isReadOnly: true,
                              suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(const Duration(days: 30)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setStateDialog(() => _deadlineCtrl.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      _buildFormTextField(_descCtrl, "Job Description", false, maxLines: 3),
                      const SizedBox(height: 15),
                      _buildFormTextField(_qualCtrl, "Qualifications", false, maxLines: 3),

                      const SizedBox(height: 35),
                      const Divider(),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D3A8A), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              onPressed: () async {
                                if (_vacancyFormKey.currentState!.validate()) {
                                  String? finalDeadline = _deadlineCtrl.text.isEmpty ? null : _deadlineCtrl.text;
                                  Map<String, dynamic> jobData = {
                                    "job_title": _jobTitleCtrl.text,
                                    "employer_name": selectedEmployer ?? '',
                                    "years_experience": int.tryParse(_experienceCtrl.text) ?? 0,
                                    "salary": _salaryCtrl.text.isEmpty ? "Not Specified" : _salaryCtrl.text,
                                    "vacancies_count": int.tryParse(_vacancyCountCtrl.text) ?? 1,
                                    "employment_type": _empTypeCtrl.text,
                                    "industry": _industryCtrl.text,
                                    "location": _locationCtrl.text,
                                    "job_description": _descCtrl.text,
                                    "qualifications": _qualCtrl.text,
                                    "application_deadline": finalDeadline,
                                    "job_location_type": _jobLocationType,
                                  };

                                  bool success;
                                  if (isEditing) {
                                    success = await context.read<VacancyProvider>().updateVacancy(existingJob['vacancy_id'], jobData);
                                  } else {
                                    success = await context.read<VacancyProvider>().encodeVacancy(jobData);
                                  }

                                  if (context.mounted) {
                                    if (success) {
                                      Navigator.pop(context);
                                      context.read<VacancyProvider>().fetchVacancies();
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? "Job updated!" : "Job posted!"), backgroundColor: Colors.green));
                                    } else {
                                      String errorMsg = context.read<VacancyProvider>().errorMessage ?? "Failed to save.";
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $errorMsg"), backgroundColor: Colors.red));
                                    }
                                  }
                                }
                              },
                              child: Text(isEditing ? "Update Job" : "Save Job", style: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), side: BorderSide(color: Colors.grey.shade400, width: 1)),
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
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
  void _showEmployerDialog(BuildContext context) {
    String _selectedIndustry = 'Healthcare';

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          Text("Add New Employer", style: TextStyle(color: textDark, fontSize: 22, fontWeight: FontWeight.w400)),
                          IconButton(icon: const Icon(Icons.close, color: Colors.black54), onPressed: () => Navigator.pop(context)),
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
                            prefixIcon: const Icon(Icons.image_outlined, color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryAccent)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildFormTextField(_companyNameCtrl, "Company Name", true),
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
                                items: ['Healthcare', 'Information Technology', 'Manufacturing', 'Retail', 'BPO/Call Center']
                                    .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                                onChanged: (newValue) => setStateDialog(() => _selectedIndustry = newValue!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(child: _buildFormTextField(_contactPersonCtrl, "Contact Person", true)),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: _buildFormTextField(_emailCtrl, "Email", true)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildFormTextField(_phoneCtrl, "Phone", true, isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 15),

                      _buildFormTextField(_addressCtrl, "Address", true, maxLines: 4),

                      const SizedBox(height: 35),
                      const Divider(),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D3A8A), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              onPressed: () => _submitEmployer(context, _selectedIndustry, "Active"),
                              child: const Text("Register Employer", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), side: BorderSide(color: primaryAccent, width: 1.5)),
                              onPressed: () => _submitEmployer(context, _selectedIndustry, "Draft"),
                              child: Text("Save Draft", style: TextStyle(color: primaryAccent, fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), side: BorderSide(color: Colors.grey.shade400, width: 1)),
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
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

  Future<void> _submitEmployer(BuildContext context, String industry, String status) async {
    if (_employerFormKey.currentState!.validate()) {
      Map<String, String> employerData = {
        "company_name": _companyNameCtrl.text,
        "industry": industry,
        "website": _websiteCtrl.text,
        "contact_person": _contactPersonCtrl.text,
        "email": _emailCtrl.text,
        "phone": _phoneCtrl.text,
        "address": _addressCtrl.text,
        "logo_url": _logoUrlCtrl.text, 
        "status": status, 
      };

      bool success = await context.read<VacancyProvider>().registerEmployer(employerData);

      if (context.mounted) {
        if (success) {
          _companyNameCtrl.clear();
          _websiteCtrl.clear();
          _contactPersonCtrl.clear();
          _emailCtrl.clear();
          _phoneCtrl.clear();
          _addressCtrl.clear();
          _logoUrlCtrl.clear();

          Navigator.pop(context);
          context.read<VacancyProvider>().fetchEmployers();

          String msg = status == "Draft" ? "Draft Saved!" : "Employer Registered!";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
        } else {
          String errorMsg = context.read<VacancyProvider>().errorMessage ?? "Failed to save.";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $errorMsg"), backgroundColor: Colors.red));
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryAccent)),
          filled: true,
          fillColor: cardWhite,
        ),
        validator: isRequired ? (val) => val!.isEmpty ? "Required" : null : null,
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
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
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
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryAccent)),
      filled: true,
      fillColor: cardWhite,
    );
  }
}