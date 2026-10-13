import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../widgets/settings_tile.dart';
import 'creator_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(padding: const EdgeInsets.all(18), children: [Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEDEAFF), Color(0xFFEAF3FF)]), borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.qr_code_2_rounded, size: 38, color: AppColors.purple), SizedBox(height: 12), Text(appTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.ink)), Text('Version 1.0.0', style: TextStyle(color: AppColors.muted))])), const SizedBox(height: 18), const Text('ABOUT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: 1.2)), const SizedBox(height: 8), SettingsTile(icon: Icons.person_outline_rounded, title: 'About the creator', subtitle: 'Meet the developer behind QR Nova', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorScreen()))), const SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Privacy', subtitle: 'Camera is used to scan QR codes'), const SettingsTile(icon: Icons.info_outline_rounded, title: 'App information', subtitle: 'Create, scan and share QR codes') ]));
}
