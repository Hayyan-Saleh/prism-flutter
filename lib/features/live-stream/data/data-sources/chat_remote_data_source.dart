import 'package:prism/features/live-stream/data/models/chat_message_model.dart';
import 'package:prism/features/live-stream/data/services/socket_io_service.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';
import '../../../../../core/util/sevices/api_endpoints.dart';

abstract class ChatRemoteDataSource {
  void connect(String streamKey);
  void disconnect(String streamKey);
  ChatMessageEntity sendMessage(String streamKey, ChatMessageEntity message);
  Stream<ChatMessageEntity> get messages;
  Stream<int> get views;
  Stream<void> get streamEnded;
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SocketIOService socketIOService;

  ChatRemoteDataSourceImpl({required this.socketIOService});

  @override
  Future<void> connect(String streamKey) async {
    await socketIOService.connect(ApiEndpoints.liveStreamSocketUrl, streamKey);
  }

  @override
  void disconnect(String streamKey) {
    socketIOService.disconnect(streamKey);
  }

  @override
  ChatMessageEntity sendMessage(String streamKey, ChatMessageEntity message) {
    final messageModel = ChatMessageModel(
      id: message.id,
      name: message.name,
      avatar: message.avatar,
      text: message.text,
    );
    return socketIOService.sendMessage(streamKey, messageModel);
  }

  @override
  Stream<ChatMessageEntity> get messages => socketIOService.messages;

  @override
  Stream<int> get views => socketIOService.views;

  @override
  Stream<void> get streamEnded => socketIOService.streamEnded;
}
