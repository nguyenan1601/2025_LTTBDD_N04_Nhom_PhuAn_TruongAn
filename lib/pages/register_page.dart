import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTapLogin;
  const RegisterPage({
    super.key,
    required this.onTapLogin,
  });

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController =
      TextEditingController();
  final confirmPasswordController =
      TextEditingController();
  final auth = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng điền đầy đủ thông tin!',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Mật khẩu xác nhận không khớp!',
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Mật khẩu phải có ít nhất 6 ký tự!',
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = await auth.signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Đăng ký thành công!',
          ),
          backgroundColor: Colors.green[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Đăng ký thất bại! Email có thể đã được sử dụng.',
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  onPressed: widget.onTapLogin,
                  icon: Container(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(
                            0,
                            2,
                          ),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[700],
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Header
                Text(
                  'Tạo tài khoản\nmới',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đăng ký để bắt đầu quản lý nhiệm vụ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 40),

                // Register Form
                Container(
                  padding: const EdgeInsets.all(
                    24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                        child: TextField(
                          controller:
                              emailController,
                          keyboardType:
                              TextInputType
                                  .emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors
                                  .grey[600],
                            ),
                            prefixIcon: Icon(
                              Icons
                                  .email_outlined,
                              color: Colors
                                  .grey[500],
                            ),
                            border:
                                InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Colors.grey[800],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                        child: TextField(
                          controller:
                              passwordController,
                          obscureText:
                              _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            labelStyle: TextStyle(
                              color: Colors
                                  .grey[600],
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors
                                  .grey[500],
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword =
                                      !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons
                                          .visibility_outlined
                                    : Icons
                                          .visibility_off_outlined,
                                color: Colors
                                    .grey[500],
                              ),
                            ),
                            border:
                                InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Colors.grey[800],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Confirm Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                        child: TextField(
                          controller:
                              confirmPasswordController,
                          obscureText:
                              _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText:
                                'Xác nhận mật khẩu',
                            labelStyle: TextStyle(
                              color: Colors
                                  .grey[600],
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors
                                  .grey[500],
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons
                                          .visibility_outlined
                                    : Icons
                                          .visibility_off_outlined,
                                color: Colors
                                    .grey[500],
                              ),
                            ),
                            border:
                                InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Colors.grey[800],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Password requirements
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                        child: Text(
                          'Mật khẩu phải có ít nhất 6 ký tự',
                          style: TextStyle(
                            color:
                                Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green,
                            foregroundColor:
                                Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                    valueColor:
                                        AlwaysStoppedAnimation<
                                          Color
                                        >(
                                          Colors
                                              .white,
                                        ),
                                  ),
                                )
                              : Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors
                                  .grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                            child: Text(
                              'hoặc',
                              style: TextStyle(
                                color: Colors
                                    .grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors
                                  .grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed:
                              widget.onTapLogin,
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                Colors.blue,
                            side: BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                          ),
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Footer
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Bằng việc đăng ký, bạn đồng ý với',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          // Hiển thị điều khoản sử dụng
                        },
                        child: Text(
                          'Điều khoản sử dụng & Chính sách bảo mật',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
