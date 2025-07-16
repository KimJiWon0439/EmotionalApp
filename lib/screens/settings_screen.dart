// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final String currentNickname;
  final void Function(String) onNicknameChanged;
  final void Function(Color) onBackgroundColorChanged;

  const SettingsScreen({
    Key? key,
    required this.currentNickname,
    required this.onNicknameChanged,
    required this.onBackgroundColorChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nicknameController;
  int _selectedStars = 0;
  Color _selectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.currentNickname);
    _loadSavedSettings(); // 저장된 값 불러오기
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('calendarBackgroundColor');
    final stars = prefs.getInt('developerRating');

    if (colorValue != null) {
      setState(() {
        _selectedColor = Color(colorValue);
      });
    }
    if (stars != null) {
      setState(() {
        _selectedStars = stars;
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calendarBackgroundColor', _selectedColor.value);
    await prefs.setInt('developerRating', _selectedStars);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설정이 저장되었습니다.')),
    );
  }

  Future<void> _clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 기록이 초기화되었습니다.')),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('앱 공유 기능은 아직 구현되지 않았습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 별명 변경
          TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: '별명 변경',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              widget.onNicknameChanged(_nicknameController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('별명이 변경되었습니다.')),
              );
            },
            child: const Text('별명 저장'),
          ),

          const Divider(height: 40),

          // 초기화
          ElevatedButton(
            onPressed: _clearAllData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('달력 내용 전체 초기화'),
          ),

          const Divider(height: 40),

          // 배경색 변경
          const Text('좋아하는 테마를 선택하세요:'),
          Wrap(
            spacing: 10,
            children: [
              Colors.white,
              Colors.lightBlue.shade50,
              Colors.yellow.shade100,
              Colors.pink.shade50,
              Colors.green.shade50,
            ].map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedColor = color);
                  widget.onBackgroundColorChanged(color);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == color ? Colors.black : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const Divider(height: 40),

          // 별점
          const Text('개발자에게 별점 주실 수 있나요?💌:'),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < _selectedStars ? Colors.orange : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _selectedStars = index + 1;
                  });
                },
              );
            }),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text('설정 저장'),
          ),

          const Divider(height: 40),

          // 앱 공유
          ElevatedButton(
            onPressed: _shareApp,
            child: const Text('앱 공유하기'),
          ),
        ],
      ),
    );
  }
}
