library socket_connect;

import 'dart:async';

import 'package:fixpals_internet_connectivity/blocs/internet_bloc/internet_states.dart';
import 'package:fixpals_internet_connectivity/fixpals_internet_connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controller/socket.dart';
import 'enums/client_type.dart';
import 'models/available_order_status.dart';
import 'models/order_status.dart';
import 'socket_bloc/socket_event.dart';
import 'socket_bloc/socket_states.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  Socket? socket;
  final String userId;
  final ClientType clientType;

  bool isConnected = false;
  InternetConnectivityBloc internetBloc;

  StreamSubscription? _socketRecieveDataSubscription;
  StreamSubscription? _internetConnectivitySubscription;

  SocketBloc({
    required this.userId,
    required this.internetBloc,
    required this.clientType,
  }) : super(
          SocketDisconnectedState(
            message: "Socket disconnected",
          ),
        ) {
    on<SocketConnectEvent>(
      (event, emit) {
        socket = Socket(servicemanId: userId);
        socket?.openConnection();
        isConnected = true;
        if (_socketRecieveDataSubscription != null) {
          _socketRecieveDataSubscription?.cancel();
        }
        _socketRecieveDataSubscription = socket?.getOrderStatusStream().listen(
          (socketDataRecieveEvent) {
            socketDataRecieveEvent.orderStatus.receiverId = userId;
            add(socketDataRecieveEvent);
          },
        );
        emit(
          SocketConnectedState(
            message: "Socket connected",
          ),
        );
      },
    );

    on<SocketDisconnectEvent>(
      (event, emit) {
        if (socket != null) {
          socket!.closeConnection();
          socket = null;
          isConnected = false;
          emit(
            SocketDisconnectedState(
              message: "Socket Disconnected",
            ),
          );
        } else {
          emit(
            SocketNullState(),
          );
        }
      },
    );

    on<SocketSendDataEvent>(
      (event, emit) {
        if (socket != null) {
          event.orderStatus.senderId = userId;
          socket?.sendOrderStatus(event.orderStatus);
          emit(
            SocketDataSentState(orderStatus: event.orderStatus),
          );
        } else {
          emit(
            SocketNullState(),
          );
        }
      },
    );

    on<SocketRecieveDataEvent>(
      (event, emit) {
        if (socket != null) {
          emit(
            SocketRecieveDataState(orderStatus: event.orderStatus),
          );
          receiveOrderStatus(event.orderStatus);
        } else {
          emit(
            SocketNullState(),
          );
        }
      },
    );

    _internetConnectivitySubscription =
        internetBloc.stream.listen((internetState) {
      if (internetState is InternetRetrievedState) {
        add(SocketConnectEvent());
      } else if (internetState is InternetLostState) {
        add(SocketDisconnectEvent());
      }
    });
  }

  void receiveOrderStatus(OrderStatus recievedOrderStatus) {
    switch (recievedOrderStatus.orderStatusAsInt) {
      case 1001:
        if (clientType == ClientType.serviceman) {
          ///here the recievedOrderStatus has senderid the id of client
          ///and the recieverid of the current client
          ///this need to be reversed while sending the back with order status 1004
          OrderStatus orderStatus = availableOrderStatus["1004"]!;
          orderStatus.orderId = recievedOrderStatus.orderId;
          orderStatus.receiverId = recievedOrderStatus.senderId;
          orderStatus.senderId = userId;
          add(
            SocketSendDataEvent(
              orderStatus: orderStatus,
            ),
          );
        }
        break;
      default:
    }
  }

  void sendOrderStatus(OrderStatus orderStatus) {
    switch (orderStatus.orderStatusAsInt) {
      case 1001:
        break;
      default:
    }
  }

  @override
  Future<void> close() {
    _socketRecieveDataSubscription?.cancel();
    _internetConnectivitySubscription?.cancel();
    return super.close();
  }
}
