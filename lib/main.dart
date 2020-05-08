import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/screen/create_profile.dart';
import 'package:marketplace/screen/home_page.dart';
import 'package:marketplace/screen/main_page.dart';
import 'helper/prefkeys.dart';
import 'helper/res.dart';
import 'injection/dependency_injection.dart';
import 'package:intl/intl.dart';

void main() => setupLocator();

//AuthService appAuth = new AuthService();

Future setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Injector.getInstance();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


@override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = DateTime.now();
    String sessionStart = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    Injector.prefs.setString(PrefKeys.sessionStart, sessionStart.toString());

}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: "Townsy Business App",
        theme: ThemeData(
          primaryColor: ColorRes.black,
          fontFamily: FontRes.nunito,
          backgroundColor: ColorRes.white,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 15, color: ColorRes.black),
          )),
      debugShowCheckedModeBanner: false,
      home:  Injector.userDataMain != null
          ? (Injector.userDataMain.profileStatus == 1
              ? HomePage()
              : CreateProfile())
          : MainLoginPage(),
      routes: {
        '/home': (BuildContext context) => CreateProfile(),
        '/login': (BuildContext context) => MainLoginPage(),
        '/drawerMenu': (BuildContext context) => HomePage(),
      /*  '/webview':(_) {
          return WebviewScaffold(
            url: widget.webUrl,
            appBar: AppBar(
              title: const Text('Widget WebView'),
            ),
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
          );
        }*/
      },
    );
  }
}




