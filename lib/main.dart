import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './popular_item.dart';
import './list_item.dart';
import './bottom_nav.dart';
import './constants.dart';

final GSheets _gsheets = GSheets(Constants().credentials);
Spreadsheet _spreadsheet;
Worksheet _popularSheet;
Worksheet _allSheet;

bool isOnline;
List<List<String>> popList = new List<List<String>>();
List<List<String>> allList = new List<List<String>>();
var popularJson;
var allJson;
checkConnectivity() async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int lastUpdated = prefs.getInt('lastUpdated') ?? Constants().updateTimeoutMs-1000;
  if (connectivityResult == ConnectivityResult.mobile) {
    isOnline = true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    isOnline = true;
  } else {
    isOnline = false;
  }
  if(isOnline && DateTime.now().millisecondsSinceEpoch-lastUpdated > Constants().updateTimeoutMs){
    _spreadsheet ??= await _gsheets.spreadsheet(Constants().spreadsheetId);
    _popularSheet ??= await _spreadsheet.worksheetByIndex(Constants().popularSheetIndex);
    _allSheet ??= await _spreadsheet.worksheetByIndex(Constants().allSheetIndex);
    final popular = await _popularSheet.values.allRows(fromRow: 2);
    final all = await _allSheet.values.allRows(fromRow: 2);
    popular.forEach((f){
      if(f[0] != 'x') {
        popList.add(f);
      }
    });
    all.forEach((f){
      if(f[0] != 'x') {
        allList.add(f);
      }
    });
    print('updating prefs');
    updateSharedPrefs();

  }else{
    popularJson = json.decode(await prefs.getString('popular'));
    allJson = json.decode(await prefs.getString('all'));
    print('fetching prefs');
    popList = (popularJson as List).map((el)=>List<String>.from(el)).toList();
    allList = (allJson as List).map((el)=>List<String>.from(el)).toList();

  }
}
updateSharedPrefs() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('popular', json.encode(popList));
  await prefs.setString('all', json.encode(allList));
  await prefs.setInt('lastUpdated', DateTime.now().millisecondsSinceEpoch);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkConnectivity();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: Constants().app_name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: Constants().app_name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
     Widget popular_items = new Container(
        margin: EdgeInsets.all(0),
        height: 180,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popList.length,
            itemBuilder: (BuildContext ctxt, int index){
              return new PopularItem(popList[index][1], popList[index][2], popList[index][3], popList[index][4]);
            }
        )

    );


    Widget all_items(){
      return new Column(
        children: allList.map((f)=>ListItem(f[1], f[2], f[3], f[4])).toList()
      );
    }

    Widget body = new Container(
        margin: EdgeInsets.all(0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Center(child: Text('Populiarūs', style: TextStyle(color: Colors.amber, fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'Segoe'),)),
            popular_items,
            Center(child: Text('Visi', style: TextStyle(color: Colors.amber, fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'Segoe'),)),
            all_items()
          ],
        )

    );

    Widget nav_bar = new AppBar(
      elevation: 25,
      title: Center(
          child: Text(widget.title,
              style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: "Segoe"))),
      backgroundColor: Colors.transparent,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: nav_bar,
          body: body,
          bottomNavigationBar: BottomNav()
      )
    );

  }
}
