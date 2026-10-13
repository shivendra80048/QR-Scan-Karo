import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../models/scan_entry.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key, required this.entry, this.onTap});
  final ScanEntry entry;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    leading: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        entry.isGenerated
            ? Icons.qr_code_2_rounded
            : Icons.qr_code_scanner_rounded,
        color: AppColors.purple,
      ),
    ),
    title: Text(
      entry.value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
    ),
    subtitle: Text(
      '${entry.isGenerated ? 'Generated' : 'Scanned'} • ${entry.date.toLocal().toString().substring(0, 16)}',
      style: const TextStyle(fontSize: 11, color: AppColors.muted),
    ),
    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
  );
}
