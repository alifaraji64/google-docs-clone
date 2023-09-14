import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/document.dart';
import 'package:google_docs_clone/models/error.dart';
import 'package:google_docs_clone/repository/auth.dart';
import 'package:google_docs_clone/repository/document.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                final navigator = Routemaster.of(context);
                final snackbar = ScaffoldMessenger.of(context);
                ErrorModel error =
                    await ref.read(documentProvider).createDocument();
                if (error.isError) {
                  snackbar.showSnackBar(SnackBar(
                      content: Text(
                    error.message,
                  )));
                  return;
                }
                navigator.push("/document/${error.data.id}");
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                ref.read(authProvider).logout();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      body: FutureBuilder(
        future: ref.watch(documentProvider).getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Center(
              child: Container(
                width: 600,
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    DocumentModel documentModel = snapshot.data!.data[index];
                    return InkWell(
                      onTap: () {
                        Routemaster.of(context)
                            .push('/document/${documentModel.id}');
                      },
                      child: SizedBox(
                        height: 60,
                        child: Card(
                          child: Center(
                            child: Text(
                              documentModel.title,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  itemCount: snapshot.data!.data.length,
                ),
              ),
            );
          }
          return const Text('hi');
        },
      ),
    );
  }
}
