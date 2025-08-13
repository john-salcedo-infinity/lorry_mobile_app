import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';

// Widget optimizado para el FloatingActionButton
class ScrollToTopFab extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToTopFab({
    super.key,
    required this.scrollController,
  });

  @override
  State<ScrollToTopFab> createState() => _ScrollToTopFabState();
}

class _ScrollToTopFabState extends State<ScrollToTopFab> {
  bool _showFab = false;
  Timer? _scrollThrottle;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollThrottle?.cancel();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    // Throttle más agresivo para el FAB
    if (_scrollThrottle?.isActive ?? false) return;

    _scrollThrottle = Timer(const Duration(milliseconds: 200), () {
      if (!widget.scrollController.hasClients) return;

      final currentOffset = widget.scrollController.offset;
      final shouldShow = currentOffset > 600;

      // Solo actualizar estado si realmente cambió
      if (shouldShow != _showFab) {
        if (mounted) {
          setState(() => _showFab = shouldShow);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _showFab ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: FloatingActionButton(
        mini: false,
        shape: CircleBorder(
          side: BorderSide(color: Apptheme.textColorPrimary, width: 2),
        ),
        backgroundColor: Colors.white,
        onPressed: _showFab
            ? () {
                widget.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              }
            : null,
        elevation: 0,
        child: Container(
          margin: EdgeInsets.only(top: 4),
          child: const Icon(
            Icons.keyboard_control_key_sharp,
            color: Apptheme.textColorPrimary,
            size: 30,
          ),
        ),
      ),
    );
  }
}
