import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EmotionSelectScreen extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(String) onEmotionSelected;

  const EmotionSelectScreen({
    Key? key,
    required this.selectedDate,
    required this.onEmotionSelected,
  }) : super(key: key);

  @override
  State<EmotionSelectScreen> createState() => _EmotionSelectScreenState();
}

class _EmotionSelectScreenState extends State<EmotionSelectScreen> {
  String? _selectedEmotion;

//이모지 유니코드 
  final emotions = {
    '기쁨': '\u{1F60D}', // 😍
    '슬픔': '\u{1F62D}', // 😭
    '화남': '\u{1F92C}', // 🤬
    '힘듦': '\u{1F630}', // 😰
    '지루함': '\u{1F971}', // 🥱
    '재밌음': '\u{1F923}', // 🤣
  };

  @override
  void initState() {
    super.initState();
    _loadSavedEmotion();
  }

  Future<void> _loadSavedEmotion() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getEmotionKey(widget.selectedDate);
    final savedEmotion = prefs.getString(key);
    setState(() {
      _selectedEmotion = savedEmotion;
    });
  }

  String _getEmotionKey(DateTime date) {
    return 'emotion_${DateFormat('yyyy-MM-dd').format(date)}';
  }

  Future<void> _saveEmotion(String emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getEmotionKey(widget.selectedDate);
    await prefs.setString(key, emotion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오늘은 어떤 기분이었나요?')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: emotions.entries.map((entry) {
          final isSelected = _selectedEmotion == entry.key;

          return GestureDetector(
            onTap: () async {
              setState(() {
                _selectedEmotion = entry.key;
              });

              await _saveEmotion(entry.key);
              widget.onEmotionSelected(entry.key);
              Navigator.pop(context);
            },
            child: Card(
              color: isSelected ? Colors.lightBlue[100] : null,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    entry.value,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    entry.key,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
