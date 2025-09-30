import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/reusable/logoutprompt.dart';
import 'package:fyp/reusable/showguide.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesState();
}

List<String> docIDs = [];

Future getDocID() async {
  await FirebaseFirestore.instance.collection("Description").get().then(
        (snapshot) => snapshot.docs.forEach(
          (document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          },
        ),
      );
}

class _GuidesState extends State<GuidesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sorting Guide",
        ),
        automaticallyImplyLeading: false,
        actions: [LogOutPrompt()],
        backgroundColor: const Color(0xFF99d578),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: FutureBuilder(
                future: getDocID(),
                builder: (context, snapshot) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return GridTile(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowGuide(documentID: docIDs[index])),
                            );
                          },
                          child: Center(
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width * 0.48,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "asset/guideicons/${docIDs[index]}.png",
                                      height: 100,
                                      width: 100,
                                    ),
                                    Text(
                                      docIDs[index],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
