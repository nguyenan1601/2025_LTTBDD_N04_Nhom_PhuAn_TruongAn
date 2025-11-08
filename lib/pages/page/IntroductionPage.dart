import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Thành viên nhóm'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                bottom: 16,
              ),
              child: Text(
                'Nhóm phát triển To-Do List',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            //CONTAINER LỚN BAO BỌC HAI THÀNH VIÊN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  //THÀNH VIÊN 1
                  Expanded(
                    child: _buildMemberCard(
                      name: 'Nguyễn Phú An',
                      role: 'Leader & Backend',
                      studentId: '22010196',
                      // THÔNG TIN CỤ THỂ
                      school: 'Đại học Phenikaa',
                      faculty:
                          'Khoa Công nghệ thông tin',
                      major:
                          'Công nghệ thông tin',
                      className: 'CNTT3',
                      email:
                          '22010196@st.phenikaa-edu.vn',
                      dob: '15/03/2004',
                      imagePath: 'images/he.jpg',
                      isLeft: true,
                    ),
                  ),

                  // Đường phân cách dọc
                  VerticalDivider(
                    width: 30,
                    thickness: 1,
                    color: const Color.fromARGB(
                      255,
                      96,
                      38,
                      38,
                    ),
                    indent: 10,
                    endIndent: 10,
                  ),

                  //THÀNH VIÊN 2
                  Expanded(
                    child: _buildMemberCard(
                      name:
                          'Nguyễn Thế Trường An',
                      role: 'Frontend',
                      studentId: '22010253',
                      // THÔNG TIN CỤ THỂ
                      school: 'Đại học Phenikaa',
                      faculty:
                          'Khoa Công nghệ thông tin',
                      major:
                          'Công nghệ thông tin',
                      className: 'CNTT3',
                      // HẾT THÔNG TIN CỤ THỂ
                      email:
                          '22010253@st.phenikaa-edu.vn',
                      dob: '30/08/2004',
                      imagePath: 'images/he.jpg',
                      isLeft: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget thành viên nhóm
  Widget _buildMemberCard({
    required String name,
    required String role,
    required String studentId,
    required String school,
    required String faculty,
    required String major,
    required String className,
    required String email,
    required String dob,
    required String imagePath,
    required bool isLeft,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        // ẢNH AVATAR (Placeholder)
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit
                  .cover, // Đảm bảo ảnh che phủ hết khung tròn
            ),
          ),
        ),
        const SizedBox(height: 10),

        // TÊN & VAI TRÒ
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        Text(
          role,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 15),

        // PHẦN THÔNG TIN CHI TIẾT
        _buildInfoRow(
          Icons.account_balance,
          "Trường",
          school,
        ),
        _buildInfoRow(
          Icons.book,
          "Khoa",
          faculty,
        ),
        _buildInfoRow(
          Icons.school,
          "Ngành học",
          major,
        ),
        _buildInfoRow(
          Icons.class_,
          "Lớp",
          className,
        ),
        _buildInfoRow(
          Icons.credit_card,
          "MSSV",
          studentId,
        ),
        _buildInfoRow(
          Icons.calendar_today,
          "Ngày sinh",
          dob,
        ),
        _buildInfoRow(
          Icons.email,
          "Email",
          email,
          isEmail: true,
        ),

        const SizedBox(height: 15),
      ],
    );
  }

  // Widget tùy chỉnh cho từng dòng thông tin trong thẻ thành viên
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Label (Tiêu đề nhỏ)
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
                // Value (Giá trị)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: isEmail
                        ? Colors.blue
                        : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
