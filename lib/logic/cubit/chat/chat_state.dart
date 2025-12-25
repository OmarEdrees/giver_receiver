abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<dynamic> messages;
  final bool isClosed;
  final bool isReported;
  ChatLoaded(this.messages, this.isClosed, this.isReported);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}