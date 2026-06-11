import 'package:flutter/material.dart';

/// A short stack of overlapping avatars plus a count label, e.g. "48 going".
class AttendeeAvatars extends StatelessWidget {
  final int count;
  final double size;
  final String label;

  const AttendeeAvatars({
    super.key,
    required this.count,
    this.size = 22,
    this.label = 'going',
  });

  static const _colors = [
    Color(0xFFF5A623),
    Color(0xFF8C7CF6),
    Color(0xFF36C2CE),
  ];
  static const _initials = ['A', 'D', 'J'];

  @override
  Widget build(BuildContext context) {
    final avatarCount = count.clamp(0, 3);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (avatarCount > 0)
          SizedBox(
            width: size * 0.6 * (avatarCount - 1) + size,
            height: size,
            child: Stack(
              children: List.generate(avatarCount, (i) {
                return Positioned(
                  left: i * size * 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).cardColor,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: size / 2,
                      backgroundColor: _colors[i % _colors.length],
                      child: Text(
                        _initials[i % _initials.length],
                        style: TextStyle(
                          fontSize: size * 0.42,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        if (avatarCount > 0) const SizedBox(width: 8),
        Text(
          '$count $label',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
