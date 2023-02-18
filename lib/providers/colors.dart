import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './color.dart';

class MultiColor with ChangeNotifier {
  final List<SingleColor> _colors = [];

  List<SingleColor> get colors => _colors;

  void selectAll(bool nilai) async {
    if (nilai) {
      for (var element in _colors) {
        var response = await http.patch(
          Uri.parse(
              "https://flutter-firebase-7cca4-default-rtdb.firebaseio.com/colors/${element.id}.json"),
          body: json.encode(
            {
              "status": true,
            },
          ),
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          print(response.body);
          element.status = true;
        }
      }
    } else {
      for (var element in _colors) {
        var response = await http.patch(
          Uri.parse(
              "https://flutter-firebase-7cca4-default-rtdb.firebaseio.com/colors/${element.id}.json"),
          body: json.encode(
            {
              "status": false,
            },
          ),
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          print(response.body);
          element.status = false;
        }
      }
    }
    notifyListeners();
  }

  checkAllStatus() {
    var hasil = _colors.every((element) => element.status == true);
    return hasil;
  }

  intializeData() async {
    Uri url = Uri.parse(
        "https://flutter-firebase-7cca4-default-rtdb.firebaseio.com/colors.json");

    try {
      var response = await http.get(url);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = json.decode(response.body) as Map<String, dynamic>;
        _colors.clear();
        data.forEach((key, data) {
          _colors.add(
            SingleColor(
              id: key,
              title: data["title"],
              status: data["status"],
            ),
          );
        });

        notifyListeners();
      }
    } catch (err) {
      rethrow;
    }
  }

  void addColor(String title) async {
    Uri url = Uri.parse(
        "https://flutter-firebase-7cca4-default-rtdb.firebaseio.com/colors.json");

    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            "title": title,
            "status": false,
          },
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _colors.add(
          SingleColor(
            id: json.decode(response.body)["name"],
            title: title,
          ),
        );
        notifyListeners();
      } else {
        throw "${response.statusCode}";
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> updateStatus(String id, bool status) async {
    Uri url = Uri.parse(
        "https://flutter-firebase-7cca4-default-rtdb.firebaseio.com/colors/$id.json");

    var response = await http.patch(
      url,
      body: json.encode(
        {
          "status": status,
        },
      ),
    );

    if (response.statusCode < 200 && response.statusCode > 299) {
      return false;
    } else {
      return true;
    }
  }

  void deleteColor(String id) async {
    Uri url = Uri.parse(
        "https://flutter-firebase-7cca4-default-rtdb.firebaseio.com/colors/$id.json");

    try {
      var response = await http.delete(
        url,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _colors.removeWhere((element) => element.id == id);
        notifyListeners();
      } else {
        throw "${response.statusCode}";
      }
    } catch (err) {
      rethrow;
    }
  }
}
