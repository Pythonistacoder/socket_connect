import '../models/order_status.dart';

abstract class SocketState {}

class SocketRecieveDataState extends SocketState {
  final OrderStatus orderStatus;

  SocketRecieveDataState({
    required this.orderStatus,
  });
}

class SocketConnectedState extends SocketState {
  final String message;
  SocketConnectedState({required this.message});
}

class SocketDisconnectedState extends SocketState {
  final String message;
  SocketDisconnectedState({required this.message});
}

class SocketNullState extends SocketState {}

class SocketDataSentState extends SocketState {
  final OrderStatus orderStatus;
  SocketDataSentState({required this.orderStatus});
}
