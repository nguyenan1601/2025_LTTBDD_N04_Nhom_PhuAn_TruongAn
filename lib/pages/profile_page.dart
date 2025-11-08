import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/EditProfilePage.dart';
import 'package:my_app/pages/NotificationPage.dart';
import '/services/auth_services.dart';
import '/utils/localization.dart';
import 'security_page.dart';
import 'IntroductionPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = AuthService();
  Map<String, dynamic>? userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load basic user data without localization
    _loadBasicUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now we can safely access inherited widgets like Localizations
    if (userData == null) {
      _loadUserDataWithLocalization();
    }
  }

  // Load basic user data without localization
  Future<void> _loadBasicUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();

        if (doc.exists) {
          setState(() {
            userData = doc.data();
          });
        } else {
          // Initialize with basic data
          setState(() {
            userData = {
              'name': 'User',
              'email': user.email,
              'phone': '',
              'address': '',
            };
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading user data: $e';
      });
    }
  }

  // Load user data with localization (safe to call after initState)
  Future<void> _loadUserDataWithLocalization() async {
    final localizations = AppLocalizations.of(context);

    if (localizations == null) {
      // Localizations not available yet, try again later
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _loadUserDataWithLocalization();
      });
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception(localizations.profileLoadingError);
      }

      // If we already have basic data, just update the default name
      if (userData != null) {
        if (userData!['name'] == 'User') {
          setState(() {
            userData!['name'] = localizations.profileDefaultUserName;
          });
        }
      } else {
        // Load fresh data
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();

        if (doc.exists) {
          setState(() {
            userData = doc.data();
          });
        } else {
          setState(() {
            userData = {
              'name': localizations.profileDefaultUserName,
              'email': user.email,
              'phone': '',
              'address': '',
            };
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${localizations.profileLoadingError}: $e';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔹 Mở trang chỉnh sửa hồ sơ
  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );

    if (result == true && mounted) {
      _loadUserDataWithLocalization();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Show error if localization is not available
    if (localizations == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Loading...',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(localizations.profilePageTitle),
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
                    userData?['name'] ?? localizations.profileDefaultUserName,
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

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          localizations.profileTasksLabel,
                          '24',
                          Icons.task_alt,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          localizations.profileProjectsLabel,
                          '8',
                          Icons.folder,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          localizations.profileDaysLabel,
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
                    title: localizations.profileEditMenu,
                    icon: Icons.edit,
                    color: Colors.blue,
                    onTap: _navigateToEditProfile,
                  ),
                  _buildMenuCard(
                    title: localizations.profileNotificationMenu,
                    icon: Icons.notifications,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: localizations.profileSecurityMenu,
                    icon: Icons.security,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecurityPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: localizations.profileHelpMenu,
                    icon: Icons.help,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  _buildMenuCard(
                    title: localizations.teamTitle,
                    icon: Icons.info,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IntroductionPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: localizations.profileLogoutMenu,
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