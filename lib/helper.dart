import 'dart:convert';

import 'package:wifi/wifi.dart';
import 'package:gateway/gateway.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:wifi_configuration/wifi_configuration.dart';
import 'package:http/http.dart' as http;


class Helper {


  Future<String> getWifiName() async {
    String wifiName = await Wifi.ssid;

    await Wifi.list("key");

    return wifiName;
  }


  Future<int> getWifiLevel() async {
    int l = await Wifi.level;


    return l;
  }


  Future<String> getIP() async {
    String ip = await Wifi.ip;
    return ip;
  }


  Future<Gateway> getNetwork() async {
    Gateway gateway = await Gateway.info;


    return gateway;
  }


  Future<String> getrouterIp() async {
    WifiInfoWrapper wifiObject = await WifiInfoPlugin.wifiDetails;

    String routerIp = await wifiObject.routerIp;


    return routerIp;
  }


  Future<String> connection(String ssid, String password) async {
    String result;

//    WifiConnectionStatus connectionStatus = await WifiConfiguration.connectToWifi("MicroPython-AP", "123456789", "com.elmohamady.carkey");

    WifiConnectionStatus connectionStatus = await WifiConfiguration
        .connectToWifi(ssid, password, "com.elmohamady.carkey");


    switch (connectionStatus) {
      case WifiConnectionStatus.connected:
        result = "connected";
        break;

      case WifiConnectionStatus.alreadyConnected:
        result = "alreadyConnected";
        break;

      case WifiConnectionStatus.notConnected:
        result = "notConnected";
        break;

      case WifiConnectionStatus.platformNotSupported:
        result = "platformNotSupported";
        break;

      case WifiConnectionStatus.profileAlreadyInstalled:
        result = "profileAlreadyInstalled";
        break;

      case WifiConnectionStatus.locationNotAllowed:
        result = "locationNotAllowed";
        break;
    }


    return result;
  }


  Future<Null> sendToDoor(order, key) async {
    String myUrl = 'http://${await getrouterIp()}/${order}-${key}';

    await http.get(myUrl);


  }


}

