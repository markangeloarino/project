import 'package:flutter/material.dart';

class OtherSkills extends StatefulWidget {
  final Map<String, dynamic>? user;
  const OtherSkills({super.key, required this.user});

  @override
  State<OtherSkills> createState() => _OtherSkillsState();
}

class _OtherSkillsState extends State<OtherSkills> {
  // --- OTHER SKILLS STATE ---
  final Map<String, bool> _skills = {
    "Auto Mechanic": false,
    "Beautician": false,
    "Carpentry Work": false,
    "Computer Literate": false,
    "Domestic Chores": false,
    "Driver": false,
    "Electrician": false,
    "Embroidery": false,
    "Gardening": false,
    "Masonry": false,
    "Painter/Artist": false,
    "Painting Jobs": false,
    "Photography": false,
    "Plumbing": false,
    "Sewing Dresses": false,
    "Stenography": false,
    "Tailoring": false,
  };
  final TextEditingController _othersSkillCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("VIII. OTHER SKILLS ACQUIRED WITHOUT CERTIFICATE"),
        const Divider(color: Colors.black54, thickness: 1.5),
        const SizedBox(height: 15),

        // Grid layout for skills
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _skills.keys.map((skill) {
            return SizedBox(
              width: 250, // Ensures 3-column layout on wide screens
              child: _buildCheckbox(
                skill,
                _skills[skill]!,
                (v) => setState(() => _skills[skill] = v!),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: _buildGreyTextFieldController(
            _othersSkillCtrl,
            hint: "Others:",
          ),
        ),

        const SizedBox(height: 40),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Skills saved!"))),
            child: const Text(
              "Save Changes",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

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
