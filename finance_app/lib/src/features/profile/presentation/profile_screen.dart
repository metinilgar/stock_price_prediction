import 'package:finance_app/src/features/profile/presentation/widgets/profile_header.dart';
import 'package:finance_app/src/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const ProfileHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hesap Ayarları',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ProfileSectionCard(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: 'Kişisel Bilgiler',
                        subtitle: 'Profil bilgilerinizi düzenleyin',
                        onTap: () {},
                      ),
                      Divider(
                          color: theme.colorScheme.outline.withOpacity(0.2)),
                      _ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Bildirimler',
                        subtitle: 'Bildirim tercihlerinizi yönetin',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Güvenlik',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ProfileSectionCard(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.security_outlined,
                        title: 'Güvenlik Ayarları',
                        subtitle: 'Şifre ve güvenlik seçenekleri',
                        onTap: () {},
                      ),
                      Divider(
                          color: theme.colorScheme.outline.withOpacity(0.2)),
                      _ProfileMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Gizlilik',
                        subtitle: 'Gizlilik tercihlerinizi yönetin',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ProfileSectionCard(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: 'Yardım ve Destek',
                        subtitle: 'SSS ve destek merkezi',
                        onTap: () {},
                      ),
                      Divider(
                          color: theme.colorScheme.outline.withOpacity(0.2)),
                      _ProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Çıkış Yap',
                        subtitle: 'Hesabınızdan çıkış yapın',
                        onTap: () =>
                            ref.read(authControllerProvider.notifier).signOut(),
                        textColor: theme.colorScheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileSectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? textColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: textColor?.withOpacity(0.1) ??
              theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: textColor ?? theme.colorScheme.primary),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: textColor ?? theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor?.withOpacity(0.7) ??
              theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurface.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }
}
