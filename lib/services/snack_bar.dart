import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../main.dart';

enum SnackBarType { info, error, success }

class SnackBarService {

  static Flushbar? _currentInfiniteFlushBar;

  static showInformation(String message, {bool isInfiniteDuration = false}) {
    genericShowSnackBar(
      message,
      isInfiniteDuration: isInfiniteDuration,
    );
  }

  static showError(String message, {bool isInfiniteDuration = false}) {
    genericShowSnackBar(
      message,
      type: SnackBarType.error,
      isInfiniteDuration: isInfiniteDuration,
    );
  }

  static showSuccess(String message, {bool isInfiniteDuration = false}) {
    genericShowSnackBar(
      message,
      type: SnackBarType.success,
      isInfiniteDuration: isInfiniteDuration,
    );
  }

  static genericShowSnackBar(String message,
      {SnackBarType type = SnackBarType.info,
      bool isInfiniteDuration = false}) {
    BuildContext? context = NavigationService.navigatorKey.currentContext;

    if (context != null) {
      Flushbar currentFlushBar = Flushbar(
        message: message,
        backgroundColor: type == SnackBarType.error
            ? Colors.red
            : type == SnackBarType.success
                ? Colors.green
                : Colors.grey,
        duration: isInfiniteDuration
            ? const Duration(days: 10)
            : const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
      );
      
      currentFlushBar.show(context);
      
      if (isInfiniteDuration){
        _currentInfiniteFlushBar = currentFlushBar;
      }
    }
  }

  static hideCurrentToast() {
    if (_currentInfiniteFlushBar != null){
      _currentInfiniteFlushBar!.dismiss();
    }
  }
}
