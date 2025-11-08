import 'package:flutter/material.dart';
import '/utils/localization.dart';

class Task {
  String title;
  bool isCompleted;

  Task({
    required this.title,
    this.isCompleted = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<Task>> _tasksByDate = {};
  final TextEditingController _taskController = TextEditingController();

  List<Task> get _todayTasks {
    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    return _tasksByDate[dateKey] ?? [];
  }

  int get _completedTasks => _todayTasks
      .where((task) => task.isCompleted)
      .length;
  int get _pendingTasks =>
      _todayTasks.length - _completedTasks;

  void _addTask(String title) {
    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    setState(() {
      _tasksByDate.putIfAbsent(dateKey, () => []);
      _tasksByDate[dateKey]!.add(
        Task(title: title),
      );
    });
    _taskController.clear();

    // Hiệu ứng haptic feedback
    _showSuccessMessage(
      AppLocalizations.of(context)!.addSuccess,
    );
  }

  void _deleteTask(int index) {
    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    setState(() {
      _tasksByDate[dateKey]!.removeAt(index);
    });
    _showSuccessMessage(AppLocalizations.of(context)!.deleteSuccess);
  }

  void _toggleComplete(int index) {
    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    setState(() {
      _tasksByDate[dateKey]![index].isCompleted =
          !_tasksByDate[dateKey]![index].isCompleted;
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    final days = [
      localizations.statisticsDaysSun,
      localizations.statisticsDaysMon,
      localizations.statisticsDaysTue,
      localizations.statisticsDaysWed,
      localizations.statisticsDaysThu,
      localizations.statisticsDaysFri,
      localizations.statisticsDaysSat,
    ];
    final dayOfWeek = days[date.weekday % 7];
    
    // Lấy danh sách tháng từ localization
    final monthNames = localizations.getMonthNames();
    final monthName = monthNames[date.month - 1];
    
    return '$dayOfWeek, ${date.day} $monthName, ${date.year}';
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeColor = Colors.blue;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatDate(_selectedDate),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: IconButton(
              icon: Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey[700],
                size: 20,
              ),
              onPressed: _pickDate,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    localizations.statusCompleted,
                    _completedTasks.toString(),
                    Colors.green,
                    Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    localizations.statusPending,
                    _pendingTasks.toString(),
                    Colors.orange,
                    Icons.access_time,
                  ),
                ),
              ],
            ),
          ),

          // Tasks List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _todayTasks.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.noTasksTitle,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.noTasksSubtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: _todayTasks.length,
                      itemBuilder: (context, index) {
                        final task = _todayTasks[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Dismissible(
                            key: Key('$index-${task.title}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade400,
                                size: 24,
                              ),
                            ),
                            onDismissed: (direction) => _deleteTask(index),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: GestureDetector(
                                onTap: () => _toggleComplete(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: task.isCompleted
                                        ? themeColor
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                    border: task.isCompleted
                                        ? null
                                        : Border.all(
                                            color: Colors.grey[300]!,
                                            width: 2,
                                          ),
                                  ),
                                  child: task.isCompleted
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : null,
                                ),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: task.isCompleted
                                      ? Colors.grey[500]
                                      : Colors.grey[800],
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                onPressed: () {
                                  _showTaskOptions(context, index);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Add Task Input
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: localizations.taskHint,
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 4,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _addTask(value.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_taskController.text.trim().isNotEmpty) {
                        _addTask(_taskController.text.trim());
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 22,
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskOptions(BuildContext context, int index) {
    final localizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                  color: Colors.blue[600],
                ),
                title: Text(
                  localizations.taskOptionsEdit,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditTaskDialog(index);
                },
              ),
              ListTile(
                leading: Icon(
                  _todayTasks[index].isCompleted
                      ? Icons.radio_button_unchecked
                      : Icons.check_circle_outline,
                  color: Colors.orange[600],
                ),
                title: Text(
                  _todayTasks[index].isCompleted
                      ? localizations.taskOptionsMarkIncomplete
                      : localizations.taskOptionsMarkComplete,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _toggleComplete(index);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                ),
                title: Text(
                  localizations.taskOptionsDelete,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditTaskDialog(int index) {
    final localizations = AppLocalizations.of(context)!;
    final task = _todayTasks[index];
    final editController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.editTaskTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText: localizations.editTaskHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.editCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                final dateKey = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                );
                setState(() {
                  _tasksByDate[dateKey]![index].title = editController.text.trim();
                });
                Navigator.pop(context);
                _showSuccessMessage(localizations.updateSuccess);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.editSave),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.deleteConfirmTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(localizations.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.deleteCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask(index);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(localizations.deleteConfirm),
          ),
        ],
      ),
    );
  }
}