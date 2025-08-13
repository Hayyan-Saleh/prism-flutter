import 'dart:async';

import 'package:prism/features/live-stream/data/models/chat_message_model.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketIOService {
  io.Socket? _socket;
  final StreamController<ChatMessageEntity> _messageController =
      StreamController<ChatMessageEntity>.broadcast();
  final StreamController<int> _viewsController = StreamController<int>.broadcast();
  final StreamController<void> _streamEndedController =
      StreamController<void>.broadcast();

  Stream<ChatMessageEntity> get messages => _messageController.stream;
  Stream<int> get views => _viewsController.stream;
  Stream<void> get streamEnded => _streamEndedController.stream;

  void _initSocket(String serverUrl) {
    if (_socket == null) {
      _socket = io.io(serverUrl, <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
      });

      _socket!.on('chatMessage', (data) {
        _messageController.add(ChatMessageModel.fromJson(data['message']));
      });

      _socket!.on('views', (data) {
        _viewsController.add(data as int);
      });

      _socket!.on('stream-ended', (data) {
        _streamEndedController.add(null);
      });

      _socket!.onConnectError((error) {
        _messageController.addError(error);
        _viewsController.addError(error);
      });

      _socket!.on('error', (error) {
        _messageController.addError('Error from server: $error');
      });

      _socket!.onDisconnect((_) {
      });
    }
  }

  Future<void> connect(String serverUrl, String streamKey) async {
    _initSocket(serverUrl);

    if (!_socket!.connected) {
      _socket!.connect();
    }

    _socket!.off('connect'); // Remove previous listener
    _socket!.on('connect', (_) {
      _socket!.emit('joinRoom', streamKey);
    });
  }

  ChatMessageModel sendMessage(String streamKey, ChatMessageModel message) {
    final payload = {'streamKey': streamKey, 'message': message.toJson()};
    _socket!.emit('chatMessage', payload);
    return message;
  }

  void disconnect(String streamKey) {
    if (_socket != null) {
      _socket!.disconnect();
    }
  }
}