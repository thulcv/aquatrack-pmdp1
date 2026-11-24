import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final bool isRegistration;

  const OtpScreen({
    super.key,
    required this.email,
    required this.name,
    required this.password,
    required this.isRegistration,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final codeController = TextEditingController();
  late String generatedCode;
  bool verified = false;

  static const characters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  String generateCode() {
    final random = Random.secure();

    return List.generate(
      6,
          (_) => characters[random.nextInt(characters.length)],
    ).join();
  }

  @override
  void initState() {
    super.initState();
    generatedCode = generateCode();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> verifyCode() async {
    if (codeController.text.trim().toUpperCase() != generatedCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect verification code. Try again.'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (widget.isRegistration) {
      await prefs.setString('user_name', widget.name);
      await prefs.setString('user_email', widget.email);
      await prefs.setString('user_password', widget.password);
    }

    setState(() => verified = true);

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.verified,
          color: Color(0xFF35A879),
          size: 55,
        ),
        title: const Text('Verified Successfully!'),
        content: const Text(
          'Your verification has been completed successfully.',
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          userName: widget.name,
        ),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 30),

              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF3FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 55,
                  color: Color(0xFF1689C5),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Verify your account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163B55),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter the verification code for ${widget.email}.',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // DEMO ONLY: Display the generated code.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F5FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'YOUR DEMO VERIFICATION CODE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF163B55),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      generatedCode,
                      style: const TextStyle(
                        fontSize: 28,
                        letterSpacing: 6,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1689C5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'For testing purposes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: codeController,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  hintText: 'Enter 6 characters',
                  counterText: '',
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: verifyCode,
                child: const Text('Verify & Continue'),
              ),

              const SizedBox(height: 15),

              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      generatedCode = generateCode();
                      codeController.clear();
                    });
                  },
                  child: const Text('Generate a new code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}