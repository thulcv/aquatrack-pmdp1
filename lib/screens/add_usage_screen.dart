import 'package:flutter/material.dart';
import '../models/water_usage.dart';

class AddUsageScreen extends StatefulWidget {
  final WaterUsage? usage;

  const AddUsageScreen({super.key, this.usage});

  @override
  State<AddUsageScreen> createState() => _AddUsageScreenState();
}

class _AddUsageScreenState extends State<AddUsageScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController activityController;
  late TextEditingController litresController;
  late TextEditingController noteController;
  String category = 'Shower';

  final categories = [
    'Shower',
    'Cleaning',
    'Laundry',
    'Cooking',
    'Gardening',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    activityController =
        TextEditingController(text: widget.usage?.activity ?? '');
    litresController =
        TextEditingController(
            text: widget.usage?.litres.toString() ?? '');
    noteController =
        TextEditingController(text: widget.usage?.note ?? '');
    category = widget.usage?.category ?? 'Shower';
  }

  @override
  void dispose() {
    activityController.dispose();
    litresController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;

    final record = WaterUsage(
      id: widget.usage?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      activity: activityController.text,
      litres: double.parse(litresController.text),
      category: category,
      date: widget.usage?.date ?? DateTime.now(),
      note: noteController.text,
    );

    Navigator.pop(context, record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usage == null
            ? 'Add Water Usage'
            : 'Edit Water Usage'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: activityController,
                decoration: const InputDecoration(
                    labelText: 'Activity Name'),
                validator: (v) =>
                v == null || v.isEmpty
                    ? 'Enter activity name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: litresController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                decoration: const InputDecoration(
                    labelText: 'Water Used (Litres)'),
                validator: (v) {
                  final value = double.tryParse(v ?? '');
                  if (value == null || value <= 0) {
                    return 'Enter a valid water amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                decoration:
                const InputDecoration(labelText: 'Category'),
                items: categories.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => category = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Notes (Optional)'),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: save,
                child: const Text('Save Usage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}