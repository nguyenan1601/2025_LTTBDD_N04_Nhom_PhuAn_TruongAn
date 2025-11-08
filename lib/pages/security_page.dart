import 'package:flutter/material.dart';
import '/utils/localization.dart';
import 'ChangePasswordPage.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(localizations!.securityPageTitle),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Đổi mật khẩu
            _buildMenuCard(
              context: context,
              title: localizations.securityChangePassword,
              icon: Icons.lock_outline,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ),
                );
              },
            ),

            // Xác thực hai yếu tố
            _buildMenuCard(
              context: context,
              title: localizations.securityTwoFactorAuth,
              icon: Icons.shield_outlined,
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.securityTwoFactorSnackbar),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),

            // Thiết bị đã đăng nhập
            _buildMenuCard(
              context: context,
              title: localizations.securityLoggedDevices,
              icon: Icons.devices_other_outlined,
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.securityLoggedDevicesSnackbar),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            
            // Xóa tài khoản
            _buildMenuCard(
              context: context,
              title: localizations.securityDeleteAccount,
              icon: Icons.delete_forever_outlined,
              color: Colors.red,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.securityDeleteAccountSnackbar),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: (color == Colors.red) ? Colors.red : Colors.grey[800],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}