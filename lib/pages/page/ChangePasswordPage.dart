import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController
  _oldPasswordController =
      TextEditingController();
  final TextEditingController
  _newPasswordController =
      TextEditingController();
  final TextEditingController
  _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            // Container cho các trường nhập liệu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
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
                  //Mật khẩu cũ
                  _buildCustomTextField(
                    controller:
                        _oldPasswordController,
                    label: 'Mật khẩu cũ',
                    icon: Icons.lock_outline,
                    isPassword: true, //ẨN VĂN BẢN
                  ),
                  const SizedBox(height: 16),

                  //Mật khẩu mới
                  _buildCustomTextField(
                    controller:
                        _newPasswordController,
                    label: 'Mật khẩu mới',
                    icon: Icons.lock_open,
                    isPassword: true, //ẨN VĂN BẢN
                  ),
                  const SizedBox(height: 16),

                  //Mật khẩu xác nhận
                  _buildCustomTextField(
                    controller:
                        _confirmPasswordController,
                    label:
                        'Xác nhận mật khẩu mới',
                    icon: Icons
                        .check_circle_outline,
                    isPassword: true, //ẨN VĂN BẢN
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Nút Lưu thay đổi
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Đang xử lý đổi mật khẩu...',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lưu thay đổi',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //widget như Edit
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
    bool isPassword = false, // Thuộc tính mới
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      // Áp dụng thuộc tính ẩn văn bản
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.blue,
        ),
        // Thêm icon hiển thị/ẩn mật khẩu cho trường mật khẩu
        suffixIcon: isPassword
            ? const Icon(
                Icons.visibility_off,
                color: Colors.grey,
              )
            : null,

        contentPadding:
            const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
        fillColor: Colors.white,
        filled: true,
        // Border đồng bộ
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}
