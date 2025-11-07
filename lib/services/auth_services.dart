// services/auth_services.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Stream theo dõi thay đổi user
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Đăng ký
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Tạo document user trong Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return result.user;
    } catch (e) {
      print('Lỗi đăng ký: $e');
      rethrow;
    }
  }

  // Đăng nhập
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      rethrow;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lấy danh sách tasks
  Stream<QuerySnapshot> getTasks() {
    final userId = currentUser?.uid;
    if (userId == null) {
      return const Stream.empty();
    }
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Thêm task mới
  Future<String> addTask(String title, String description, DateTime selectedDate) async {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add({
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // Cập nhật task
  Future<void> updateTask(
    String taskId, 
    String title, 
    String description, 
    bool isCompleted, DateTime selectedDate
  ) async {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Xoá task
  Future<void> deleteTask(String taskId) async {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // Toggle trạng thái task
  Future<void> toggleTaskCompletion(String taskId, bool currentStatus) async {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'isCompleted': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Lấy thống kê tasks
  Future<Map<String, int>> getTaskStats() async {
    final userId = currentUser?.uid;
    if (userId == null) return {'completed': 0, 'pending': 0, 'total': 0};

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    final total = snapshot.docs.length;
    final completed = snapshot.docs.where((doc) => doc['isCompleted'] == true).length;
    final pending = total - completed;

    return {
      'completed': completed,
      'pending': pending,
      'total': total,
    };
  }

  // Đổi mật khẩu
  Future<void> changePassword(String newPassword) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception('User not logged in');
    }
  }

  // Gửi email reset mật khẩu
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Xoá tài khoản
  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user != null) {
      // Xoá tất cả tasks của user
      final tasksSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .get();

      final batch = _firestore.batch();
      for (final doc in tasksSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Xoá user document
      batch.delete(_firestore.collection('users').doc(user.uid));
      await batch.commit();

      // Xoá tài khoản authentication
      await user.delete();
    } else {
      throw Exception('User not logged in');
    }
  }

  // Kiểm tra xem user đã đăng nhập chưa
  bool get isLoggedIn => currentUser != null;

  // Lấy email của user hiện tại
  String? get userEmail => currentUser?.email;

  // Lấy UID của user hiện tại
  String? get userId => currentUser?.uid;
}