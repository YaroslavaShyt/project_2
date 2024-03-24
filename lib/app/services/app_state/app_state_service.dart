import 'package:shared_preferences/shared_preferences.dart';

enum AppState { foreground, background, terminated }

class AppStateService {
  AppState _appState;

  AppStateService({AppState appstate = AppState.foreground})
      : _appState = appstate;

  AppState get appState => _appState;

  set appState(AppState newState) {
    _appState = newState;
    if (newState == AppState.background || newState == AppState.terminated) {
      save(key: 'appState', data: newState.toString())
          .then((value) => print("state set ${newState.toString()}"));
    } else {
      print("state set ${newState.toString()}");
    }
  }

  Future<void> save({required String key, required String data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  Future<String> read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(key) ?? '';
    if(data == AppState.background.toString()){
      appState = AppState.background;
    }
    if (data == AppState.terminated.toString()){
      appState = AppState.terminated;
    }
    return data;
  }

}
