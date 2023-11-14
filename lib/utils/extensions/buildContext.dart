import 'package:flutter/material.dart';
import 'package:pawrapet/utils/functions/common.dart';

/// A set of extension methods for navigation using BuildContext.
///
/// These extensions simplify navigation within a Flutter app by providing methods
/// to push and replace pages, as well as pop and pop until a specified route.
extension NavigationExtensions on BuildContext {
  /// Pushes the given [page] onto the navigation stack.
  void push(Widget page) {
    if (!mounted) {
      xPrint("push failed as context is not mounted", header: "navigationExtensions/push");
      return;
    }
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Replaces the current page with the given [page].
  void pushReplacement(Widget page) {
    if (!mounted) {
      xPrint("pushReplacement failed as context is not mounted", header: "navigationExtensions/pushReplacement");
      return;
    }
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Pops the current page off the navigation stack.
  void pop() {
    if (!mounted) {
      xPrint("pop failed as context is not mounted", header: "navigationExtensions/pop");
      return;
    }
    Navigator.pop(this);
  }

  /// Pops the navigation stack until the specified [routeName] is reached.
  void popUntil(String routeName) {
    if (!mounted) {
      xPrint("popUntil failed as context is not mounted", header: "navigationExtensions/popUntil");
      return;
    }
    Navigator.popUntil(this, ModalRoute.withName(routeName));
  }
}
