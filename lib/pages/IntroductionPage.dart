import 'package:flutter/material.dart';
import '/utils/localization.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(localizations.teamTitle),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                bottom: 16,
              ),
              child: Text(
                localizations.teamIntro,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            // CONTAINER LỚN BAO BỌC HAI THÀNH VIÊN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // THÀNH VIÊN 1
                  Expanded(
                    child: _buildMemberCard(
                      context: context, // Thêm context ở đây
                      name: 'Nguyễn Phú An',
                      role: localizations.roleLeaderBackend,
                      studentId: '22010196',
                      school: localizations.labelSchool,
                      faculty: localizations.labelFaculty,
                      major: localizations.labelMajor,
                      className: localizations.labelClass,
                      email: '22010196@st.phenikaa-edu.vn',
                      dob: '15/03/2004',
                      imagePath: 'lib/images/profileimg.jpg',
                      isLeft: true,
                    ),
                  ),

                  // Đường phân cách dọc
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.grey[300],
                  ),

                  // THÀNH VIÊN 2
                  Expanded(
                    child: _buildMemberCard(
                      context: context, // Thêm context ở đây
                      name: 'Nguyễn Thế Trường An',
                      role: localizations.roleFrontend,
                      studentId: '22010253',
                      school: localizations.labelSchool,
                      faculty: localizations.labelFaculty,
                      major: localizations.labelMajor,
                      className: localizations.labelClass,
                      email: '22010253@st.phenikaa-edu.vn',
                      dob: '30/08/2004',
                      imagePath: 'lib/images/profileimg.jpg',
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
    required BuildContext context, // Thêm context như một parameter
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
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ẢNH AVATAR
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
            image: const DecorationImage(
              image: AssetImage('lib/images/profileimg.jpg'),
              fit: BoxFit.cover,
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
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 15),

        // PHẦN THÔNG TIN CHI TIẾT
        _buildInfoRow(
          Icons.account_balance,
          localizations.labelSchool,
          school,
        ),
        _buildInfoRow(
          Icons.book,
          localizations.labelFaculty,
          faculty,
        ),
        _buildInfoRow(
          Icons.school,
          localizations.labelMajor,
          major,
        ),
        _buildInfoRow(
          Icons.class_,
          localizations.labelClass,
          className,
        ),
        _buildInfoRow(
          Icons.credit_card,
          localizations.labelStudentId,
          studentId,
        ),
        _buildInfoRow(
          Icons.calendar_today,
          localizations.labelDob,
          dob,
        ),
        _buildInfoRow(
          Icons.email,
          localizations.labelEmail,
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: isEmail ? Colors.blue : Colors.grey[700],
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