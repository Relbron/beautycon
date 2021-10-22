import 'package:beautycon/fcm/fcm_background_handler.dart';
import 'package:beautycon/fcm/fcm_notification_handler.dart';
import 'package:beautycon/ui/booking_screen.dart';
import 'package:beautycon/ui/done_services_screens.dart';
import 'package:beautycon/ui/home_screen.dart';
import 'package:beautycon/ui/staff_home_screen.dart';
import 'package:beautycon/ui/stylist_booking_history_screen.dart';
import 'package:beautycon/ui/user_history_screen.dart';
import 'package:beautycon/utils/utils.dart';
import 'package:beautycon/view_model/main/main_view_model_imp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
AndroidNotificationChannel? channel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Setup Firebase
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  //Flutter Local Notifications
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel = const AndroidNotificationChannel('jadm.dev', 'JADM Dev',
      description: 'This is my death', importance: Importance.max);

  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/staffHome':
            return PageTransition(
                settings: settings,
                child: StaffHome(),
                type: PageTransitionType.fade);
          case '/doneService':
            return PageTransition(
                settings: settings,
                child: DoneService(),
                type: PageTransitionType.fade);
          case '/home':
            return PageTransition(
                settings: settings,
                child: HomePage(),
                type: PageTransitionType.fade);
          case '/booking':
            return PageTransition(
                settings: settings,
                child: BookingScreen(),
                type: PageTransitionType.fade);
          case '/history':
            return PageTransition(
                settings: settings,
                child: UserHistory(),
                type: PageTransitionType.fade);
          case '/bookingHistory':
            return PageTransition(
                settings: settings,
                child: StylistHistoryScreen(),
                type: PageTransitionType.fade);
          default:
            return null;
        }
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final scaffoldState = new GlobalKey<ScaffoldState>();
  final mainViewModel = MainViewModelImp();

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    //Get token, subscribe, etc... here

    //Get token
    FirebaseMessaging.instance.getToken()
    .then((value) => print('Token $value'));

    //Subscribe topic, example name is: demoSubscribe
    FirebaseMessaging.instance.subscribeToTopic(FirebaseAuth.instance.currentUser!.uid)
    .then((value) => print('Success'));

    //Setup message display
    initFirebaseMessagingHandler(channel!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: widget.scaffoldState,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/mymock.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: widget.mainViewModel
                    .checkLoginState(context, false, widget.scaffoldState),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else {
                    var userState = snapshot.data as LOGIN_STATE;
                    if (userState == LOGIN_STATE.LOGGED) {
                      return Container();
                    } else {
                      return ElevatedButton.icon(
                        onPressed: () => widget.mainViewModel
                            .processLogin(context, widget.scaffoldState),
                        icon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        label: Text(
                          'LOGIN WITH PHONE',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      );
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
