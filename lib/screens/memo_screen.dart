import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MemoScreen extends StatefulWidget {
  final DateTime selectedDate;

  const MemoScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  final TextEditingController _memoController = TextEditingController();
  static const int _maxLength = 500;

  @override
  void initState() {
    super.initState();
    _loadSavedMemo();
  }

  Future<void> _loadSavedMemo() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getMemoKey(widget.selectedDate);
    final savedMemo = prefs.getString(key) ?? '';
    _memoController.text = savedMemo;
  }

  Future<void> _saveMemo() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getMemoKey(widget.selectedDate);
    await prefs.setString(key, _memoController.text);
  }

  String _getMemoKey(DateTime date) {
    return 'memo_${DateFormat('yyyy-MM-dd').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy년 MM월 dd일').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(title: Text('$formattedDate 메모')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '오늘 하루는 어땠나요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _memoController,
              maxLength: _maxLength,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: '감정, 생각, 일기 등을 자유롭게 메모해보세요',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveMemo();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('메모가 저장되었습니다')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
