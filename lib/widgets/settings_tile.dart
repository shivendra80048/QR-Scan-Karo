import 'package:flutter/material.dart';
import '../app_constants.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon, color: AppColors.purple),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(color: AppColors.muted, fontSize: 12),
    ),
    trailing: const Icon(Icons.chevron_right_rounded),
  );
}
