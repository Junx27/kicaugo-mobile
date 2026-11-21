import 'package:flutter/material.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/glass_icon_button.dart';
import '../../../../core/widgets/thick_plus_icon.dart';
import '../community_strings.dart';

/// Tombol mengambang untuk membuat postingan (belum tersedia).
class CreatePostFab extends StatelessWidget {
  const CreatePostFab({super.key});

  @override
  Widget build(BuildContext context) => GlassIconButton(
    buttonKey: const Key('community_create_post'),
    icon: const ThickPlusIcon(),
    tooltip: CommunityStrings.createPost,
    onPressed: () => showComingSoon(context),
  );
}
