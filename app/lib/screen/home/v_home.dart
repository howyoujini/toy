import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int total = 3;
  List<Contact> contacts = [Contact(displayName: 'kyutae')];

  String answer = '';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              addOne();
              getPermission();
            },
            child: Text(contacts[index].displayName.toString()));
      },
    );
  }
}
