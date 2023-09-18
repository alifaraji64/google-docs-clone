import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/document.dart';
import 'package:google_docs_clone/repository/document.dart';
import 'package:google_docs_clone/repository/socket.dart';

import '../models/error.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled document');
  quill.QuillController? _quillController = quill.QuillController.basic();
  SocketRepository socketRepository = SocketRepository();
  ErrorModel? error;
  void dispose() {
    titleController.dispose();
    _quillController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketRepository.joinRoom(widget.id);
    socketRepository.changeListener((data) {
      _quillController?.compose(
          quill.Delta.fromJson(data['delta']),
          _quillController?.selection ??
              const TextSelection.collapsed(offset: 0),
          quill.ChangeSource.REMOTE);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDocument();
  }

  void fetchDocument() async {
    final snackbar = ScaffoldMessenger.of(context);
    error = await ref.read(documentProvider).getDocumentById(id: widget.id);
    if (error!.isError) {
      snackbar.showSnackBar(SnackBar(
          content: Text(
        error!.message,
      )));
      return;
    }
    DocumentModel document = error!.data;
    titleController.text = document.title;
    _quillController = quill.QuillController(
        selection: const TextSelection.collapsed(offset: 0),
        document: (document).content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(quill.Delta.fromJson(document.content)));
    _quillController?.document.changes.listen((event) {
      if (event.item3 == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {'delta': event.item2, 'roomId': widget.id};
        socketRepository.typing(map);
        Timer.periodic(const Duration(seconds: 5), (timer) {
          socketRepository.autoSave(<String, dynamic>{
            'delta': _quillController!.document.toDelta(),
            'roomId': widget.id,
          });
          print('auto save');
        });
      }
      print(event);
      print('fsdfs');
    });
    setState(() {});
  }

  updateTitle() async {
    print('updating the title');
    final snackbar = ScaffoldMessenger.of(context);
    ErrorModel error = await ref
        .read(documentProvider)
        .updateTitle(id: widget.id, title: titleController.text);

    if (error.isError) {
      return snackbar.showSnackBar(SnackBar(
          content: Text(
        error.message,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quillController == null || error == null) {
      return const CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Image.asset(
                'docs-logo.png',
                height: 40,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 170,
                child: TextField(
                  onSubmitted: (value) => updateTitle(),
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
                        left: 10,
                      )),
                ),
              )
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.grey.shade800,
              width: 0.1,
            )),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                onPressed: () {},
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                ),
                label: const Text('Share')),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            quill.QuillToolbar.basic(controller: _quillController!),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.height * 0.8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: quill.QuillEditor.basic(
                    controller: _quillController!,
                    readOnly: false, // true for view only mode
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
