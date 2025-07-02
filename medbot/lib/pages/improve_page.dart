import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../theme_provider.dart';

class ImprovePage extends StatefulWidget {
  @override
  State<ImprovePage> createState() => _ImprovePageState();
}

class _ImprovePageState extends State<ImprovePage> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  Future<void> submitSuggestion(String text) async {
    setState(() {
      _loading = true;
      _submitted = false;
    });
    final url = Uri.parse('https://formspree.io/f/mvgryabv');
    final res = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {
        'message': text,
        // Optionally add more fields, e.g., 'type': 'resource', etc.
      },
    );
    setState(() {
      _loading = false;
      _submitted = res.statusCode == 200;
    });
    if (_submitted) {
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thank you for your feedback!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final thm = Provider.of<ThmPrvdr>(context);
    return Container(
      color: thm.bg(),
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Help Us Improve MedBot", style: thm.hdFnt),
          SizedBox(height: 16),
          Text(
            "Contribute to our database! Suggest a new trusted medical website, resource, or share feedback to make MedBot smarter and more accurate for everyone.",
            style: thm.fnt,
          ),
          SizedBox(height: 24),
          TextField(
            controller: _controller,
            maxLines: 3,
            enabled: !_loading && !_submitted,
            decoration: InputDecoration(
              hintText: "Type your suggestion or trusted source link...",
              filled: true,
              fillColor: thm.chatInputBg(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              hintStyle: thm.fnt.copyWith(color: Colors.white54),
            ),
            style: thm.fnt.copyWith(color: Colors.white),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 180,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: thm.pri,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: _loading
                  ? SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Icon(Icons.send_rounded, color: Colors.white),
              label: Text(
                _submitted ? "Submitted" : "Submit",
                style: thm.fnt.copyWith(color: Colors.white),
              ),
              onPressed: _loading || _submitted
                  ? null
                  : () {
                      final txt = _controller.text.trim();
                      if (txt.isEmpty) return;
                      submitSuggestion(txt);
                    },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
