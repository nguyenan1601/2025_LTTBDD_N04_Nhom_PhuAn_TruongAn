import 'package:flutter/material.dart';
import 'page/ChangePasswordPage.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Bảo mật'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            //Đổi mật khẩu
            _buildMenuCard(
              context: context,
              title: 'Đổi mật khẩu',
              icon: Icons.lock_outline,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangePasswordPage(),
                  ),
                );
              },
            ),

            //Xác thực
            _buildMenuCard(
              context: context,
              title: 'Xác thực hai yếu tố (2FA)',
              icon: Icons.shield_outlined,
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Mở cài đặt 2FA',
                    ),
                  ),
                );
              },
            ),

            //Thiết bị đã đăng nhập
            _buildMenuCard(
              context: context,
              title: 'Thiết bị đã đăng nhập',
              icon: Icons.devices_other_outlined,
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Xem lịch sử đăng nhập',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 24,
            ), // Thêm khoảng cách
            //Xóa tài khoản
            _buildMenuCard(
              context: context,
              title: 'Xóa tài khoản',
              icon: Icons.delete_forever_outlined,
              color: Colors.red,
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Yêu cầu xóa tài khoản đã được gửi',
                    ),
                    backgroundColor: Colors
                        .red, // SnackBar màu đỏ
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //Widget giống với ProfilePage
  Widget _buildMenuCard({
    required BuildContext
    context, // Cần context để hiển thị SnackBar
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
            // Đổi màu chữ nếu là nút Xóa
            color: (color == Colors.red)
                ? Colors.red
                : Colors.grey[800],
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
