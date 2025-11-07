import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Thông báo & Hoạt động',
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // CONTAINER LỚN BAO BỌC TOÀN BỘ NỘI DUNG
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              12,
            ), // Bo góc đồng bộ
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(
                  0.05,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              //Thông báo 1
              _buildStaticNotificationItem(
                title: 'Hoàn thành nhiệm vụ',
                subtitle:
                    'Đã hoàn thành Task: "Thiết kế UI cho trang chủ"',
                time: '3 phút trước',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),

              //Thông báo 2
              _buildStaticNotificationItem(
                title: 'Đã chỉnh sửa hồ sơ',
                subtitle:
                    'Hồ sơ cá nhân đã được cập nhật thành công.',
                time: 'Hôm nay, 10:30 AM',
                icon: Icons.edit_note,
                color: Colors.blue,
              ),

              //Thông báo 3
              _buildStaticNotificationItem(
                title: 'Cập nhật Dự án',
                subtitle:
                    'Dự án "Ứng dụng di động" đã được thêm 2 nhiệm vụ mới.',
                time: 'Hôm qua, 4:15 PM',
                icon: Icons.folder_open,
                color: Colors.orange,
              ),

              //Thông báo 4
              _buildStaticNotificationItem(
                title: 'Cảnh báo Bảo mật',
                subtitle:
                    'Phát hiện đăng nhập từ thiết bị lạ.',
                time: '28/10/2025',
                icon: Icons.security,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      // Thêm padding dọc lớn hơn để tách các mục
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // Icon bên trái
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Thời gian bên phải
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
