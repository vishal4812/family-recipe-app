import 'package:flutter/widgets.dart';

import 'app_dependencies.dart';

class AppDependenciesScope extends InheritedWidget {
  const AppDependenciesScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final AppDependencies dependencies;

  static AppDependencies read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<AppDependenciesScope>();
    final scope = element?.widget as AppDependenciesScope?;
    assert(
      scope != null,
      'AppDependenciesScope is missing in the widget tree.',
    );
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppDependenciesScope oldWidget) {
    return dependencies != oldWidget.dependencies;
  }
}
