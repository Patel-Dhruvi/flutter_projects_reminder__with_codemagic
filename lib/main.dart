import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reminder_things/Constants.dart';
import 'package:reminder_things/DrawerScreen/DrawerAbout.dart';
import 'package:reminder_things/DrawerScreen/DrawerSettings.dart';
import 'AppScreens/AddDetailsScreen.dart';
import 'AppScreens/Home.dart';
import 'AppScreens/SplashScreen.dart';
import 'DrawerScreen/DrawerHelp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      title: "Reminder App",
      debugShowCheckedModeBanner: false,
      color: kAppThemeLightColor,
      theme: ThemeData(
        primaryColor: kAppThemeLightColor,
        scaffoldBackgroundColor: kAppThemeLightColor,
          canvasColor: Colors.transparent,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings){
        switch(settings.name){
          case '/': return MaterialPageRoute(builder:(_)=> SplashScreen());
          break;
          case '/home':
            final Home args = settings.arguments;
            return MaterialPageRoute(builder:(_)=> Home(preSelectedTab:args.preSelectedTab));
          break;
          case '/details':
            final AddDetailsScreen args = settings.arguments;
            return MaterialPageRoute(builder:(_)=> AddDetailsScreen(isListDataTapped:args.isListDataTapped,
              itemId:args.itemId,selecteditemType:args.selecteditemType,tabSelected: args.tabSelected,));
            break;
          case '/settings':
            return  MaterialPageRoute(builder:(_)=> DrawerSettings());
            break;
          case '/about':
            return  MaterialPageRoute(builder:(_)=> DrawerAbout());
            break;
          case '/help':
            return  MaterialPageRoute(builder:(_)=> DrawerHelp());
            break;
          default:
            return null;
        }
      },
    );
  }
}
