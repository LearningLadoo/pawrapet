import 'package:flutter/material.dart';
/// A set of extension methods for navigation using BuildContext.
///
/// These extensions simplify navigation within a Flutter app by providing methods
/// to push and replace pages, as well as pop and pop until a specified route.
extension NavigationExtensions on BuildContext {
  /// Pushes the given [page] onto the navigation stack.
  void push(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Replaces the current page with the given [page].
  void pushReplacement(Widget page) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Pops the current page off the navigation stack.
  void pop() {
    Navigator.pop(this);
  }

  /// Pops the navigation stack until the specified [routeName] is reached.
  void popUntil(String routeName) {
    Navigator.popUntil(this, ModalRoute.withName(routeName));
  }
}
