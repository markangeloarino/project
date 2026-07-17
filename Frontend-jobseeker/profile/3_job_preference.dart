import 'package:flutter/material.dart';

class JobPreferences extends StatefulWidget {
  final Map<String, dynamic>? user;
  const JobPreferences({super.key, required this.user});

  @override
  State<JobPreferences> createState() => _JobPreferencesState();
}

class _JobPreferencesState extends State<JobPreferences> {
  // --- JOB PREFERENCE CONTROLLERS & STATE ---
  bool _isPartTime = false;
  bool _isFullTime = false;
  bool _isLocal = false;
  bool _isOverseas = false;

  final TextEditingController _jobTitle1Ctrl = TextEditingController();
  final TextEditingController _jobTitle2Ctrl = TextEditingController();
  final TextEditingController _jobTitle3Ctrl = TextEditingController();

  final TextEditingController _company1Ctrl = TextEditingController();
  final TextEditingController _company2Ctrl = TextEditingController();
  final TextEditingController _company3Ctrl = TextEditingController();

  final TextEditingController _local1Ctrl = TextEditingController();
  final TextEditingController _local2Ctrl = TextEditingController();
  final TextEditingController _local3Ctrl = TextEditingController();

  final TextEditingController _overseas1Ctrl = TextEditingController();
  final TextEditingController _overseas2Ctrl = TextEditingController();
  final TextEditingController _overseas3Ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================
        // PART 1: PREFERRED OCCUPATION
        // ==========================================
        Row(
          children: [
            _buildLabel("PREFERRED OCCUPATION"),
            const Spacer(),
            _buildCheckbox(
              "Part-Time",
              _isPartTime,
              (v) => setState(() => _isPartTime = v!),
            ),
            const SizedBox(width: 15),
            _buildCheckbox(
              "Full-Time",
              _isFullTime,
              (v) => setState(() => _isFullTime = v!),
            ),
          ],
        ),
        const Divider(color: Colors.black54, thickness: 1.5),

        // Headers for Occupation
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "JOB TITLE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "COMPANY NAME",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Occupation Rows
        _buildOccupationRow("1.", _jobTitle1Ctrl, _company1Ctrl),
        _buildOccupationRow("2.", _jobTitle2Ctrl, _company2Ctrl),
        _buildOccupationRow("3.", _jobTitle3Ctrl, _company3Ctrl),

        const SizedBox(height: 40),

        // ==========================================
        // PART 2: PREFERRED WORK LOCATION
        // ==========================================
        _buildLabel("PREFERRED WORK LOCATION"),
        const Divider(color: Colors.black54, thickness: 1.5),

        // Headers and Checkboxes for Location
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildCheckbox(
                "Local (specify cities/municipalities)",
                _isLocal,
                (v) => setState(() => _isLocal = v!),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: _buildCheckbox(
                "Overseas (specify countries)",
                _isOverseas,
                (v) => setState(() => _isOverseas = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Location Rows
        _buildLocationRow("1.", _local1Ctrl, _overseas1Ctrl),
        _buildLocationRow("2.", _local2Ctrl, _overseas2Ctrl),
        _buildLocationRow("3.", _local3Ctrl, _overseas3Ctrl),

        const SizedBox(height: 40),

        // --- SAVE BUTTON ---
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            onPressed: () {
              // Your Save Logic Here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Job Preferences Saved!")),
              );
            },
            child: const Text(
              "Save Changes",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // Helper for generating the Preferred Occupation rows
  Widget _buildOccupationRow(
    String numLabel,
    TextEditingController job,
    TextEditingController comp,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: Text(
              numLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 1, child: _buildGreyTextFieldController(job)),
          const SizedBox(width: 15),
          Expanded(flex: 1, child: _buildGreyTextFieldController(comp)),
        ],
      ),
    );
  }

  // Helper for generating the Preferred Work Location rows
  Widget _buildLocationRow(
    String numLabel,
    TextEditingController loc,
    TextEditingController over,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: Text(
              numLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 1, child: _buildGreyTextFieldController(loc)),
          const SizedBox(width: 15),
          Expanded(flex: 1, child: _buildGreyTextFieldController(over)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  } // Updated text field builder to support hints and number keyboards

  // Helper for creating consistent checkboxes
  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1D3A8A),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreyTextFieldController(
    TextEditingController controller, {
    IconData? icon,
    String? hint,
    bool isNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          isDense: true,
          suffixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
        ),
      ),
    );
  }
}
