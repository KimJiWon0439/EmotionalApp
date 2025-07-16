import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_2/screens/emotionSelect_screen.dart';
import 'package:flutter_application_2/screens/memo_screen.dart';
import 'package:flutter_application_2/screens/todolist_screen.dart';

class DailyOptionsScreen extends StatelessWidget {
  final DateTime selectedDate;

  const DailyOptionsScreen({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy년 MM월 dd일').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('$formattedDate 기록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '나의 특별한 하루',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmotionSelectScreen(
                      selectedDate: selectedDate, 
                      onEmotionSelected: (selectedEmotion) async {
                        final prefs = await SharedPreferences.getInstance();
                        final key = DateFormat('yyyy-MM-dd').format(selectedDate);
                        await prefs.setString('emotion_$key', selectedEmotion);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              child: const Text('감정 선택'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoScreen(selectedDate: selectedDate),
                  ),
                );
              },
              child: const Text('메모장'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoListScreen(selectedDate: selectedDate),
                  ),
                );
              },
              child: const Text('할 일 목록'),
            ),
          ],
        ),
      ),
    );
  }
}
