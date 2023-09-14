import 'dart:convert';

import 'package:google_docs_clone/constants.dart';
import 'package:google_docs_clone/models/document.dart';
import 'package:http/http.dart' as http;
import 'package:google_docs_clone/models/error.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Document extends ChangeNotifier {
  Future<ErrorModel> createDocument() async {
    ErrorModel error = ErrorModel(isError: false, message: '');
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final String? jwt = preferences.getString('jwt');
      http.Response res = await http.post(
        Uri.parse('$uri/create-doc'),
        body: jsonEncode({'createdAt': DateTime.now().microsecondsSinceEpoch}),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'jwt': jwt!
        },
      );
      if (res.statusCode == 200) {
        return error = ErrorModel(
            isError: false,
            message: '',
            data: DocumentModel.fromJson(res.body));
      }
      error = handleResponseError(res: res, error: error);
    } catch (e) {
      error = ErrorModel(
        isError: true,
        message: 'unkown error occured while saving the document',
      );
    }
    return error;
  }

  Future<ErrorModel> getDocuments() async {
    ErrorModel error = ErrorModel(isError: false, message: '');
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final String? jwt = preferences.getString('jwt');
      http.Response res = await http.get(
        Uri.parse('$uri/get-doc'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'jwt': jwt!
        },
      );
      if (res.statusCode == 200) {
        List<DocumentModel> documents = [];
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          documents.add(DocumentModel.fromMap(jsonDecode(res.body)[i]));
        }
        return error = ErrorModel(isError: false, message: '', data: documents);
      }
      error = handleResponseError(res: res, error: error);
    } catch (e) {
      error = ErrorModel(
        isError: true,
        message: 'unkown error occured while saving the document',
      );
    }
    return error;
  }
}

final documentProvider = ChangeNotifierProvider<Document>((ref) => Document());
