import 'package:flutter/material.dart';

class PersonalInformation extends StatefulWidget {
  final Map<String, dynamic>? user;
  const PersonalInformation({super.key, required this.user});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  // --- NEW CONTROLLERS (Name & DOB) ---
  final TextEditingController _surnameCtrl = TextEditingController();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _middleNameCtrl = TextEditingController();
  final TextEditingController _suffixCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();

  // --- EXISTING CONTROLLERS ---
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _contactCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _religionCtrl = TextEditingController();
  final TextEditingController _houseNoCtrl = TextEditingController();
  final TextEditingController _barangayCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _provinceCtrl = TextEditingController();
  final TextEditingController _tinCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _otherDisabilityCtrl = TextEditingController();

  String _isFirstTimeJobseeker = "Yes"; 
  
  // Changed to nullable strings so the dropdown hint shows initially
  String? _civilStatus;
  String? _selectedSex;
  
  // List to support multiple selections
  List<String> _selectedDisabilities = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- FIRST TIME JOB SEEKER RADIO BUTTONS ---
        Row(
          children: [
            const Text(
              "Are you a first-time Jobseeker?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 24),
            _buildRadio(
              "Yes",
              "Yes",
              _isFirstTimeJobseeker,
              (v) => setState(() => _isFirstTimeJobseeker = v!),
            ),
            const SizedBox(width: 20),
            _buildRadio(
              "No",
              "No",
              _isFirstTimeJobseeker,
              (v) => setState(() => _isFirstTimeJobseeker = v!),
            ),
          ],
        ),
        const Divider(height: 30, color: Colors.black54, thickness: 1.5),

        // --- ROW 1: FULL NAME ---
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("SURNAME"),
                  _buildGreyTextFieldController(_surnameCtrl),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("FIRST NAME"),
                  _buildGreyTextFieldController(_firstNameCtrl),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("MIDDLE NAME"),
                  _buildGreyTextFieldController(_middleNameCtrl),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("SUFFIX (Ex. Sr., Jr., III)"),
                  _buildGreyTextFieldController(_suffixCtrl),
                ],
              ),
            ),
          ],
        ),

        // --- ROW 2: DOB & SEX ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("DATE OF BIRTH (mm/dd/yy)"),
                  _buildGreyTextFieldController(_dobCtrl, hint: "mm/dd/yyyy"),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("SEX"),
                  _buildDropdown(
                    ["Male", "Female"],
                    _selectedSex,
                    (v) => setState(() => _selectedSex = v),
                    hint: "Select Sex",
                  ),
                ],
              ),
            ),
          ],
        ),

        // --- ROW 3: AGE, RELIGION, CIVIL STATUS ---
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
                    (v) => setState(() => _civilStatus = v),
                    hint: "Select Civil Status",
                  ),
                ],
              ),
            ),
          ],
        ),

        // --- ROW 4 & 5: PRESENT ADDRESS ---
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

        // --- ROW 6: TIN & HEIGHT ---
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

        // --- ROW 7: DISABILITY (Multiple Choices) ---
        _buildLabel("DISABILITY"),
        Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          children: [
            "None",
            "Visual",
            "Speech",
            "Mental",
            "Hearing",
            "Physical",
            "Others"
          ].map((disability) {
            return _buildCheckbox(disability);
          }).toList(),
        ),
        if (_selectedDisabilities.contains("Others")) ...[
          const SizedBox(height: 12),
          _buildGreyTextFieldController(
            _otherDisabilityCtrl,
            hint: "Please specify disability...",
          ),
        ],

        // --- ROW 8: CONTACT NUMBER AND EMAIL ---
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
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
              ),
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Personal Information saved!")),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3A8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
              ),
              child: const Text(
                "SAVE CHANGES",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper to build Radio Buttons
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
            height: 24,
            width: 24,
            child: Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: const Color(0xFF1D3A8A),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Helper to build Checkboxes for Disabilities
  Widget _buildCheckbox(String disability) {
    bool isSelected = _selectedDisabilities.contains(disability);

    return InkWell(
      onTap: () {
        setState(() {
          if (!isSelected) {
            if (disability == "None") {
              _selectedDisabilities.clear(); // Clear all if 'None' is checked
              _selectedDisabilities.add("None");
            } else {
              _selectedDisabilities.remove("None"); // Remove 'None' if another is checked
              _selectedDisabilities.add(disability);
            }
          } else {
            _selectedDisabilities.remove(disability);
          }
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: isSelected,
              activeColor: const Color(0xFF1D3A8A),
              onChanged: (bool? checked) {
                setState(() {
                  if (checked == true) {
                    if (disability == "None") {
                      _selectedDisabilities.clear();
                      _selectedDisabilities.add("None");
                    } else {
                      _selectedDisabilities.remove("None");
                      _selectedDisabilities.add(disability);
                    }
                  } else {
                    _selectedDisabilities.remove(disability);
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 6),
          Text(
            disability,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Reusable dropdown builder for Civil Status and Sex with hint support
  Widget _buildDropdown(
    List<String> items,
    String? currentValue,
    Function(String?) onChanged, {
    String? hint,
  }) {
    return Container(
      height: 44, // Matched height
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: currentValue,
          hint: hint != null
              ? Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 13))
              : null,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
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
          fontSize: 12,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  } 

  Widget _buildGreyTextFieldController(
    TextEditingController controller, {
    IconData? icon,
    String? hint,
    bool isNumber = false,
  }) {
    return Container(
      height: 44, // Ensure all text fields have uniform consistent heights
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
          suffixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
        ),
      ),
    );
  }
}