import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/responsive_button.dart';
import 'otp_page.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final phone = TextEditingController();
  final auth = AuthService();
  bool loading = false;

  sendOTP() async {
    setState(() => loading = true);
    await auth.sendOTP(phone.text);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpPage(phone: phone.text)),
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
                  "Phone Login 📱",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0066CC),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
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
                    : ResponsiveButton(text: "Send OTP", onTap: sendOTP),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
