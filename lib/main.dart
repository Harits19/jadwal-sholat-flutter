import 'dart:ui';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Sholat> fetchSholat() async {
  String link =
      "http://api.aladhan.com/v1/calendarByCity?city=Yogyakarta&country=Indonesia&method=9&month=02&year=2021";
  var response = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

  List<Sholat> list;

  if (response.statusCode == 200) {
    var body = json.decode(response.body); //get body
    var data = body["data"] as List; // get data object convert to list
    var timings = data[0]; //get list data index 0
    timings = timings["timings"]; //get object timing
    // print(timings);
    return Sholat.fromJson(timings); // map object from json
  } else {
    throw Exception('Failed to load sholat');
  }
}

class Sholat {
  final String dhuhr, fajr, asr, maghrib, isha;

  Sholat({this.dhuhr, this.fajr, this.asr, this.maghrib, this.isha});

  factory Sholat.fromJson(Map<String, dynamic> json) {
    return Sholat(
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }
}


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  @override
  Widget build(BuildContext context) {}
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  Future<Sholat> futureSholat;

  @override
  void initState() {
    super.initState();
    futureSholat = fetchSholat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Jadwal Sholat',
      // home: MyStatefulWidget(), // bottomNavigation
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Aplikasi Jadwal Sholat'),
        ),
        body: Center(
          child: FutureBuilder<Sholat>(
            future: futureSholat,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: <Widget>[
                    Card(
                        child: ListTile(
                      title: Text("Jadwal Sholat Hari Ini",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          )),
                      subtitle: Text(
                        "Untuk Wilayah Yogyakarta",
                        textAlign: TextAlign.center,
                      ),
                    )),
                    Card(
                        child: ListTile(
                      title: Text("Sholat Shubuh",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${snapshot.data.fajr}"),
                    )),
                    Card(
                        child: ListTile(
                      title: Text("Sholat Dzuhur",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${snapshot.data.dhuhr}"),
                    )),
                    Card(
                        child: ListTile(
                      title: Text("Sholat Ashar",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${snapshot.data.asr}"),
                    )),
                    Card(
                        child: ListTile(
                      title: Text("Sholat Magrib",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${snapshot.data.maghrib}"),
                    )),
                    Card(
                        child: ListTile(
                      title: Text("Sholat Isya",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${snapshot.data.isha}"),
                    )),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
