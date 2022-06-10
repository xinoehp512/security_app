import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: "logout",
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text("Logout"),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "settings",
                child: Row(
                  children: const [
                    Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text("Settings"),
                  ],
                ),
              ),
            ],
            onChanged: (itemID) {
              if (itemID == "logout") {
                FirebaseAuth.instance.signOut();
              }
              if (itemID == "settings") {
                Navigator.of(context).pushNamed("/settings");
              }
            },
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Waiting for the database..."));
            }
            final userData = snapshot.data!.data()!;
            return Center(
                child: Text("Welcome to Nowhere, ${userData['username']}."));
          }),
    );
  }
}
