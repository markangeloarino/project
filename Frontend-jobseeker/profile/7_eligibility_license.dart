import 'package:flutter/material.dart';

// --- DATA MODELS FOR DYNAMIC ROWS ---
class EligibilityRecord {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
}

class LicenseRecord {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
}

class EligibilityLicense extends StatefulWidget {
  final Map<String, dynamic>? user;
  const EligibilityLicense({super.key, required this.user});

  @override
  State<EligibilityLicense> createState() => _EligibilityLicenseState();
}

class _EligibilityLicenseState extends State<EligibilityLicense> {
  // Initialize with one empty row for each section
  final List<EligibilityRecord> _eligibilities = [EligibilityRecord()];
  final List<LicenseRecord> _licenses = [LicenseRecord()];

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    for (var e in _eligibilities) {
      e.nameCtrl.dispose();
      e.dateCtrl.dispose();
    }
    for (var l in _licenses) {
      l.nameCtrl.dispose();
      l.dateCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- ELIGIBILITY SECTION ---
        _buildLabel("ELIGIBILITY (Civil Service)"),
        for (int i = 0; i < _eligibilities.length; i++)
          _buildEligibilityRow(i, _eligibilities[i]),
        
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _eligibilities.add(EligibilityRecord());
            });
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF3B82F6)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            "ADD ELIGIBILITY",
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // --- LICENSE SECTION ---
        _buildLabel("PROFESSIONAL LICENSE (PRC)"),
        for (int i = 0; i < _licenses.length; i++)
          _buildLicenseRow(i, _licenses[i]),
          
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _licenses.add(LicenseRecord());
            });
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF3B82F6)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            "ADD LICENSE",
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),

        const SizedBox(height: 40),
        const Divider(color: Colors.black12, thickness: 1),
        const SizedBox(height: 16),

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

  Widget _buildEligibilityRow(int index, EligibilityRecord record) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
            child: _buildGreyTextFieldController(
              record.nameCtrl,
              hint: "Eligibility",
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildGreyTextFieldController(
              record.dateCtrl,
              hint: "Date Taken (mm/dd/yyyy)",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseRow(int index, LicenseRecord record) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
            child: _buildGreyTextFieldController(
              record.nameCtrl,
              hint: "Professional License (PRC)",
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildGreyTextFieldController(
              record.dateCtrl,
              hint: "Valid Until (mm/dd/yyyy)",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
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
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
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