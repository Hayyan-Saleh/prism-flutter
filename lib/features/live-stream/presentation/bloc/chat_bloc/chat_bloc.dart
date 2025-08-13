import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';
import 'package:prism/features/live-stream/domain/use-cases/connect_to_chat_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/disconnect_from_chat_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_chat_messages_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_stream_ended_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_views_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/send_chat_message_use_case.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ConnectToChatUseCase _connectToChatUseCase;
  final DisconnectFromChatUseCase _disconnectFromChatUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  final GetViewsUseCase _getViewsUseCase;
  final GetStreamEndedUseCase _getStreamEndedUseCase;

  final List<ChatMessageEntity> _messages = [];
  int _views = 0;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _viewsSubscription;
  StreamSubscription? _streamEndedSubscription;

  ChatBloc({
    required ConnectToChatUseCase connectToChatUseCase,
    required DisconnectFromChatUseCase disconnectFromChatUseCase,
    required SendChatMessageUseCase sendChatMessageUseCase,
    required GetChatMessagesUseCase getChatMessagesUseCase,
    required GetViewsUseCase getViewsUseCase,
    required GetStreamEndedUseCase getStreamEndedUseCase,
  }) : _connectToChatUseCase = connectToChatUseCase,
       _disconnectFromChatUseCase = disconnectFromChatUseCase,
       _sendChatMessageUseCase = sendChatMessageUseCase,
       _getChatMessagesUseCase = getChatMessagesUseCase,
       _getViewsUseCase = getViewsUseCase,
       _getStreamEndedUseCase = getStreamEndedUseCase,
       super(const ChatInitial()) {
    on<ConnectToChatEvent>(_handleConnectToChat);
    on<SendChatMessageEvent>(_handleSendChatMessage);
    on<DisconnectFromChatEvent>(_handleDisconnectFromChat);
    on<ChatMessageReceived>(_onChatMessageReceived);
    on<ViewsReceived>(_onViewsReceived);
    on<ChatErrorOccurred>(_onChatErrorOccurred);
    on<StreamEndedEvent>(_onStreamEnded);
  }

  void _onChatMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    _messages.insert(0, event.message);
    emit(ChatConnected(messages: List.unmodifiable(_messages), views: _views));
  }

  void _onViewsReceived(ViewsReceived event, Emitter<ChatState> emit) {
    _views = event.views;
    emit(ChatConnected(messages: List.unmodifiable(_messages), views: _views));
  }

  void _onChatErrorOccurred(ChatErrorOccurred event, Emitter<ChatState> emit) {
    emit(ChatError(error: event.error));
  }

  void _onStreamEnded(StreamEndedEvent event, Emitter<ChatState> emit) {
    emit(const ChatDisconnected());
  }

  Future<void> _handleConnectToChat(
    ConnectToChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatConnecting());
    await _connectToChatUseCase(event.streamKey);

    final messagesEither = _getChatMessagesUseCase();
    messagesEither.fold((failure) => emit(ChatError(error: failure.message)), (
      messagesStream,
    ) {
      _messageSubscription = messagesStream.listen(
        (message) => add(ChatMessageReceived(message)),
        onError: (error) => add(ChatErrorOccurred(error.toString())),
      );
    });

    final viewsEither = _getViewsUseCase();
    viewsEither.fold((failure) => emit(ChatError(error: failure.message)), (
      viewsStream,
    ) {
      _viewsSubscription = viewsStream.listen(
        (views) => add(ViewsReceived(views)),
        onError: (error) => add(ChatErrorOccurred(error.toString())),
      );
    });

    final streamEndedEither = _getStreamEndedUseCase();
    streamEndedEither.fold(
      (failure) => emit(ChatError(error: failure.message)),
      (streamEndedStream) {
        _streamEndedSubscription = streamEndedStream.listen(
          (_) => add(const StreamEndedEvent()),
          onError: (error) => add(ChatErrorOccurred(error.toString())),
        );
      },
    );
  }

  Future<void> _handleSendChatMessage(
    SendChatMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _sendChatMessageUseCase(
      event.streamKey,
      event.message,
    );
    result.fold((failure) => add(ChatErrorOccurred(failure.message)), (
      message,
    ) {
      _messages.insert(0, message);
      emit(
        ChatConnected(messages: List.unmodifiable(_messages), views: _views),
      );
    });
  }

  void _handleDisconnectFromChat(
    DisconnectFromChatEvent event,
    Emitter<ChatState> emit,
  ) {
    _disconnectFromChatUseCase(event.streamKey);
    _messages.clear();
    _messageSubscription?.cancel();
    _viewsSubscription?.cancel();
    _streamEndedSubscription?.cancel();
    _messageSubscription = null;
    _viewsSubscription = null;
    _streamEndedSubscription = null;
    emit(const ChatDisconnected());
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _viewsSubscription?.cancel();
    _streamEndedSubscription?.cancel();
    return super.close();
  }
}
