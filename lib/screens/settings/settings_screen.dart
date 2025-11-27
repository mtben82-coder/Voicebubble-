import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'terms_screen.dart';
import 'privacy_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F5F7);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final primaryColor = isDark ? const Color(0xFFA855F7) : const Color(0xFF9333EA);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: textColor, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // Settings Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Account Section
                  _buildSectionHeader('ACCOUNT', secondaryTextColor),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildAccountItem(
                          context,
                          textColor,
                          secondaryTextColor,
                          primaryColor,
                        ),
                        Divider(height: 1, color: dividerColor),
                        _buildUpgradeItem(context, primaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Preferences Section
                  _buildSectionHeader('PREFERENCES', secondaryTextColor),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildLanguageItem(
                          context,
                          textColor,
                          secondaryTextColor,
                        ),
                        Divider(height: 1, color: dividerColor),
                        _buildThemeToggle(
                          context,
                          textColor,
                          primaryColor,
                        ),
                        Divider(height: 1, color: dividerColor),
                        _buildNotificationsItem(
                          context,
                          textColor,
                          secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Overlay Settings Section
                  _buildSectionHeader('OVERLAY', secondaryTextColor),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildOverlayToggle(
                          context,
                          textColor,
                          primaryColor,
                        ),
                        Divider(height: 1, color: dividerColor),
                        _buildOverlayPositionItem(
                          context,
                          textColor,
                          secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Voice & Audio Section
                  _buildSectionHeader('VOICE & AUDIO', secondaryTextColor),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildVoiceLanguageItem(
                          context,
                          textColor,
                          secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // About Section
                  _buildSectionHeader('ABOUT', secondaryTextColor),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(height: 1, color: dividerColor),
                        _buildSettingsItem(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(height: 1, color: dividerColor),
                        _buildSettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(height: 1, color: dividerColor),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Version',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '1.0.0',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Advanced Section
                  _buildSectionHeader('ADVANCED', secondaryTextColor),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.cleaning_services_outlined,
                          title: 'Clear Cache',
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          onTap: () {
                            _showClearCacheDialog(context);
                          },
                        ),
                        Divider(height: 1, color: dividerColor),
                        _buildSettingsItem(
                          icon: Icons.restore,
                          title: 'Reset Settings',
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          onTap: () {
                            _showResetDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Danger Zone
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showSignOutDialog(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFFEF4444),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }
  
  Widget _buildAccountItem(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              gradient: LinearGradient(
                colors: [primaryColor, const Color(0xFFEC4899)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                'U',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free Plan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  '20 recordings/day',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: secondaryTextColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildUpgradeItem(BuildContext context, Color primaryColor) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upgrade to Pro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.bolt,
              color: primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageItem(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return _buildSettingsItem(
      icon: Icons.language,
      title: 'Language',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'English',
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: secondaryTextColor,
          ),
        ],
      ),
      textColor: textColor,
      secondaryTextColor: secondaryTextColor,
      onTap: () {},
    );
  }
  
  Widget _buildThemeToggle(
    BuildContext context,
    Color textColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.dark_mode_outlined,
                size: 20,
                color: textColor,
              ),
              const SizedBox(width: 12),
              Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeColor: primaryColor,
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationsItem(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return _buildSettingsItem(
      icon: Icons.notifications_outlined,
      title: 'Notifications',
      textColor: textColor,
      secondaryTextColor: secondaryTextColor,
      onTap: () {},
    );
  }
  
  Widget _buildOverlayToggle(
    BuildContext context,
    Color textColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 20,
                color: textColor,
              ),
              const SizedBox(width: 12),
              Text(
                'Show Overlay',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
          Switch(
            value: true,
            onChanged: (value) {},
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverlayPositionItem(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Overlay Position',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          Row(
            children: [
              Text(
                'Right',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: secondaryTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildVoiceLanguageItem(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return _buildSettingsItem(
      icon: Icons.mic_none,
      title: 'Voice Language',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'English (US)',
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: secondaryTextColor,
          ),
        ],
      ),
      textColor: textColor,
      secondaryTextColor: secondaryTextColor,
      onTap: () {},
    );
  }
  
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required Color textColor,
    required Color secondaryTextColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: textColor,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: secondaryTextColor,
                ),
          ],
        ),
      ),
    );
  }
  
  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
  
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to default?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
  
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

