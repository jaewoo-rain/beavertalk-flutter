import 'package:flutter/material.dart';

/// Non-web fallback for the GIS render button. The Google web flow is only
/// wired on web, so off-web this renders nothing (callers gate on [kIsWeb]).
Widget renderGoogleButton() => const SizedBox.shrink();
