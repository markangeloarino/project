import 'package:flutter/material.dart';

class EducationalBackground extends StatefulWidget {
  final Map<String, dynamic>? user;
  const EducationalBackground({super.key, required this.user});

  @override
  State<EducationalBackground> createState() => _EducationalBackgroundState();
}

class _EducationalBackgroundState extends State<EducationalBackground> {
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
        const SizedBox(height: 16),
        // --- HEADER: CURRENTLY IN SCHOOL ---
        Row(
          children: [
            const Text(
              "Currently in School?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 24),
            _buildRadio(
              "YES",
              "Yes",
              _currentlyInSchool,
              (v) => setState(() => _currentlyInSchool = v!),
            ),
            const SizedBox(width: 16),
            _buildRadio(
              "NO",
              "No",
              _currentlyInSchool,
              (v) => setState(() => _currentlyInSchool = v!),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: Colors.black54, thickness: 1.5),
        const SizedBox(height: 8),

        // --- TABLE HEADERS ---
        // Using a unified Row structure so flex values match the data rows perfectly
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    "LEVEL",
                    style: _headerStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    "NAME OF SCHOOL\n(State in Full / No Acronym)",
                    textAlign: TextAlign.center,
                    style: _headerStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    "COURSE\n(State in Full / No Acronym)",
                    textAlign: TextAlign.center,
                    style: _headerStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    "YEAR\nGRADUATED",
                    textAlign: TextAlign.center,
                    style: _headerStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("IF UNDERGRADUATE", style: _headerStyle()),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Center(
                            child: Text(
                              "LEVEL\nREACHED",
                              textAlign: TextAlign.center,
                              style: _subHeaderStyle(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "YEAR LAST\nATTENDED",
                            textAlign: TextAlign.center,
                            style: _subHeaderStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.black26, thickness: 1.5),

        // --- ROW 1: ELEMENTARY ---
        _buildEducRow(
          levelWidget: const Text(
            "Elementary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          schoolCtrl: _elemSchoolCtrl,
          courseWidget: Container(
            height: 44, // Matches the height of TextFields
            decoration: BoxDecoration(
              color: const Color(0xFFE2E2E2),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: const Text(
              "N/A",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          yearGradCtrl: _elemYearGradCtrl,
          levelReachedCtrl: _elemLevelCtrl,
          yearLastCtrl: _elemYearLastCtrl,
        ),
        const Divider(color: Colors.black12),

        // --- ROW 2: SECONDARY ---
        _buildEducRow(
          levelWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Secondary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
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
          schoolCtrl: _secSchoolCtrl,
          courseWidget: _buildGreyTextFieldController(
            _secCourseCtrl,
            hint: "Strand if K12:",
          ),
          yearGradCtrl: _secYearGradCtrl,
          levelReachedCtrl: _secLevelCtrl,
          yearLastCtrl: _secYearLastCtrl,
        ),
        const Divider(color: Colors.black12),

        // --- ROW 3: TERTIARY ---
        _buildEducRow(
          levelWidget: const Text(
            "Tertiary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          schoolCtrl: _tertSchoolCtrl,
          courseWidget: _buildGreyTextFieldController(_tertCourseCtrl),
          yearGradCtrl: _tertYearGradCtrl,
          levelReachedCtrl: _tertLevelCtrl,
          yearLastCtrl: _tertYearLastCtrl,
        ),
        const Divider(color: Colors.black12),

        // --- ROW 4: GRADUATE STUDIES ---
        _buildEducRow(
          levelWidget: const Text(
            "Graduate Studies/\nPost-graduate",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          schoolCtrl: _gradSchoolCtrl,
          courseWidget: _buildGreyTextFieldController(_gradCourseCtrl),
          yearGradCtrl: _gradYearGradCtrl,
          levelReachedCtrl: _gradLevelCtrl,
          yearLastCtrl: _gradYearLastCtrl,
        ),
        const Divider(color: Colors.black12),

        const SizedBox(height: 30),

        // ====================================
        // BOTTOM BUTTON
        // ====================================
        const SizedBox(height: 40),
        const Divider(color: Colors.black12, thickness: 1),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                // Handle Back Action
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3B82F6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Color(0xFF3B82F6)),
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Training data saved!")),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3A8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                "SAVE CHANGES",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper for Headers
  TextStyle _headerStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade700,
      fontSize: 12,
    );
  }

  // Helper for Sub-Headers
  TextStyle _subHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade600,
      fontSize: 11,
    );
  }

  // Helper for creating consistent radio buttons
  Widget _buildRadio(
    String title,
    String value,
    String groupValue,
    Function(String?) onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(value),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 28,
            width: 28,
            child: Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: const Color(0xFF1D3A8A),
              onChanged: onChanged,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Helper for generating the Educational Background table rows perfectly aligned
  Widget _buildEducRow({
    required Widget levelWidget,
    required TextEditingController schoolCtrl,
    required Widget courseWidget,
    required TextEditingController yearGradCtrl,
    required TextEditingController levelReachedCtrl,
    required TextEditingController yearLastCtrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 12.0),
              child: levelWidget,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildGreyTextFieldController(schoolCtrl),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: courseWidget,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildGreyTextFieldController(
                yearGradCtrl,
                isNumber: true,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildGreyTextFieldController(levelReachedCtrl),
                  ),
                ),
                Expanded(
                  child: _buildGreyTextFieldController(
                    yearLastCtrl,
                    isNumber: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Updated text field builder to guarantee consistent heights
  Widget _buildGreyTextFieldController(
    TextEditingController controller, {
    String? hint,
    bool isNumber = false,
  }) {
    return Container(
      height: 44, // Fixed height keeps the tabular rows aligned
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          isDense: true,
        ),
      ),
    );
  }
}