import 'package:flutter/material.dart';

class LanguageDialect extends StatefulWidget {
  final Map<String, dynamic>? user;
  const LanguageDialect({super.key, required this.user});
  @override
  State<LanguageDialect> createState() => _LanguageDialectState();
}

class _LanguageDialectState extends State<LanguageDialect> {
  // --- LANGUAGE/DIALECT PROFICIENCY STATE ---
  bool _engRead = false,
      _engWrite = false,
      _engSpeak = false,
      _engUnderstand = false;
  bool _filRead = false,
      _filWrite = false,
      _filSpeak = false,
      _filUnderstand = false;
  bool _manRead = false,
      _manWrite = false,
      _manSpeak = false,
      _manUnderstand = false;
  bool _othRead = false,
      _othWrite = false,
      _othSpeak = false,
      _othUnderstand = false;
  final TextEditingController _othersLangCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("LANGUAGE/DIALECT PROFICIENCY (check if applicable)"),
        const Divider(color: Colors.black54, thickness: 1.5),

        // --- TABLE HEADER ---
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "LANGUAGE/DIALECT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "READ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "WRITE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "SPEAK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "UNDERSTAND",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black54),

        // --- ROWS ---
        _buildLangRow(
          "English",
          _engRead,
          (v) => setState(() => _engRead = v!),
          _engWrite,
          (v) => setState(() => _engWrite = v!),
          _engSpeak,
          (v) => setState(() => _engSpeak = v!),
          _engUnderstand,
          (v) => setState(() => _engUnderstand = v!),
        ),
        const Divider(),

        _buildLangRow(
          "Filipino",
          _filRead,
          (v) => setState(() => _filRead = v!),
          _filWrite,
          (v) => setState(() => _filWrite = v!),
          _filSpeak,
          (v) => setState(() => _filSpeak = v!),
          _filUnderstand,
          (v) => setState(() => _filUnderstand = v!),
        ),
        const Divider(),

        _buildLangRow(
          "Mandarin",
          _manRead,
          (v) => setState(() => _manRead = v!),
          _manWrite,
          (v) => setState(() => _manWrite = v!),
          _manSpeak,
          (v) => setState(() => _manSpeak = v!),
          _manUnderstand,
          (v) => setState(() => _manUnderstand = v!),
        ),
        const Divider(),

        // --- OTHERS ROW (Special Case with TextField) ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    const Text(
                      "Others: ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: _buildGreyTextFieldController(_othersLangCtrl),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Checkbox(
                    value: _othRead,
                    onChanged: (v) => setState(() => _othRead = v!),
                    activeColor: const Color(0xFF1D3A8A),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Checkbox(
                    value: _othWrite,
                    onChanged: (v) => setState(() => _othWrite = v!),
                    activeColor: const Color(0xFF1D3A8A),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Checkbox(
                    value: _othSpeak,
                    onChanged: (v) => setState(() => _othSpeak = v!),
                    activeColor: const Color(0xFF1D3A8A),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Checkbox(
                    value: _othUnderstand,
                    onChanged: (v) => setState(() => _othUnderstand = v!),
                    activeColor: const Color(0xFF1D3A8A),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),

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
                const SnackBar(content: Text("Language Proficiency Saved!")),
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

  // Helper for generating the Language/Dialect rows
  Widget _buildLangRow(
    String lang,
    bool read,
    Function(bool?) onRead,
    bool write,
    Function(bool?) onWrite,
    bool speak,
    Function(bool?) onSpeak,
    bool understand,
    Function(bool?) onUnderstand,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              lang,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Checkbox(
                value: read,
                onChanged: onRead,
                activeColor: const Color(0xFF1D3A8A),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Checkbox(
                value: write,
                onChanged: onWrite,
                activeColor: const Color(0xFF1D3A8A),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Checkbox(
                value: speak,
                onChanged: onSpeak,
                activeColor: const Color(0xFF1D3A8A),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Checkbox(
                value: understand,
                onChanged: onUnderstand,
                activeColor: const Color(0xFF1D3A8A),
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
