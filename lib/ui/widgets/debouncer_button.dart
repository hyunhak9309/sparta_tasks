import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class DebouncerButton extends StatelessWidget {
  const DebouncerButton({super.key, required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TapDebouncer(
      builder: (context, debouncer) => InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}