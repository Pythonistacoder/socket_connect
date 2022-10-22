// ignore_for_file: non_constant_identifier_names

import 'order_status.dart';

final Map<String, OrderStatus> availableOrderStatus = {
  "1001": OrderStatus(
    orderStatusAsInt: 1001,
    orderStatusAsString: "1001",
    message: "Order has been placed",
  ),
  "1002": OrderStatus(
    orderStatusAsInt: 1002,
    orderStatusAsString: "1002",
    message: "Broadcasted",
  ),
  "1003": OrderStatus(
    orderStatusAsInt: 1003,
    orderStatusAsString: "1003",
    message: "Order event has been expired",
  ),
  "1004": OrderStatus(
    orderStatusAsInt: 1004,
    orderStatusAsString: "1004",
    message: "Order has been accepted",
  ),
  "1005": OrderStatus(
    orderStatusAsInt: 1005,
    orderStatusAsString: "1005",
    message: "Order has been started",
  ),
  "1006": OrderStatus(
    orderStatusAsInt: 1006,
    orderStatusAsString: "1006",
    message: "Order has been changed",
  ),
  "1007": OrderStatus(
    orderStatusAsInt: 1007,
    orderStatusAsString: "1007",
    message: "Order has been extended",
  ),
  "1008": OrderStatus(
    orderStatusAsInt: 1008,
    orderStatusAsString: "1008",
    message: "Order has been cancelled",
  ),
  "1009": OrderStatus(
    orderStatusAsInt: 1009,
    orderStatusAsString: "1009",
    message: "Order has been completed",
  ),
  "1010": OrderStatus(
    orderStatusAsInt: 1010,
    orderStatusAsString: "1010",
    message: "Payment has been made",
  ),
  "1011": OrderStatus(
    orderStatusAsInt: 1011,
    orderStatusAsString: "1011",
    message: "Order payment has been verified",
  ),
};
