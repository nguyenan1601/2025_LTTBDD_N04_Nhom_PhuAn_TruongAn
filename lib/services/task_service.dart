import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy tất cả tasks của user
  Stream<List<Task>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data()))
            .toList());
  }

  // Thêm task mới
  Future<void> addTask(String userId, Task task) async {
    final taskData = task.toMap();
    taskData['userId'] = userId; // Thêm userId vào task
    
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .set(taskData);
  }

  // Cập nhật task
  Future<void> updateTask(String userId, Task task) async {
    final taskData = task.toMap();
    taskData['userId'] = userId;
    
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .update(taskData);
  }

  // Xóa task
  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // Đánh dấu task hoàn thành
  Future<void> completeTask(String userId, String taskId) async {
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .update({
      'status': TaskStatus.completed.index,
      'completedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Cập nhật trạng thái task
  Future<void> updateTaskStatus(String userId, String taskId, TaskStatus status) async {
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .update({
      'status': status.index,
      'completedAt': status == TaskStatus.completed 
          ? DateTime.now().millisecondsSinceEpoch 
          : null,
    });
  }

  // Lấy tasks theo trạng thái
  Stream<List<Task>> getTasksByStatus(String userId, TaskStatus status) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status.index)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data()))
            .toList());
  }

  // Lấy tasks sắp đến hạn (trong 3 ngày tới)
  Stream<List<Task>> getUpcomingTasks(String userId) {
    final now = DateTime.now();
    final threeDaysLater = now.add(const Duration(days: 3));
    
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('dueDate', isGreaterThanOrEqualTo: now.millisecondsSinceEpoch)
        .where('dueDate', isLessThanOrEqualTo: threeDaysLater.millisecondsSinceEpoch)
        .where('status', whereIn: [TaskStatus.pending.index, TaskStatus.inProgress.index])
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data()))
            .toList());
  }

  // Lấy số lượng tasks theo trạng thái
  Stream<Map<TaskStatus, int>> getTaskCounts(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
          return {
            TaskStatus.pending: tasks.where((t) => t.status == TaskStatus.pending).length,
            TaskStatus.inProgress: tasks.where((t) => t.status == TaskStatus.inProgress).length,
            TaskStatus.completed: tasks.where((t) => t.status == TaskStatus.completed).length,
            TaskStatus.cancelled: tasks.where((t) => t.status == TaskStatus.cancelled).length,
          };
        });
  }
}