import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
    final IconData icon;
    final String label;

    const InfoChip({
        required this.icon,
        required this.label,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Icon(icon, size: 16),
                    const SizedBox(width: 4),
                    Text(label),
                ],
            ),
        );
    }
}