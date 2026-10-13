import 'package:flutter/material.dart';
import '../app_constants.dart';

class CreatorAvatar extends StatelessWidget {
  const CreatorAvatar({super.key, this.radius = 23});
  final double radius;
  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: AppColors.lavender,
    child: ClipOval(
      child: Image.asset(
        'assets/shivendra.jpg',
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Icon(
          Icons.person_rounded,
          size: radius * 1.35,
          color: AppColors.purple,
        ),
      ),
    ),
  );
}
