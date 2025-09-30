import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetData extends StatelessWidget {
  final String documentID;

  const GetData({super.key, required this.documentID});

  @override
  Widget build(BuildContext context) {
    CollectionReference description =
        FirebaseFirestore.instance.collection(documentID);

    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: description.doc(documentID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              child: Column(
                children: [
                  Image.asset("asset/guideicons/$documentID.png"),
                  Text(
                    documentID,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  
                  Text("${data["isRecyclable"]}",style: TextStyle(),),
                  Text("\n\nDescription \n"),
                  Text("${data["description"]}"),
                  Text("\n\n${data["type"]}")
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
