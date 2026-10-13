import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_constants.dart';
import '../widgets/creator_avatar.dart';

class CreatorScreen extends StatelessWidget {
  const CreatorScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('About the creator')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CreatorAvatar(radius: 54),
            const SizedBox(height: 18),
            const Text(
              creatorName,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Creator of QR Scan Karo',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: AppColors.purple),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      creatorEmail,
                      style: TextStyle(color: AppColors.ink),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(text: creatorEmail),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email copied')),
                      );
                    },
                    icon: const Icon(
                      Icons.copy_rounded,
                      color: AppColors.purple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thanks for using QR Scan Karo ✨',
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    ),
  );
}
