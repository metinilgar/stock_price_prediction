import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_controller.g.dart';

@riverpod
class NavigationController extends _$NavigationController {
  @override
  int build() {
    return 0;
  }

  void changeScreen(int index) {
    state = index;
  }
}
