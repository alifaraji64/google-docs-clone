import 'package:google_docs_clone/models/socket.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  void joinRoom(String roomId) {
    _socketClient.emit('join', roomId);
  }

  void typing(Map<String, dynamic> data) {
    _socketClient.emit('typing', data);
  }

  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient.on('changes', (data) {
      print('lohoooo');
      func(data);
    });
  }

  void autoSave(Map<String, dynamic> data) {
    _socketClient.emit('save', data);
  }
}
