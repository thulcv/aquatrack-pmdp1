import 'package:flutter/material.dart';
import '../models/water_usage.dart';

class UsageCard extends StatelessWidget {
  final WaterUsage usage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UsageCard({
    super.key,
    required this.usage,
    required this.onEdit,
    required this.onDelete,
  });

  IconData getActivityIcon() {
    switch (usage.category.toLowerCase()) {
      case 'shower':
        return Icons.shower;
      case 'laundry':
        return Icons.local_laundry_service;
      case 'cooking':
        return Icons.restaurant;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'gardening':
        return Icons.grass;
      default:
        return Icons.water_drop;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFDFF3FF),
          child: Icon(getActivityIcon(),
              color: const Color(0xFF1689C5)),
        ),
        title: Text(usage.activity,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${usage.category} • ${usage.date.day}/${usage.date.month}/${usage.date.year}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${usage.litres} L',
                style: const TextStyle(
                    color: Color(0xFF1689C5),
                    fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}