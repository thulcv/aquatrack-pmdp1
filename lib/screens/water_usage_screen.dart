import 'package:flutter/material.dart';
import '../models/water_usage.dart';
import '../widgets/usage_card.dart';
import 'add_usage_screen.dart';

// Shared list for the Usage screen and Report screen
class WaterUsageScreenStateHelper {
  static final List<WaterUsage> records = [
    WaterUsage(
      id: '1',
      activity: 'Morning Shower',
      litres: 45,
      category: 'Shower',
      date: DateTime.now(),
    ),
    WaterUsage(
      id: '2',
      activity: 'Washing Dishes',
      litres: 20,
      category: 'Cleaning',
      date: DateTime.now(),
    ),
    WaterUsage(
      id: '3',
      activity: 'Laundry',
      litres: 55,
      category: 'Laundry',
      date: DateTime.now(),
    ),
  ];
}

class WaterUsageScreen extends StatefulWidget {
  const WaterUsageScreen({super.key});

  @override
  State<WaterUsageScreen> createState() =>
      _WaterUsageScreenState();
}

class _WaterUsageScreenState extends State<WaterUsageScreen> {
  final List<WaterUsage> records =
      WaterUsageScreenStateHelper.records;

  Future<void> openForm([WaterUsage? usage]) async {
    final result = await Navigator.push<WaterUsage>(
      context,
      MaterialPageRoute(
        builder: (_) => AddUsageScreen(usage: usage),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        if (usage != null) {
          final index = records.indexWhere(
                (item) => item.id == usage.id,
          );

          if (index != -1) {
            records[index] = result;
          }
        } else {
          records.insert(0, result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Usage')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: records.isEmpty
          ? const Center(
        child: Text('No water usage records yet.'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final item = records[index];

          return UsageCard(
            usage: item,
            onEdit: () => openForm(item),
            onDelete: () {
              setState(() {
                records.removeAt(index);
              });
            },
          );
        },
      ),
    );
  }
}