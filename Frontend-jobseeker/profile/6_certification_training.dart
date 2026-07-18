import 'package:flutter/material.dart';

// --- DATA MODEL FOR DYNAMIC ROWS ---
class TrainingRecord {
  final TextEditingController courseCtrl = TextEditingController();
  final TextEditingController dateFromCtrl = TextEditingController();
  final TextEditingController dateToCtrl = TextEditingController();
  final TextEditingController hoursCtrl = TextEditingController();
  final TextEditingController institutionCtrl = TextEditingController();
  final TextEditingController certsCtrl = TextEditingController();
}

class CertificationTraining extends StatefulWidget {
  final Map<String, dynamic>? user;
  const CertificationTraining({super.key, required this.user});

  @override
  State<CertificationTraining> createState() => _CertificationTrainingState();
}

class _CertificationTrainingState extends State<CertificationTraining> {
  // Initialize with 3 rows to match original behavior
  final List<TrainingRecord> _trainings = List.generate(
    3,
    (_) => TrainingRecord(),
  );

  @override
  void dispose() {
    // Dispose dynamic controllers to prevent memory leaks
    for (var record in _trainings) {
      record.courseCtrl.dispose();
      record.dateFromCtrl.dispose();
      record.dateToCtrl.dispose();
      record.hoursCtrl.dispose();
      record.institutionCtrl.dispose();
      record.certsCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(
          "V. TECHNICAL/VOCATIONAL AND OTHER TRAINING (include courses taken as part of college education)",
        ),
        const Divider(color: Colors.black54, thickness: 1.5),
        const SizedBox(height: 8),

        // --- TABULAR HEADERS ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    "TRAINING/VOCATIONAL\nCOURSE",
                    textAlign: TextAlign.center,
                    style: _headerStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("INCLUSIVE DATES", style: _headerStyle()),
                  const SizedBox(height: 4),
                  Text("(mm/dd/yyyy)", style: _subHeaderStyle()),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Center(
                            child: Text("From", style: _subHeaderStyle()),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Center(
                            child: Text("To", style: _subHeaderStyle()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    "TOTAL\nNO. OF\nHOURS",
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
                    "TRAINING\nINSTITUTION",
                    textAlign: TextAlign.center,
                    style: _headerStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: Text(
                    "CERTIFICATES\nRECEIVED",
                    textAlign: TextAlign.center,
                    style: _headerStyle(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.black26, thickness: 1.5),

        // --- DYNAMIC DATA ROWS ---
        for (int i = 0; i < _trainings.length; i++)
          _buildTrainingRow(_trainings[i]),

        const SizedBox(height: 16),

        // --- ADD BUTTON OPTION ---
        OutlinedButton(
          onPressed: () {
            setState(() {
              _trainings.add(TrainingRecord());
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
            "ADD TRAINING ROW",
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
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

  Widget _buildTrainingRow(TrainingRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Title Field
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildGreyTextFieldController(record.courseCtrl),
            ),
          ),

          // Dates Field Split (Properly contained in flex: 3 to match header)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: _buildGreyTextFieldController(
                      record.dateFromCtrl,
                      hint: "From",
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildGreyTextFieldController(
                      record.dateToCtrl,
                      hint: "To",
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hours Field
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildGreyTextFieldController(
                record.hoursCtrl,
                isNumber: true,
              ),
            ),
          ),

          // Institution Field
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildGreyTextFieldController(record.institutionCtrl),
            ),
          ),

          // Certificates Field
          Expanded(
            flex: 2,
            child: _buildGreyTextFieldController(record.certsCtrl),
          ),
        ],
      ),
    );
  }

  // Header Typography Style
  TextStyle _headerStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade700,
      fontSize: 12,
    );
  }

  // Sub-header Typography Style
  TextStyle _subHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade600,
      fontSize: 11,
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
  }

  Widget _buildGreyTextFieldController(
    TextEditingController controller, {
    String? hint,
    bool isNumber = false,
  }) {
    return Container(
      height: 44,
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
