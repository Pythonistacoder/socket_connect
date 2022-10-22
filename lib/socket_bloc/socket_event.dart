import '../models/order_status.dart';

abstract class SocketEvent {}

class SocketConnectEvent extends SocketEvent {}

class SocketSendDataEvent extends SocketEvent {
  final OrderStatus orderStatus;

  SocketSendDataEvent({
    required this.orderStatus,
  });
}

class SocketRecieveDataEvent extends SocketEvent {
  final OrderStatus orderStatus;

  SocketRecieveDataEvent({
    required this.orderStatus,
  });
}

class SocketDisconnectEvent extends SocketEvent {}
