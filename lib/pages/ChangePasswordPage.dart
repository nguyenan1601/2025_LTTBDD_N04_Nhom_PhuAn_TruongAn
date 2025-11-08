import 'package:flutter/material.dart';
import '/utils/localization.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState
    extends State<ChangePasswordPage> {
  final TextEditingController
  _oldPasswordController =
      TextEditingController();
  final TextEditingController
  _newPasswordController =
      TextEditingController();
  final TextEditingController
  _confirmPasswordController =
      TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(
      context,
    )!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          localizations.securityChangePassword,
        ),
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
                  // Mật khẩu cũ
                  _buildCustomTextField(
                    controller:
                        _oldPasswordController,
                    label: localizations
                        .securityOldPasswordLabel,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText:
                        _obscureOldPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureOldPassword =
                            !_obscureOldPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mật khẩu mới
                  _buildCustomTextField(
                    controller:
                        _newPasswordController,
                    label: localizations
                        .securityNewPasswordLabel,
                    icon: Icons.lock_open,
                    isPassword: true,
                    obscureText:
                        _obscureNewPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureNewPassword =
                            !_obscureNewPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mật khẩu xác nhận
                  _buildCustomTextField(
                    controller:
                        _confirmPasswordController,
                    label: localizations
                        .securityConfirmPasswordLabel,
                    icon: Icons
                        .check_circle_outline,
                    isPassword: true,
                    obscureText:
                        _obscureConfirmPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Nút Lưu thay đổi
            ElevatedButton(
              onPressed: () {
                _changePassword(context);
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
              child: Text(
                localizations.profileSaveChanges,
                style: const TextStyle(
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

  void _changePassword(BuildContext context) {
    final localizations = AppLocalizations.of(
      context,
    )!;

    // Kiểm tra các trường nhập liệu
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.fillInfoWarning,
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Kiểm tra mật khẩu mới và xác nhận mật khẩu
    if (_newPasswordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations
                .registerSnackbarPasswordMismatch,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Kiểm tra độ dài mật khẩu
    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations
                .registerSnackbarPasswordShort,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hiển thị thông báo đang xử lý
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.loadingText),
        backgroundColor: Colors.blue,
      ),
    );

    // Giả lập xử lý đổi mật khẩu
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.profileSaveSuccess,
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Xóa các trường nhập liệu sau khi thành công
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  // Widget text field tùy chỉnh
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
    bool isPassword = false,
    bool obscureText = true,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: isPassword
          ? obscureText
          : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.blue,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
        fillColor: Colors.white,
        filled: true,
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

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
