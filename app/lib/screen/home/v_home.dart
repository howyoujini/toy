import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text("home")),
        child: SafeArea(
          child: HomeView(),
        ));
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
