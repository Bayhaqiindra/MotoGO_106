import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const FeatureButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
