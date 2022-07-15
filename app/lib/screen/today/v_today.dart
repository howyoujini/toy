import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  int total = 3;
  List<Contact> contacts = [Contact(displayName: 'kyutae')];
  String answer = '';
  var userImage;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    var map = {'age': 12};
    storage.setString('name', 'john');
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('name');
    var result1 = storage.getString('map') ?? '';
    print(jsonDecode(result1));
  }

  addOne() {
    setState(() {
      total++;
    });
  }

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      answer = '허락됨';
      contacts = await ContactsService.getContacts();
      setState(() {
        contacts.add(Contact(displayName: 'youjin'));
        contacts.add(Contact(displayName: 'hi'));
      });
    } else if (status.isDenied) {
      answer = '안되지롱';
      Permission.contacts.request();
      openAppSettings();
    }
  }

  var data = [];

  // getData() async {
  //   var result = await dio.Response();
  //   setState(() {
  //     data = result;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getData();
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return Image.file(userImage);
              }));
            },
            child: Text(contacts[index].displayName.toString()));
      },
    );
  }
}
