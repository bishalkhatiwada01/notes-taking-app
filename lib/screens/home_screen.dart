import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetakingapp/auth/login_page.dart';
import 'package:notetakingapp/screens/create_journal.dart';
import 'package:notetakingapp/screens/read_journal.dart';
import 'package:notetakingapp/style/app_stype.dart';
import 'package:notetakingapp/widgets/journal_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final journalsDb = FirebaseFirestore.instance.collection('journals');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
              
                UserAccountsDrawerHeader(
                  accountName: Text("Bishal Khatiwada"),
                  accountEmail: Text("Bishalkhatiwada14@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage(""),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("My Account"),
                  onTap: () {
                    // Handle tap to go to account screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  onTap: () {
                    // Handle tap to go to settings screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: AppStyle.mainColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Journals"),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          centerTitle: true,
          backgroundColor: AppStyle.mainColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Recents",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("journals")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        children: snapshot.data!.docs
                            .map((note) => journalCard(
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JournalReader(note),
                                    ),
                                  );
                                },
                                note,
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              journalsDb.doc(note.id).delete();
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }))
                            .toList(),
                      );
                    }
                    return Text("There is nothing",
                        style: GoogleFonts.nunito(color: Colors.white));
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => JournalEditor()));
          },
          label: Text("Add Journal"),
          icon: Icon(Icons.add),
        ));
  }
}
