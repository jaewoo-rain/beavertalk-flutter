import 'package:flutter/material.dart';

/// Global navigator key so non-widget code (e.g. the 401 interceptor) can
/// navigate without a [BuildContext].
final GlobalKey<NavigatorState> appNavigatorKey =
    GlobalKey<NavigatorState>();
