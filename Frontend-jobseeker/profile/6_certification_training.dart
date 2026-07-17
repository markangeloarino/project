import 'package:flutter/material.dart';

class CertificationTraining extends StatefulWidget {
  final Map<String, dynamic>? user;
  const CertificationTraining({super.key, required this.user});

  @override
  State<CertificationTraining> createState() => _CertificationTrainingState();
}

class _CertificationTrainingState extends State<CertificationTraining> {
  // --- TECHNICAL/VOCATIONAL TRAINING STATE ---
  final List<TextEditingController> _courseCtrl = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _dateFromCtrl = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _dateToCtrl = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _hoursCtrl = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _institutionCtrl = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _certsCtrl = List.generate(
    3,
    (_) => TextEditingController(),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(
          "V. TECHNICAL/VOCATIONAL AND OTHER TRAINING (include courses taken as part of college education)",
        ),
        const Divider(color: Colors.black54, thickness: 1.5),

        // --- TABLE HEADER ---
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  "TRAINING/VOCATIONAL\nCOURSE",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  "INCLUSIVE DATES\n(mm/dd/yyyy)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "TOTAL\nNO. OF\nHOURS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "TRAINING\nINSTITUTION",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "CERTIFICATES\nRECEIVED",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black54),

        // --- ROWS ---
        for (int i = 0; i < 3; i++) _buildTrainingRow(i),

        const SizedBox(height: 40),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Training data saved!")),
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildGreyTextFieldController(_courseCtrl[index]),
          ),
          const SizedBox(width: 5),
          // Split Dates
          Expanded(
            flex: 1,
            child: _buildGreyTextFieldController(
              _dateFromCtrl[index],
              hint: "From",
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: 1,
            child: _buildGreyTextFieldController(
              _dateToCtrl[index],
              hint: "To",
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: _buildGreyTextFieldController(
              _hoursCtrl[index],
              isNumber: true,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: _buildGreyTextFieldController(_institutionCtrl[index]),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: _buildGreyTextFieldController(_certsCtrl[index]),
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
