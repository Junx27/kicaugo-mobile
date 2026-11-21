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
  });

  final String greeting;
  final String name;
  final int liveCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting.toUpperCase(), style: AppTextStyles.eyebrow),
              Text(
                'Halo, $name ${HomeStrings.waveEmoji}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),
        ),
        PulseBadge(
          label: '$liveCount ${HomeStrings.liveSuffix}',
          backgroundColor: AppColors.lavenderGlow,
          accentColor: AppColors.onLime,
        ),
      ],
    );
  }
}
