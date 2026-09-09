import 'branding.g.dart';

/// Shared product identity used by Flutter and native presentation surfaces.
abstract final class AppIdentity {
  static const name = GeneratedBranding.appName;
  static const tagline = GeneratedBranding.tagline;
  static const logoAsset = 'assets/branding/app_icon.png';
}
