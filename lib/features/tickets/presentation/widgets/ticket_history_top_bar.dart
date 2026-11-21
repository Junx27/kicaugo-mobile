import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../ticket_history_strings.dart';

/// Bar atas halaman riwayat tiket: back + judul + aksi.
class TicketHistoryTopBar extends StatelessWidget {
  const TicketHistoryTopBar({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        spacing: 4,
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: Text(
              TicketHistoryStrings.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.title,
            ),
          ),
          IconButton(
            tooltip: 'Tambah',
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            tooltip: 'Pengaturan',
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
    );
  }
}
