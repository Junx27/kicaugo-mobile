import 'package:flutter/material.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/glass_icon_button.dart';
import '../../../../core/widgets/thick_plus_icon.dart';
import '../chat_strings.dart';

/// Tombol tulis pesan baru (belum tersedia).
class ChatComposeButton extends StatelessWidget {
  const ChatComposeButton({super.key});

  @override
  Widget build(BuildContext context) => GlassIconButton(
    buttonKey: const Key('chat_compose'),
    icon: const ThickPlusIcon(),
    tooltip: ChatStrings.composeTooltip,
    onPressed: () => showComingSoon(context),
  );
}
