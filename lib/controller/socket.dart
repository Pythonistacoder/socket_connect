// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/available_order_status.dart';
import '../models/order_status.dart';
import '../socket_bloc/socket_event.dart';

class Socket {
  static const String WEBSOCKETURI =
      'ws://spark-orders.herokuapp.com/order?userId';

  final String servicemanId;
  Socket({required this.servicemanId});

  WebSocketChannel? channel;

  void openConnection() async {
    closeConnection();
    channel = IOWebSocketChannel.connect("$WEBSOCKETURI=$servicemanId");
  }

  /// recieves the data from stream channel and transforms it into
  /// the desired SocketRecieveDataEvent
  Stream<SocketRecieveDataEvent> getOrderStatusStream() async* {
    if (channel != null) {
      final Stream<dynamic> socketStream = channel!.stream;
      await for (final event in socketStream) {
        Map<String, dynamic> orderData = json.decode(event);
        print(orderData.toString());
        OrderStatus? orderStatus =
            availableOrderStatus[orderData["status"]["statusCode"].toString()];
        if (orderStatus == null) {
          throw Exception("no data");
        }

        yield SocketRecieveDataEvent(
          orderStatus: OrderStatus(
            orderStatusAsInt: orderStatus.orderStatusAsInt,
            orderStatusAsString: orderStatus.orderStatusAsString,
            message: orderStatus.message,
            senderId: orderData["senderId"],
            orderId: orderData["orderId"],
          ),
        );
      }
    } else {
      throw Exception("No channel present");
    }
  }

  void sendOrderStatus(
    OrderStatus orderStatus,
  ) {
    final data = {
      "orderId": orderStatus.orderId,
      "statusCode": orderStatus.orderStatusAsString,
      "receivers": [
        orderStatus.senderId,
        orderStatus.receiverId,
      ],
      "extra": {},
    };
    channel!.sink.add(json.encode(data));
  }

  void closeConnection() async {
    await channel?.sink.close();
  }

  // {
  //   "orderId" : "62c99e80c2d8831ddf2bac96",
  //   "statusCode" : "1009",
  //   "receivers" : [
  //     "62c92efb26bc7b45acab794a"
  //   ],
  //   "extra" : {
  //     "name" : "Server"
  //   }
  // }
}
