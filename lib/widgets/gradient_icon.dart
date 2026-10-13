import 'package:flutter/material.dart';
import '../app_constants.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon(this.icon, {super.key, this.size = 24, this.boxSize = 48});
  final IconData icon;
  final double size;
  final double boxSize;
  @override
  Widget build(BuildContext context) => Container(
    width: boxSize,
    height: boxSize,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: AppColors.gradient),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.purple.withValues(alpha: .18),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Icon(icon, size: size, color: Colors.white),
  );
}
