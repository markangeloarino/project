import 'package:flutter/material.dart';

class EducationalBackground extends StatefulWidget {
  final Map<String, dynamic>? user;
  const EducationalBackground({super.key, required this.user});

  @override
  State<EducationalBackground> createState() => _EducationalBackgroundState();
}

class _EducationalBackgroundState extends State<EducationalBackground> {
  // --- LANGUAGE/DIALECT PROFICIENCY STATE ---
  // --- EDUCATIONAL BACKGROUND STATE ---
  String _currentlyInSchool = "No";
  String _secondaryType = "K12"; // "Non-K12" or "K12"

  // Elementary
  final TextEditingController _elemSchoolCtrl = TextEditingController();
  final TextEditingController _elemYearGradCtrl = TextEditingController();
  final TextEditingController _elemLevelCtrl = TextEditingController();
  final TextEditingController _elemYearLastCtrl = TextEditingController();

  // Secondary
  final TextEditingController _secSchoolCtrl = TextEditingController();
  final TextEditingController _secCourseCtrl = TextEditingController();
  final TextEditingController _secYearGradCtrl = TextEditingController();
  final TextEditingController _secLevelCtrl = TextEditingController();
  final TextEditingController _secYearLastCtrl = TextEditingController();

  // Tertiary
  final TextEditingController _tertSchoolCtrl = TextEditingController();
  final TextEditingController _tertCourseCtrl = TextEditingController();
  final TextEditingController _tertYearGradCtrl = TextEditingController();
  final TextEditingController _tertLevelCtrl = TextEditingController();
  final TextEditingController _tertYearLastCtrl = TextEditingController();

  // Graduate Studies
  final TextEditingController _gradSchoolCtrl = TextEditingController();
  final TextEditingController _gradCourseCtrl = TextEditingController();
  final TextEditingController _gradYearGradCtrl = TextEditingController();
  final TextEditingController _gradLevelCtrl = TextEditingController();
  final TextEditingController _gradYearLastCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- HEADER: CURRENTLY IN SCHOOL ---
        Row(
          children: [
            _buildLabel("Currently in School?"),
            const SizedBox(width: 20),
            _buildRadio(
              "YES",
              "Yes",
              _currentlyInSchool,
              (v) => setState(() => _currentlyInSchool = v!),
            ),
            const SizedBox(width: 15),
            _buildRadio(
              "NO",
              "No",
              _currentlyInSchool,
              (v) => setState(() => _currentlyInSchool = v!),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.black54, thickness: 1.5),

        // --- TABLE HEADERS ---
        // Top row of headers
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "LEVEL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  "NAME OF SCHOOL\n(State in Full / No Acronym)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  "COURSE\n(State in Full / No Acronym)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "YEAR\nGRADUATED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  "IF UNDERGRADUATE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black26),
        // Bottom row of headers (for the split undergraduate section)
        Row(
          children: [
            Expanded(
              flex: 10,
              child: const SizedBox(),
            ), // Spacers to push to the right
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "LEVEL\nREACHED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "YEAR LAST\nATTENDED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black54),
        const SizedBox(height: 10),

        // --- ROW 1: ELEMENTARY ---
        _buildEducRow(
          const Text(
            "Elementary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          _elemSchoolCtrl,
          Container(
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            height: 48,
            child: const Text(
              "N/A",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          _elemYearGradCtrl,
          _elemLevelCtrl,
          _elemYearLastCtrl,
        ),
        const Divider(),

        // --- ROW 2: SECONDARY ---
        _buildEducRow(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Secondary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 5),
              _buildRadio(
                "Non-K12",
                "Non-K12",
                _secondaryType,
                (v) => setState(() => _secondaryType = v!),
              ),
              _buildRadio(
                "K12",
                "K12",
                _secondaryType,
                (v) => setState(() => _secondaryType = v!),
              ),
            ],
          ),
          _secSchoolCtrl,
          _buildGreyTextFieldController(_secCourseCtrl, hint: "Strand if K12:"),
          _secYearGradCtrl,
          _secLevelCtrl,
          _secYearLastCtrl,
        ),
        const Divider(),

        // --- ROW 3: TERTIARY ---
        _buildEducRow(
          const Text(
            "Tertiary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          _tertSchoolCtrl,
          _buildGreyTextFieldController(_tertCourseCtrl),
          _tertYearGradCtrl,
          _tertLevelCtrl,
          _tertYearLastCtrl,
        ),
        const Divider(),

        // --- ROW 4: GRADUATE STUDIES ---
        _buildEducRow(
          const Text(
            "Graduate Studies/\nPost-graduate",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          _gradSchoolCtrl,
          _buildGreyTextFieldController(_gradCourseCtrl),
          _gradYearGradCtrl,
          _gradLevelCtrl,
          _gradYearLastCtrl,
        ),

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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Educational Background Saved!")),
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

  // Helper for creating consistent radio buttons
  Widget _buildRadio(
    String title,
    String value,
    String groupValue,
    Function(String?) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          activeColor: const Color(0xFF1D3A8A), // primaryAccent equivalent
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        GestureDetector(
          onTap: () => onChanged(value),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Helper for generating the Educational Background table rows
  Widget _buildEducRow(
    Widget levelWidget,
    TextEditingController schoolCtrl,
    Widget courseWidget,
    TextEditingController yearGradCtrl,
    TextEditingController levelReachedCtrl,
    TextEditingController yearLastCtrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 10.0),
              child: levelWidget,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildGreyTextFieldController(schoolCtrl),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: courseWidget,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildGreyTextFieldController(
                yearGradCtrl,
                isNumber: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildGreyTextFieldController(levelReachedCtrl),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildGreyTextFieldController(
                yearLastCtrl,
                isNumber: true,
              ),
            ),
          ),
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
