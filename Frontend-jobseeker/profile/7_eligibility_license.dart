import 'package:flutter/material.dart';

class EligibilityLicense extends StatefulWidget {
  final Map<String, dynamic>? user;
  const EligibilityLicense({super.key, required this.user});
  @override
  State<EligibilityLicense> createState() => _EligibilityLicenseState();
}

class _EligibilityLicenseState extends State<EligibilityLicense> {
  // --- ELIGIBILITY/LICENSE STATE ---
  final List<TextEditingController> _eligibilityCtrl = List.generate(
    2,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _dateTakenCtrl = List.generate(
    2,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _licenseCtrl = List.generate(
    2,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _validUntilCtrl = List.generate(
    2,
    (_) => TextEditingController(),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("VI. ELIGIBILITY/PROFESSIONAL LICENSE"),
        const Divider(color: Colors.black54, thickness: 1.5),

        // --- TABLE HEADER ---
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  "ELIGIBILITY\n(Civil Service)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "DATE TAKEN",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  "PROFESSIONAL LICENSE (PRC)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "VALID UNTIL",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black54),

        // --- ROWS ---
        for (int i = 0; i < 2; i++) _buildEligibilityRow(i),

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
            ).showSnackBar(const SnackBar(content: Text("Eligibility saved!"))),
            child: const Text(
              "Save Changes",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEligibilityRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: Text(
              "${index + 1}.",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildGreyTextFieldController(_eligibilityCtrl[index]),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: _buildGreyTextFieldController(
              _dateTakenCtrl[index],
              hint: "mm/dd/yyyy",
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 3,
            child: _buildGreyTextFieldController(_licenseCtrl[index]),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: _buildGreyTextFieldController(
              _validUntilCtrl[index],
              hint: "mm/dd/yyyy",
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
