import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pulse_badge.dart';
import '../home_strings.dart';

/// Sapaan waktu, nama pengguna, dan jumlah gantangan yang sedang live.
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    super.key,
    required this.greeting,
    required this.name,
    required this.liveCount,
    this.avatarUrl,
  });

  final String greeting;
  final String name;
  final int liveCount;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
              ? NetworkImage(avatarUrl!)
              : const AssetImage('assets/avatar/avatar1.jpg'),
          backgroundColor: AppColors.lavenderGlow,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text(greeting, style: AppTextStyles.eyebrow)),
                ],
              ),
              Text(
                'Halo, $name ${HomeStrings.waveEmoji}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title,
              ),
            ],
          ),
        ),
        PulseBadge(
          label: '$liveCount ${HomeStrings.liveSuffix}',
          icon: Icons.sensors_rounded,
        ),
      ],
    );
  }
}
