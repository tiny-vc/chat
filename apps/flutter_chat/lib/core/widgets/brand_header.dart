import 'package:flutter/material.dart';
import '../../config/app_identity.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final logo = ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 16 : 20),
      child: Image.asset(
        AppIdentity.logoAsset,
        width: compact ? 58 : 72,
        height: compact ? 58 : 72,
        fit: BoxFit.cover,
        semanticLabel: '${AppIdentity.name}应用图标',
      ),
    );
    if (compact) {
      return Row(
        children: [
          logo,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppIdentity.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppIdentity.tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        const SizedBox(height: 18),
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
