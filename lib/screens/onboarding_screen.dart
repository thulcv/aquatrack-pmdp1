import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int page = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'icon': Icons.water_drop,
      'title': 'Track Your Water',
      'text': 'Monitor your household water usage easily.',
    },
    {
      'icon': Icons.bar_chart,
      'title': 'Understand Your Usage',
      'text': 'Discover how much water your activities consume.',
    },
    {
      'icon': Icons.notifications_active,
      'title': 'Build Better Habits',
      'text': 'Receive reminders and reduce water wastage.',
    },
  ];

  void nextPage() {
    if (page < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (value) {
                    setState(() => page = value);
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 230,
                          height: 230,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFF3FF),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Icon(
                            pages[index]['icon'],
                            size: 110,
                            color: const Color(0xFF1689C5),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          pages[index]['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF17324D),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pages[index]['text'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) => Container(
                    margin: const EdgeInsets.all(4),
                    height: 8,
                    width: page == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: page == index
                          ? const Color(0xFF1689C5)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: nextPage,
                child: Text(page == 2 ? 'Get Started' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}