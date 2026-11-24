import 'package:flutter/material.dart';
import 'water_usage_screen.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = WaterUsageScreenStateHelper.records;

    final double total = records.fold(
      0.0,
          (sum, item) => sum + item.litres,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Usage Report')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1689C5),
                    Color(0xFF45B6D8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recorded Water Usage',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${total.toStringAsFixed(1)} L',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Activity Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: records.isEmpty
                  ? const Center(
                child: Text('No records available.'),
              )
                  : ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final item = records[index];

                  final double percentage =
                  total > 0 ? item.litres / total : 0.0;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(item.activity),
                              ),
                              Text(
                                '${item.litres} L',
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: percentage,
                            minHeight: 8,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}