import 'package:flutter/material.dart';

/// FAB mengambang yang mengikuti arah scroll: hilang saat scroll menuju bawah,
/// muncul kembali saat scroll menuju atas.
///
/// [bottomGap] diukur dari `MediaQuery.padding.bottom`. Pada `Scaffold` dengan
/// `extendBody: true`, nilai padding tersebut sudah mencakup tinggi navbar,
/// sehingga tinggi navbar tidak boleh dijumlahkan lagi.
class ScrollAwareFab extends StatefulWidget {
  const ScrollAwareFab({
    super.key,
    required this.scrollable,
    required this.fab,
    this.bottomGap = 12,
    this.right = 16,
  });

  /// Konten yang bisa scroll dan memancarkan [ScrollUpdateNotification].
  final Widget scrollable;

  /// Tombol mengambang di pojok kanan bawah.
  final Widget fab;

  final double bottomGap;
  final double right;

  @override
  State<ScrollAwareFab> createState() => _ScrollAwareFabState();
}

class _ScrollAwareFabState extends State<ScrollAwareFab> {
  static const Duration _fadeDuration = Duration(milliseconds: 200);

  /// Awalnya terlihat; scroll menuju bawah menyembunyikan dan ke atas
  /// menampilkan kembali tombol.
  bool _visible = true;

  bool _onScroll(ScrollUpdateNotification notification) {
    final delta = notification.scrollDelta;
    if (delta == null || delta == 0) return false;
    final shouldShow = delta < 0;
    if (shouldShow != _visible) {
      setState(() => _visible = shouldShow);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollUpdateNotification>(
          onNotification: _onScroll,
          child: widget.scrollable,
        ),
        Positioned(
          right: widget.right,
          bottom: MediaQuery.paddingOf(context).bottom + widget.bottomGap,
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: _fadeDuration,
            child: IgnorePointer(ignoring: !_visible, child: widget.fab),
          ),
        ),
      ],
    );
  }
}
