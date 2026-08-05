import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as gis_web;

/// Web implementation: the standard GIS sign-in button. Pressing it and
/// granting consent fires `GoogleSignIn.onCurrentUserChanged` with a populated
/// idToken (the reliable web path).
Widget renderGoogleButton() => gis_web.renderButton();
