import 'package:flutter/widgets.dart';

class NavigationService {

  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {

    return navigationKey.currentState.pushNamed(routeName, arguments: arguments);

  }

    bool goBack() {

      return navigationKey.currentState.canPop();
    }
}