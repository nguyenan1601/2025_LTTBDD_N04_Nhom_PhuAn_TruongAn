import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  // final String userEmail; // Truyền email (hoặc uid)

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  // Controller
  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController();
  final TextEditingController _addressController =
      TextEditingController();

  bool _isLoading =
      true; // Hiển thị khi đang tải dữ liệu

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Gọi khi mở trang
  }

  // 🔹 Lấy dữ liệu người dùng từ Firestore
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
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _emailController.text =
            data['email'] ?? user.email!;
        _phoneController.text =
            data['phone'] ?? '';
        _addressController.text =
            data['address'] ?? '';
      } else {
        _emailController.text = user.email!;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi khi tải dữ liệu: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user =
          FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception(
          'Không tìm thấy người dùng đang đăng nhập.',
        );
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .set({
            'name': _nameController.text,
            'email': user.email,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'updatedAt':
                FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '✅ Đã lưu thông tin hồ sơ thành công!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ Lỗi khi lưu dữ liệu: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔹 Hủy chỉnh sửa
  void _cancelEdit() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _cancelEdit,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildCustomTextField(
                    controller: _nameController,
                    label: 'Tên người dùng',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),

                  _buildCustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType
                        .emailAddress,
                    enabled:
                        false, // Không cho sửa email
                  ),
                  const SizedBox(height: 20),

                  _buildCustomTextField(
                    controller: _phoneController,
                    label: 'Số điện thoại',
                    icon: Icons.phone_outlined,
                    keyboardType:
                        TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  _buildCustomTextField(
                    controller:
                        _addressController,
                    label: 'Địa chỉ',
                    icon: Icons
                        .location_on_outlined,
                  ),
                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                        ),
                      ),
                      child: const Text(
                        'Lưu thay đổi',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // 🔹 Widget tùy chỉnh TextField
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.blue,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
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
