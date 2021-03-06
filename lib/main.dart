import 'dart:async';
import 'dart:io';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:carkey/helper.dart';

import 'package:slider_button/slider_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication auth = LocalAuthentication();

  Helper helper = new Helper();
  int refresh = 0;
  String wifiName = "";
  String ssid = "EY3sfUbvn2Fh2B";
  String password = 'Fe]2&#}4s#weETV~}@jLGj8ep>BLrd!gp%S!7s2WgX#d@E}N-{U?B7Z_';

  String key =
      "Bq7WeycDwPZT2CZUknjqALDx693uNxEY3sfUbvn2Fh2BUKmznWz3sMfRj35XAMZD";

  Future<void> connectWifi(String ssid, String password) async {
    await helper.connection(ssid, password);
  }

  Future<void> DoorLock(String order) async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: "Authenticate for ${order}", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );
    } catch (e) {
      print(e);
    }
    if (authenticated) {
      await helper.getWifiName() == ssid
          ? await helper.sendToDoor(order, key)
          : await connectWifi(ssid, password).whenComplete(() async {
              sleep(new Duration(seconds: 2));
              await helper.sendToDoor(order, key);
            });
    }
  }

  @override
  void initState() {
    super.initState();
    connectWifi(ssid, password);
    helper.getWifiName().then((value) => wifiName = value);

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          refresh = refresh + 1;
          helper.getWifiName().then((value) => {wifiName = value});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text("Car Key")),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          FlatButton(
            child: Text(""),
            onPressed: () async => {await helper.connection(ssid, password)},
          ),
          Text(wifiName),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          Center(
              child: SliderButton(
                  dismissible: false,
                  action: () async => {
                        ///Do something here
                        await DoorLock("lock")
                      },
                  vibrationFlag: false,
                  label: Text(
                    "Slide to lock",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  icon: Icon(
                    Icons.chevron_right,
                    size: 50,
                  ))),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          Center(
              child: SliderButton(
                  dismissible: false,
                  action: () async => {
                        ///Do something here
                        await DoorLock("unlock")
                      },
                  vibrationFlag: false,
                  label: Text(
                    "Slide to unlock",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  icon: Icon(
                    Icons.chevron_right,
                    size: 50,
                  )))
        ],
      )),
    );
  }
}
