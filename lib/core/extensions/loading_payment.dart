// lib/core/extensions/loading_indicator.dart
import 'package:flutter/material.dart';

class LoadingPayment {
  // A static OverlayEntry to keep track of the overlay
  static OverlayEntry? _overlayEntry;
  // A static boolean to track if the indicator is currently showing
  static bool _isShowing = false;

  /// Getter to check if the loading indicator is currently displayed.
  static bool get isShowing => _isShowing;

  /// Shows a loading indicator overlay on top of the current screen.
  static void show(BuildContext context) {
    if (_isShowing) return; // Prevent showing multiple overlays

    _isShowing = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Semi-transparent barrier to block interaction
          ModalBarrier(
            color: Colors.black.withOpacity(0.3),
            dismissible: false,
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    // Insert the overlay into the OverlayState
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hides the currently displayed loading indicator overlay.
  static void hide(BuildContext context) {
    if (!_isShowing) return; // Do nothing if not showing

    _isShowing = false;
    _overlayEntry?.remove(); // Remove the overlay from the tree
    _overlayEntry = null; // Clear the entry
  }
}