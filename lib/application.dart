import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_001/barcode_scanner.dart';
import 'package:project_001/firebase_options.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ApplicationPage(title: 'Application Form'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key, required this.title});

  final String title;

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> search_products = [];

  TextEditingController controller_bar_code = TextEditingController();
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_country = TextEditingController();
  TextEditingController controller_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    products.clear();
    //
    await db
        .collection("collection_product")
        .orderBy("created_at", descending: true)
        .get()
        .then((q) {
          for (var d in q.docs) {
            // print(d.id);
            // print(d.data().containsKey("bar_code"));
            // print(d.data().containsKey("name"));
            // print(d.data().containsKey("country"));
            // print(d.get("created_at"));

            var data = {
              "id": d.id,
              "bar_code": d.data().containsKey("bar_code")
                  ? d.get("bar_code")
                  : "",
              "name": d.data().containsKey("name") ? d.get("name") : "",
              "country": d.data().containsKey("country")
                  ? d.get("country")
                  : "",
            };

            products.add(data);
          }
        });
    search();

    setState(() {});
  }

  void search() {
    search_products.clear();
    if (controller_search.text.isEmpty) {
      search_products = products;
    } else {
      search_products = products.where((p) {
        return p["bar_code"].toString().contains(controller_search.text);
      }).toList();
    }
    setState(() {});
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  child: TextField(
                    controller: controller_search,
                    onChanged: (t) {
                      print(t);
                      init();
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BarcodeScannerPage();
                            },
                          ),
                        )
                        .then((v) {
                          controller_search.text = v;
                          search();

                          setState(() {});
                        });
                  },
                  icon: Icon(Icons.barcode_reader),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: search_products.length,
                itemBuilder: (context, i) {
                  return Row(
                    children: [
                      Container(
                        width: 160,
                        alignment: Alignment.center,

                        child: OutlinedButton(
                          onPressed: () {
                            //
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit Bar Code"),
                                  content: TextField(
                                    controller: controller_bar_code,
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        //
                                        var id = search_products[i]["id"];

                                        await db
                                            .collection("collection_product")
                                            .doc(id)
                                            .update({
                                              "bar_code":
                                                  controller_bar_code.text,
                                            });

                                        Navigator.pop(context);

                                        init();
                                        setState(() {});
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(search_products[i]["bar_code"]),
                        ),
                      ),

                      Container(
                        width: 160,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: () {
                            //
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit name"),
                                  content: TextField(
                                    controller: controller_name,
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        //
                                        var id = search_products[i]["id"];

                                        await db
                                            .collection("collection_product")
                                            .doc(id)
                                            .update({
                                              "name": controller_name.text,
                                            });

                                        Navigator.pop(context);

                                        init();
                                        setState(() {});
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(search_products[i]["name"]),
                        ),
                      ),

                      Container(
                        width: 160,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: () {
                            //
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit country"),
                                  content: TextField(
                                    controller: controller_country,
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        //
                                        var id = search_products[i]["id"];

                                        await db
                                            .collection("collection_product")
                                            .doc(id)
                                            .update({
                                              "country":
                                                  controller_country.text,
                                            });

                                        Navigator.pop(context);

                                        init();
                                        setState(() {});
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(search_products[i]["country"]),
                        ),
                      ),

                      Spacer(),

                      IconButton(
                        onPressed: () async {
                          var id = search_products[i]["id"];

                          await db
                              .collection("collection_product")
                              .doc(id)
                              .delete();

                          init();
                          setState(() {});
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //
          await db.collection("collection_product").add({
            "created_at": DateTime.now(),
          });
          init();
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
