import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_001/application.dart';
import 'package:project_001/register.dart';
import 'package:project_001/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    print("Firebase initialized");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Login Form'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool is_password_visible = false;

  FirebaseFirestore db = FirebaseFirestore.instance;

  String username = "";
  String password = "";

  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // create collection
    //await db.collection("collection_test").doc("init").set({"init": true});
    // delete collection
    // await db.collection("collection_test").doc("init").delete();

    // init collection
    // db.collection("collection_credential").doc("init").set({});

    // add collection
    // db.collection("collection_credential").add({
    //   "username": "testuser",
    //   "password": "testpassword",
    // });
    // db.collection("collection_credential").add({
    //   "username": "hello",
    //   "password": "world",
    // });

    // read collection
    // db.collection("collection_credential").get().then((q) {
    //   for (var doc in q.docs) {
    //     print(doc.data());
    //   }
    // });

    // search
    //   db.collection("collection_credential") //
    //   .where("username", isEqualTo: "user") //
    //   .get() //
    //   .then((q){
    //     for (var doc in q.docs){
    //     print(doc.data());
    //   }
    // });

    // Delete
    // db
    //     .collection("collection_credential") //
    //     .where("username", isEqualTo: "testuser") //
    //     .get() //
    //     .then((q) {
    //       for (var doc in q.docs) {
    //         doc.reference.delete();
    //       }
    //     });

    // Update
    // db
    //     .collection("collection_credential") //
    //     .where("username", isEqualTo: "hello") //
    //     .get() //
    //     .then((q) {
    //       for (var doc in q.docs) {
    //         doc.reference.update({
    //           "username": "user_update", //
    //           "password": "user_update",
    //         });
    //       }
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                Text("Username: "),
                SizedBox(
                  width: 200,
                  child: TextField(controller: controller_username),
                ),
                SizedBox(height: 20),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Text("Password: "),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: controller_password,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          is_password_visible = !is_password_visible;
                          setState(() {});
                        },
                        icon: is_password_visible
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    ),
                    obscureText: !is_password_visible,
                  ),
                ),

                Spacer(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    username = controller_username.text;
                    password = controller_password.text;

                    db
                        .collection("collection_credential") //
                        .where("username", isEqualTo: username) //
                        .where("password", isEqualTo: password) //
                        .get() //
                        .then((q) {
                          if (q.docs.isEmpty) {
                            print("login failed");
                          } else {
                            print("login success");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ApplicationPage(title: "Application Form"),
                              ),
                            );
                          }
                        });
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         ApplicationPage(title: "Application Form"),
                    //   ),
                    // );
                  },
                  child: Text("Login"),
                ),
                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(title: "Register"),
                      ),
                    );
                  },
                  child: Text("Register"),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
