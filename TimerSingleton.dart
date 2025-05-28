import 'dart:async';

class TimerSingleton {
  static final TimerSingleton _singleton = TimerSingleton._internal();

  factory TimerSingleton() {
    return _singleton;
  }

  TimerSingleton._internal() {
    _timerController = StreamController<String>.broadcast();
  }

  String time = '0:02:00';
  Timer? _timer;
  bool soundPlayed = false;
  Duration duration = const Duration(seconds: 120);
  late StreamController<String> _timerController;
  bool _paused = false;
  int _secondsRemaining = 0;
  bool showBottomBar = false;

  Stream<String> get timerStream => _timerController.stream;

  void startTimer() {
    showBottomBar = true;
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _secondsRemaining = duration.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!_paused) {
        if (_secondsRemaining >= 0) {
          int hours = _secondsRemaining ~/ 3600;
          int minutes = (_secondsRemaining % 3600) ~/ 60;
          int remainingSeconds = _secondsRemaining % 60;
          time =
              '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
          _timerController.add(time);
          _secondsRemaining--;
        } else {
          _timer!.cancel();
        }
      }
    });
  }

  void pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _paused = true;
    }
  }

  void resumeTimer() {
    _paused = false;
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _paused = false;
    time = '0:02:00';
    _secondsRemaining = duration.inSeconds;
    // showBottomBar = false;
  }
}
