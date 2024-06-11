import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService extends GetxController {
  final WebSocketChannel channel;
  var message = ''.obs;

  WebSocketService(this.channel) {
    _listen();
  }

  void _listen() {
    channel.stream.listen((data) {
      final decodedData = jsonDecode(data);
      message.value = decodedData['message'];
    });
  }

  void sendMessage(String message) {
    channel.sink.add(jsonEncode({'message': message}));
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }
}
