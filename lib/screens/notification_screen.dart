import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool enabled = false;
  TimeOfDay reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      enabled = prefs.getBool('reminder_enabled') ?? false;
      reminderTime = TimeOfDay(
        hour: prefs.getInt('reminder_hour') ?? 20,
        minute: prefs.getInt('reminder_minute') ?? 0,
      );
      loading = false;
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('reminder_enabled', enabled);
    await prefs.setInt('reminder_hour', reminderTime.hour);
    await prefs.setInt('reminder_minute', reminderTime.minute);

    if (enabled) {
      await NotificationService.scheduleDaily(
          reminderTime.hour, reminderTime.minute);
    } else {
      await NotificationService.cancelReminder();
    }
  }

  Future<void> selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );

    if (selected != null) {
      setState(() => reminderTime = selected);
      await saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: SwitchListTile(
                title: const Text('Daily Reminder'),
                subtitle: const Text(
                    'Receive a daily water usage reminder'),
                value: enabled,
                onChanged: (value) async {
                  setState(() => enabled = value);
                  await saveSettings();
                },
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Reminder Time'),
                subtitle: Text(reminderTime.format(context)),
                trailing: const Icon(Icons.edit),
                onTap: selectTime,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await NotificationService.showNotification();
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Test Notification'),
            ),
          ],
        ),
      ),
    );
  }
}