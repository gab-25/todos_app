import 'package:energy_monitor_app/blocs/app/app_state.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppUserSubscriptionRequested extends AppEvent {
  const AppUserSubscriptionRequested();
}

final class AppLogoutPressed extends AppEvent {
  const AppLogoutPressed();
}

final class AppTabPressed extends AppEvent {
  const AppTabPressed(this.tabSelected);

  final AppTabs tabSelected;
}
