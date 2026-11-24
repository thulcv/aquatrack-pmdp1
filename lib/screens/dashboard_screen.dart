import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'water_usage_screen.dart';
import 'notification_screen.dart';
import 'report_screen.dart';
import 'add_usage_screen.dart';
import '../models/water_usage.dart';
import '../widgets/dashboard_card.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({
    super.key,
    required this.userName,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardHome(userName: widget.userName),
      const WaterUsageScreen(),
      const ReportScreen(),
      const NotificationScreen(),
    ];

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Usage',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
        ],
      ),
    );
  }
}

class DashboardHome extends StatefulWidget {
  final String userName;

  const DashboardHome({
    super.key,
    required this.userName,
  });

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  static const double dailyGoal = 150;

  List<WaterUsage> get records =>
      WaterUsageScreenStateHelper.records;

  double get todayTotal {
    final now = DateTime.now();

    return records
        .where(
          (item) =>
      item.date.year == now.year &&
          item.date.month == now.month &&
          item.date.day == now.day,
    )
        .fold(0.0, (sum, item) => sum + item.litres);
  }

  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> addUsage() async {
    final result = await Navigator.push<WaterUsage>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddUsageScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        records.insert(0, result);
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // This is a prototype logout, not server-side session termination.
    await prefs.remove('logged_in');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (dailyGoal - todayTotal).clamp(0.0, dailyGoal);
    final progress = (todayTotal / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AquaTrack',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
          children: [
            // Greeting
            Text(
              greeting(),
              style: const TextStyle(
                color: Color(0xFF78909C),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163B55),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Let’s make every drop count.',
              style: TextStyle(
                color: Color(0xFF78909C),
              ),
            ),

            const SizedBox(height: 25),

            // Main daily usage card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1689C5),
                    Color(0xFF62C9C1),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'TODAY\'S USAGE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        todayTotal.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          'litres',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor:
                      Colors.white.withOpacity(0.3),
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '${remaining.toStringAsFixed(1)} L remaining '
                        'of ${dailyGoal.toStringAsFixed(0)} L daily goal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Secondary cards
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Daily Goal',
                    value: '${dailyGoal.toStringAsFixed(0)} L',
                    subtitle: 'Your target',
                    icon: Icons.flag_outlined,
                    color: const Color(0xFF35A879),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Quick action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: addUsage,
                icon: const Icon(Icons.add),
                label: const Text('Add Water Usage'),
              ),
            ),

            const SizedBox(height: 25),

            // Water saving tip
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F5EF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        color: Color(0xFF35A879),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'A little water-saving tip',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF24674D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Turn off the tap while brushing your teeth. '
                        'Small everyday changes can make a difference.',
                    style: TextStyle(
                      color: Color(0xFF24674D),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Recent activities
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent activities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163B55),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (records.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: Text('No activities recorded yet.'),
                ),
              )
            else
              ...records.take(3).map(
                    (item) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFDFF3FF),
                      child: Icon(
                        Icons.water_drop,
                        color: Color(0xFF1689C5),
                      ),
                    ),
                    title: Text(item.activity),
                    subtitle: Text(item.category),
                    trailing: Text(
                      '${item.litres} L',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1689C5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}