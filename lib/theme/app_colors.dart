import 'package:flutter/material.dart';

/// BeaverTalk color tokens — extracted 1:1 from Figma `beavertalk_design`.
/// Dark theme with a mint-green primary (#00FFB2).
abstract final class AppColors {
  // ── Semantic ────────────────────────────────────────────────
  static const primary = Color(0xFF00FFB2); // Semantics/Primary/Normal
  static const onPrimary = Color(0xFF111111); // text on primary
  static const primary10 = Color(0x1A00FFB2); // Primary/Primary-10 (≈10%)
  static const primary24 = Color(0x3D00FFB2); // ≈24%

  static const bg = Color(0xFF121217); // screen background
  static const surface = Color(0xFF181A20); // Background/Normal/Normal
  static const surface2 = Color(0xFF252932); // Background/Normal/Alternative
  static const surfaceElevated = Color(0xFF1F222A); // Elevated/Alternative
  static const surfaceElevatedNormal = Color(0xFF2F3340); // Elevated/Normal — dialogs

  static const border = Color(0x1FFFFFFF); // Line/Normal/Neutral (12%, Figma dark)
  static const borderSubtle = Color(0x0FFFFFFF); // Line/Normal/Alternative (6%)
  static const lineStrong = Color(0xFF70737C); // Line/Normal/Normal (strong)
  static const scrim = Color(0x66222531); // Dim overlay (≈40%)

  static const text = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9EA3B2);
  static const textTertiary = Color(0xFF777C89); // Text/Tertiary
  static const textDisabled = Color(0xFF5A5C63);
  static const labelAssistive = Color(0xFF676E81); // Label/Assistive

  static const accentLime = Color(0xFF429E00); // Accent/Foreground/Lime — toggle on
  static const green700 = Color(0xFF00B57E); // Foundation/Green/green-700 — mic/record
  static const green50 = Color(0xFFE6FFF7); // Foundation/Green/green-50 — mic inner
  static const success = Color(0xFF1ED45A); // Status/Positive
  static const error = Color(0xFFFF7070); // Status/Negative
  static const warning = Color(0xFFFFA938); // Status/Warning

  // ── Cool-neutral ramp (subset used across components) ────────
  static const cool50 = Color(0xFF70737C);
  static const cool40 = Color(0xFF5A5C63);
  static const cool30 = Color(0xFF46474C);
}