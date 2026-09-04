import 'package:flutter/material.dart';
import '../../config/app_identity.dart';

/// Temporary code-native mark, not final trademark/app-icon artwork.
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.forum_rounded, color: colors.onPrimary, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          AppIdentity.name,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          AppIdentity.tagline,
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
