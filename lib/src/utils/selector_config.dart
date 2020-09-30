import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';

/// [SelectorConfig] contains selector button configurations
class SelectorConfig {
  /// [selectorType], for selector button type
  final PhoneInputSelectorType selectorType;

  /// [showFlags], displays flag along side countries info on selector button
  /// and list items within the selector
  final bool showFlags;

  /// [useEmoji], uses emoji flags instead of png assets
  final bool useEmoji;

  final Color backgroundColor;
  final Color textColor;

  const SelectorConfig({
    this.selectorType = PhoneInputSelectorType.DROPDOWN,
    this.showFlags = true,
    this.useEmoji = false,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black
  });
}
