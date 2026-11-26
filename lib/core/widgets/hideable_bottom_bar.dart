import 'package:flutter/material.dart';

/// Bottom bar mengambang yang turun saat pengguna scroll ke bawah dan muncul
/// kembali saat scroll ke atas. Dipakai bersama halaman detail dan pemesanan.
class HideableBottomBar extends StatefulWidget {
  const HideableBottomBar({
    super.key,
    required this.controller,
    required this.child,
  });

  /// Controller milik scroll view yang memantau arah gulir.
  final ScrollController controller;

  /// Isi pill bawah, misalnya harga dan tombol aksi.
  final Widget child;

  @override
  State<HideableBottomBar> createState() => _HideableBottomBarState();
}

class _HideableBottomBarState extends State<HideableBottomBar> {
  static const double _directionThreshold = 12;
  static const double _minOffsetToHide = 40;
  static const Duration _duration = Duration(milliseconds: 260);

  bool _visible = true;
  double _lastOffset = 0;
  double _accumulator = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant HideableBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    oldWidget.controller.removeListener(_handleScroll);
    widget.controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (!widget.controller.hasClients) return;
    final offset = widget.controller.offset;
    final delta = offset - _lastOffset;
    _lastOffset = offset;

    if (offset <= 0) {
      _accumulator = 0;
      _setVisible(true);
      return;
    }

    if ((delta > 0 && _accumulator < 0) || (delta < 0 && _accumulator > 0)) {
      _accumulator = 0;
    }
    _accumulator += delta;

    if (_accumulator > _directionThreshold && offset > _minOffsetToHide) {
      _accumulator = 0;
      _setVisible(false);
    } else if (_accumulator < -_directionThreshold) {
      _accumulator = 0;
      _setVisible(true);
    }
  }

  void _setVisible(bool visible) {
    if (_visible == visible) return;
    setState(() => _visible = visible);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        ignoring: !_visible,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, 1.05),
          duration: _duration,
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: _duration,
            curve: Curves.easeOut,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
