import 'package:flutter/material.dart';
import '/utils/localization.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(localizations.calendarTitle),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Calendar Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Calendar Grid
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildCalendar(),
            ),
          ),

          // Tasks for selected date
          Container(
            height: 200,
            color: Colors.grey[50],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${localizations.tasksForDay} ${_selectedDate.day}/${_selectedDate.month}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTaskItem(
                        localizations.meetingTeam,
                        '09:00',
                        Colors.blue,
                      ),
                      _buildTaskItem(
                        localizations.reviewCode,
                        '14:00',
                        Colors.green,
                      ),
                      _buildTaskItem(
                        localizations.deployProd,
                        '16:30',
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final localizations = AppLocalizations.of(context)!;
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42, // 6 weeks
      itemBuilder: (context, index) {
        final firstDay = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          1,
        );
        final weekDay = firstDay.weekday;
        final day = index - weekDay + 2;
        final currentDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          day,
        );

        final isCurrentMonth = currentDate.month == _selectedDate.month;
        final isToday = _isSameDay(currentDate, DateTime.now());
        final isSelected = _isSameDay(currentDate, _selectedDate);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = currentDate),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue
                  : (isToday ? Colors.blue[50] : Colors.transparent),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                isCurrentMonth ? currentDate.day.toString() : '',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isCurrentMonth ? Colors.grey[800] : Colors.grey[400]),
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskItem(String title, String time, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          color: color,
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: Icon(
          Icons.more_vert,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthName(int month) {
    final localizations = AppLocalizations.of(context)!;
    final monthNames = localizations.getMonthNames();
    return monthNames[month - 1];
  }

  void _changeMonth(int direction) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + direction,
        1,
      );
    });
  }
}