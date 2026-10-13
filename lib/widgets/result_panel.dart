import 'package:flutter/material.dart';
import '../app_constants.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({
    super.key,
    required this.value,
    required this.onCopy,
    required this.onClose,
  });
  final String value;
  final VoidCallback onCopy, onClose;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Scan result',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: AppColors.ink,
                ),
              ),
            ),
            IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
          ],
        ),
        SelectableText(value, style: const TextStyle(color: AppColors.ink)),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onCopy,
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy result'),
          ),
        ),
      ],
    ),
  );
}
