// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowGuide extends StatelessWidget {
  final String documentID;

  const ShowGuide({super.key, required this.documentID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.arrow_back_ios_new,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* IconButton(
              alignment: Alignment.topLeft,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
              iconSize: 30,
              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            ), */
            GetData(documentID: documentID),
          ],
        ),
      ),
    );
  }
}

class GetData extends StatelessWidget {
  final String documentID;

  const GetData({super.key, required this.documentID});

  @override
  Widget build(BuildContext context) {
    bool isRecycle;

    CollectionReference description =
        FirebaseFirestore.instance.collection(documentID);

    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: description.doc(documentID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            data["isRecyclable"] == "Recyclable"
                ? isRecycle = true
                : isRecycle = false;
            List<dynamic> types = data["type"];
            List<dynamic> howTo = data["how"];
            int typescount = types.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Image.asset(
                    "asset/guideicons/$documentID.png",
                    height: 100,
                    width: 100,
                  ),
                ),
                Center(
                  child: Text(
                    documentID,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: isRecycle
                      ? Text(
                          "${data["isRecyclable"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightGreen,
                          ),
                        )
                      : Text(
                          "${data["isRecyclable"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${data["description"]}",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ExpansionTile(
                  title: Text(
                    "Object Examples:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: typescount,
                      itemBuilder: (context, index) {
                        return Text(
                          "${types[index]}",
                          style: TextStyle(fontSize: 16),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  "How to recycle?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                for (var step in howTo)
                  Text(
                    "$step",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
