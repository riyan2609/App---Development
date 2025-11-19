import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/responsive_button.dart';
import 'dashboard_page.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otp = TextEditingController();
  final auth = AuthService();
  bool loading = false;

  verify() async {
    setState(() => loading = true);
    final ok = await auth.verifyOTP(otp.text);
    if (ok && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffC9E8FF), Color(0xffA8D8FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter OTP 🔐",
                  style: TextStyle(
                    color: Color(0xff0066CC),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: otp,
                  decoration: InputDecoration(
                    labelText: "OTP Code",
                    filled: true,
                    fillColor: const Color(0xffE5F2FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : ResponsiveButton(text: "Verify OTP", onTap: verify),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
