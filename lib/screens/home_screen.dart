import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'scanner_screen.dart';
import 'generator_screen.dart';
import 'creator_screen.dart';
import '../app_constants.dart';
import '../services/scan_history.dart';
import '../widgets/creator_avatar.dart';
import '../widgets/home_action_card.dart';
import '../widgets/history_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _scanImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (!mounted || file == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ScannerScreen(imagePath: file.path)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: AnimatedBuilder(
        animation: ScanHistory.instance,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: AppColors.gradient),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.qr_code_2_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appTitle,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        'Scan it. Create it. Share it.',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onNavigate(2),
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEDEAFF), Color(0xFFEAF3FF)],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your QR toolkit',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Everything you need, in one simple place.',
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                  SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: AppColors.purple,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Fast • Simple • Secure',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Get started',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeActionCard(
                  title: 'Scan QR',
                  subtitle: 'Scan with your camera',
                  icon: Icons.qr_code_scanner_rounded,
                  colors: AppColors.gradient,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScannerScreen()),
                  ),
                ),
                const SizedBox(width: 13),
                HomeActionCard(
                  title: 'Generate QR',
                  subtitle: 'Make your own QR code',
                  icon: Icons.qr_code_2_rounded,
                  colors: const [Color(0xFF9B7BF4), Color(0xFF7B6CE7)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GeneratorScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _scanImage,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.image_search_rounded,
                      color: AppColors.purple,
                      size: 26,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload QR Image',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Pick an image from your gallery to scan',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Recent scans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onNavigate(1),
                  child: const Text('See all'),
                ),
              ],
            ),
            if (ScanHistory.instance.entries.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: const Center(
                  child: Text(
                    'Your recent scans will appear here.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              )
            else
              ...ScanHistory.instance.entries
                  .take(3)
                  .map((e) => HistoryTile(entry: e)),
            const SizedBox(height: 18),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatorScreen()),
              ),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    const CreatorAvatar(radius: 19),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created by',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          creatorName,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
