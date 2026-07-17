import 'package:flutter/material.dart';

class PersonalInformation extends StatefulWidget {
  final Map<String, dynamic>? user;
  const PersonalInformation({super.key, required this.user});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  // --- EXISTING CONTROLLERS ---
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _contactCtrl = TextEditingController();
  // final TextEditingController _dobCtrl = TextEditingController();
  // String _selectedSex = "Male";

  // --- NEW CONTROLLERS (Based on image) ---
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _religionCtrl = TextEditingController();
  final TextEditingController _houseNoCtrl = TextEditingController();
  final TextEditingController _barangayCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _provinceCtrl = TextEditingController();
  final TextEditingController _tinCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _otherDisabilityCtrl = TextEditingController();

  bool _isFirstTimeJobseeker = true;
  String _civilStatus = "Single";
  String _disability = "None";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FIRST TIME JOB SEEKER TOGGLE
        Row(
          children: [
            const Text(
              "Are you a first-time Jobseeker?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 20),
            Switch(
              value: _isFirstTimeJobseeker,
              activeColor: Colors.blue,
              onChanged: (val) => setState(() => _isFirstTimeJobseeker = val),
            ),
            Text(
              _isFirstTimeJobseeker ? "YES" : "NO",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(height: 30),

        // ROW 1: AGE, RELIGION, CIVIL STATUS
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("AGE"),
                  _buildGreyTextFieldController(_ageCtrl, isNumber: true),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("RELIGION"),
                  _buildGreyTextFieldController(_religionCtrl),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("CIVIL STATUS"),
                  _buildDropdown(
                    ["Single", "Married", "Widowed", "Separated"],
                    _civilStatus,
                    (v) => setState(() => _civilStatus = v!),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ROW 2 & 3: PRESENT ADDRESS
        _buildLabel("PRESENT ADDRESS"),
        Row(
          children: [
            Expanded(
              child: _buildGreyTextFieldController(
                _houseNoCtrl,
                hint: "House No./Street/Village",
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildGreyTextFieldController(
                _barangayCtrl,
                hint: "Barangay",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildGreyTextFieldController(
                _cityCtrl,
                hint: "Municipality/City",
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildGreyTextFieldController(
                _provinceCtrl,
                hint: "Province",
              ),
            ),
          ],
        ),

        // ROW 4: TIN & HEIGHT
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("TIN"),
                  _buildGreyTextFieldController(_tinCtrl),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("HEIGHT (FT.)"),
                  _buildGreyTextFieldController(_heightCtrl),
                ],
              ),
            ),
          ],
        ),

        // ROW 5: DISABILITY
        _buildLabel("DISABILITY"),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildDropdown(
                [
                  "None",
                  "Visual",
                  "Speech",
                  "Mental",
                  "Hearing",
                  "Physical",
                  "Others",
                ],
                _disability,
                (v) => setState(() => _disability = v!),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 3,
              child: _disability == "Others"
                  ? _buildGreyTextFieldController(
                      _otherDisabilityCtrl,
                      hint: "Please specify disability...",
                    )
                  : const SizedBox.shrink(), // Hides text box unless 'Others' is selected
            ),
          ],
        ),

        // ROW 6: CONTACT NUMBER AND EMAIL
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("CONTACT NUMBER/S"),
                  _buildGreyTextFieldController(_contactCtrl, isNumber: true),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("E-MAIL"),
                  _buildGreyTextFieldController(_emailCtrl),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // SAVE BUTTON
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
                const SnackBar(content: Text("Personal Information Saved!")),
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

  // Reusable dropdown builder for Civil Status & Disability
  Widget _buildDropdown(
    List<String> items,
    String currentValue,
    Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: currentValue,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
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
