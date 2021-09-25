import 'package:flutter/foundation.dart';

class Counter extends ChangeNotifier{
  double progressPercent = 0;

  
  void increamentProgress() {
    progressPercent = progressPercent + 0.5;
    notifyListeners();
  }

 String displayPercent() {
    if (progressPercent == 0) {
      return '0';
    } else {
      var finalAns = (progressPercent * 100).toInt();
      return finalAns.toString();
    }
  }
}
