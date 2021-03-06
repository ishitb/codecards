import 'package:codecards/Services/adProvider.dart';
import 'package:codecards/Services/notesServices/noteData.dart';
import 'package:codecards/Services/notesServices/noteModel.dart';
import 'package:codecards/Services/signupSignin/userRepository.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:codecards/Shared/themes.dart';
import 'package:codecards/UI/MainNavigationUI/MenuDashboardLayout/menu_dashboard.dart';
import 'package:codecards/UI/Settings/Avatar/avatar_provider.dart';
import 'package:codecards/UI/Settings/Avatar/avatar.dart';
import 'package:codecards/UI/Settings/settings2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/cardsServices/cardsProvider.dart';
import 'UI/Login/loginScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'UI/OnBoard/onBoardNew.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'UI/Settings/Contact_US/Contact_US.dart';

SharedPreferences prefs;
const String avatarKey = 'avatar';
const String hintKey = 'hint';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(NoteModelAdapter());
  Admob.initialize("com.example.codecards");
  prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey(avatarKey)) {
    await prefs.setString(avatarKey, 'assets/images/boss.PNG');
  }
  if (!prefs.containsKey(hintKey)) {
    await prefs.setInt(hintKey, 0);
  }
  if (!prefs.containsKey('themeKey')) {
    await prefs.setString('themeKey', "AppThemes.BluePop");
  }

  await _checkInitialRoute().then((value) {
    runApp(MyApp(initialRoute: value ? 'menuDashBoard' : '/'));
  });
}

Future<bool> _checkInitialRoute() async {
  SharedPreferences _sprefs = await SharedPreferences.getInstance();
  return _sprefs.containsKey('userToken');
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({Key key, this.initialRoute}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();
    _showNotifications();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  Future<void> notification() async {
    var time = Time(4, 10, 50);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'id', 'CodeCards', 'Reminder to code daily',
        priority: Priority.High, importance: Importance.Max);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Reminder',
        'Problems await coder, open CodeCards and swipe to fuck',
        time,
        platformChannelSpecifics);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
    return null;
    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CardsProvider>(
          create: (_) => CardsProvider(),
        ),
        ChangeNotifierProvider<NoteData>(
          create: (_) => NoteData(),
        ),
        ChangeNotifierProvider<ThemeChanger>(
          create: (_) =>
              ThemeChanger(appThemeData[prefs.getString('themeKey')]),
        ),
        ChangeNotifierProvider<UserRepository>(
          create: (_) => UserRepository(
            userEmail: prefs.getString('userEmail'),
            userName: prefs.getString('userName'),
            userAvatar: prefs.getString('userAvatar'),
            userToken: prefs.getString('userToken'),
          ),
        ),
        ChangeNotifierProvider<AvatarChanger>(
          create: (_) => AvatarChanger(prefs.getString(avatarKey)),
        ),
        ChangeNotifierProvider<HintCounter>(
          create: (_) => HintCounter(prefs.getInt(hintKey)),
        )
      ],
      child: Builder(builder: (BuildContext context) {
        return MyHomePage(initialRoute: widget.initialRoute);
      }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String initialRoute;

  const MyHomePage({Key key, this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    Future.delayed(Duration(milliseconds: 1400));
    return MaterialApp(
      title: 'CodeCards',
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => OnBoardNew(),
        'login': (context) => LoginScreen(),
        'menuDashBoard': (context) => MenuDashboardPage(),
        '/settings2': (context) => Settings(),
        'avatar': (context) => Avatar(),
        'contact_us': (context) => ContactUs()
      },
    );
  }
}
