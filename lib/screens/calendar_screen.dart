import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_2/screens/settings_screen.dart';
import 'package:flutter_application_2/screens/daily_option_screen.dart';

class CalendarScreen extends StatefulWidget {
  final String nickname;

  const CalendarScreen({required this.nickname});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  late String _nickname;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _loadBackgroundColor();
  }

  Future<void> _loadBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('calendarBackgroundColor');
    if (colorValue != null) {
      setState(() {
        _backgroundColor = Color(colorValue);
      });
    }
  }

  Future<void> _updateBackgroundColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calendarBackgroundColor', color.value);
    setState(() {
      _backgroundColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_nickname님의 감정 다이어리🗓'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    currentNickname: _nickname,
                    onNicknameChanged: (newNickname) {
                      setState(() {
                        _nickname = newNickname;
                      });
                    },
                    onBackgroundColorChanged: (color) {
                      setState(() {
                        _backgroundColor = color;
                      });
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        color: _backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.red,         // 선택된 날짜 배경
                  onPrimary: Colors.blue,     // 선택된 날짜 텍스트
                  onSurface: Colors.black,     // 기본 날짜 텍스트
                ),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyOptionsScreen(
                        selectedDate: _selectedDate,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '날짜를 선택하면 감정 / 메모 / 할일 선택 화면으로 이동합니다',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
