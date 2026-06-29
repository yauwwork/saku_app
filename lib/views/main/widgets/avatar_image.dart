import 'dart:io';

import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String? avatar;
  final double size;
  final BorderRadius borderRadius;
  final Color backgroundColor;

  const AvatarImage({
    super.key,
    required this.avatar,
    required this.size,
    required this.borderRadius,
    this.backgroundColor = const Color(0xffE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    final source = avatar?.trim() ?? '';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(source),
    );
  }

  Widget _buildImage(String source) {
    if (source.isEmpty) {
      return _fallback();
    }

    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }

    final file = File(source);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Icon(Icons.person, color: Colors.grey.shade600, size: size * 0.55);
  }
}
