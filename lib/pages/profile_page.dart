import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/EditProfilePage.dart';
import 'package:my_app/pages/NotificationPage.dart';
import '/services/auth_services.dart';
import 'security_page.dart';
import 'page/IntroductionPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {
  final auth = AuthService();
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 🔹 Lấy dữ liệu người dùng từ Firestore (theo tài khoản hiện tại)
  Future<void> _loadUserData() async {
    try {
      final user =
          FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception(
          'Không tìm thấy người dùng đang đăng nhập.',
        );
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      } else {
        // Nếu chưa có dữ liệu, khởi tạo tạm
        setState(() {
          userData = {
            'name': 'Chưa có tên',
            'email': user.email,
            'phone': '',
            'address': '',
          };
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải hồ sơ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔹 Mở trang chỉnh sửa hồ sơ
  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EditProfilePage(), // Không cần truyền email nữa
      ),
    );

    if (result == true) {
      _loadUserData(); // Reload lại thông tin sau khi chỉnh sửa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar Section
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[100],
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData?['name'] ??
                        'Người dùng',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    userData?['email'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Nhiệm vụ',
                          '24',
                          Icons.task_alt,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Dự án',
                          '8',
                          Icons.folder,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Ngày',
                          '127',
                          Icons.calendar_today,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Menu Items
                  _buildMenuCard(
                    title: 'Chỉnh sửa hồ sơ',
                    icon: Icons.edit,
                    color: Colors.blue,
                    onTap: _navigateToEditProfile,
                  ),
                  _buildMenuCard(
                    title: 'Cài đặt thông báo',
                    icon: Icons.notifications,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificationPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'Bảo mật',
                    icon: Icons.security,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SecurityPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'Trợ giúp & Hỗ trợ',
                    icon: Icons.help,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  _buildMenuCard(
                    title: 'Giới thiệu nhóm',
                    icon: Icons.info,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const IntroductionPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'Đăng xuất',
                    icon: Icons.logout,
                    color: Colors.red,
                    onTap: () => auth.signOut(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
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
            color: Colors.grey[800],
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
