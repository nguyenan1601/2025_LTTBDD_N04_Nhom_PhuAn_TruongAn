import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  // Dữ liệu và Controller (Giá trị mặc định)
  final TextEditingController _nameController =
      TextEditingController(
        text: 'Nguyễn Thế Trường An',
      );
  final TextEditingController _emailController =
      TextEditingController(
        text: 'an3082004mal@gmail.com',
      );
  final TextEditingController _phoneController =
      TextEditingController(text: '0987654321');
  final TextEditingController _addressController =
      TextEditingController(
        text: 'Đỗ Đức Dục, Nam Từ Liêm, Hà Nội',
      );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Hàm xử lý Lưu
  void _saveProfile() {
    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã lưu thông tin hồ sơ thành công!',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Đóng thẻ sửa quay về profile
    Navigator.of(context).pop();
  }

  // Hàm ấn nút hủy và quay lại
  void _cancelEdit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Chỉnh sửa Hồ sơ'),
        backgroundColor: Colors.white,
        elevation: 1,
        // Nút Quay về ở góc trên bên trái
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              _cancelEdit, // Dùng _cancelEdit để quay lại
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Sửa tên
            _buildCustomTextField(
              controller: _nameController,
              label: 'Tên người dùng',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            // Sửa email
            _buildCustomTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType:
                  TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Sửa số điện thoại
            _buildCustomTextField(
              controller: _phoneController,
              label: 'Số điện thoại',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Sửa địa chỉ
            _buildCustomTextField(
              controller: _addressController,
              label: 'Địa chỉ',
              icon: Icons.location_on_outlined,
              maxLines: 1,
            ),

            const SizedBox(height: 48),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lưu thay đổi',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tùy chỉnh cho TextField
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.blue,
        ),
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
