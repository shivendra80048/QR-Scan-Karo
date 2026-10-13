import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../services/scan_history.dart';
import '../widgets/history_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('History'),
      actions: [
        IconButton(
          tooltip: 'Clear history',
          onPressed: () => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Clear history?'),
              content: const Text(
                'This removes the current scan and generated QR list.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ScanHistory.instance.clear();
                    Navigator.pop(ctx);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ],
    ),
    body: AnimatedBuilder(
      animation: ScanHistory.instance,
      builder: (context, _) {
        final entries = ScanHistory.instance.entries;
        if (entries.isEmpty)
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded, size: 54, color: AppColors.purple),
                SizedBox(height: 12),
                Text(
                  'Nothing here yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Scanned and generated QR codes show here.',
                  style: TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          );
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          separatorBuilder: (_, _) =>
              const Divider(height: 1, color: AppColors.border),
          itemBuilder: (_, i) => HistoryTile(entry: entries[i]),
        );
      },
    ),
  );
}
