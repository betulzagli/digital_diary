import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;
  final double borderRadius;
  final bool showShadow;

  const AppLogoWidget({
    super.key,
    this.size = 36,
    this.borderRadius = 10,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Yedek ikon (Varlık yüklenemezse)
            return Container(
              color: const Color(0xFF6C5CE7),
              child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 20),
            );
          },
        ),
      ),
    );
  }
}
