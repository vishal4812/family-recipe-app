import 'package:flutter/widgets.dart';

import 'app_state.dart';

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope is missing in the widget tree.');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final inheritedElement = context
        .getElementForInheritedWidgetOfExactType<AppStateScope>();
    final scope = inheritedElement?.widget as AppStateScope?;
    assert(scope != null, 'AppStateScope is missing in the widget tree.');
    return scope!.notifier!;
  }
}
