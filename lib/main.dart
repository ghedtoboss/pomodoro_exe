import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final int _workTime = 25 * 60;
  final int _shortBreakTime = 5 * 60;
  final int _longBreakTime = 30 * 60;
  int _cycles = 0;
  int _totalCycles = 0;
  int _currentTimer = 0;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTimer = _workTime;
  }

  void _startWorkTimer(int duration) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimer == 0) {
        timer.cancel();
        if (_cycles < 3) {
          _currentTimer = _shortBreakTime;
          _startShortTimer(_shortBreakTime);
        } else {
          _currentTimer = _longBreakTime;
          _startLongTimer(_longBreakTime);
        }
      } else {
        setState(() {
          _currentTimer--;
        });
      }
    });
  }

  void _startShortTimer(int duration) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimer == 0) {
        timer.cancel();
        _cycles++;
        _totalCycles++;
        _currentTimer = _workTime;
        _startWorkTimer(_workTime);
      } else {
        setState(() {
          _currentTimer--;
        });
      }
    });
  }

  void _startLongTimer(int duration) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimer == 0) {
        timer.cancel();
        _cycles = 0;
        _currentTimer = _workTime;
        _startWorkTimer(_workTime);
      } else {
        setState(() {
          _currentTimer--;
        });
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer?.cancel();
      } else {
        _startWorkTimer(_currentTimer);
      }
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _currentTimer = _workTime;
      _cycles = 0;
      _totalCycles = 0;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(_currentTimer ~/ 60).toString().padLeft(2, '0')}:${(_currentTimer % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Döngü: $_cycles / 3',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Toplam Döngü: $_totalCycles',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _toggleTimer,
                    child: Text(_isRunning ? "Duraklat" : "Başlat")),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: _resetTimer, child: const Text("Sıfırla"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
