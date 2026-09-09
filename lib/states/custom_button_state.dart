import 'package:flutter/material.dart';

class CustomButtonState extends ChangeNotifier {
  bool isPressed = false;
  bool isClicked = false;

  void handleTapDown() {
    isPressed = true;
    notifyListeners();
  }

  void handleTapUp() {
    isPressed = false;
    notifyListeners();
  }

  void handleTapCancel() {
    isPressed = false;
    notifyListeners();
  }

  void handleTap() { 
    isClicked = !isClicked;
    notifyListeners();
  }
}