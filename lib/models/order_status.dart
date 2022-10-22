class OrderStatus {
  final String orderStatusAsString;
  final int orderStatusAsInt;
  final String message;
  String? senderId;
  String? receiverId;
  String? orderId;

  OrderStatus({
    required this.orderStatusAsInt,
    required this.orderStatusAsString,
    required this.message,
    this.receiverId,
    this.senderId,
    this.orderId,
  });

  /// This return all values as Json
  /// the format is {
  /// "stringStatus":value,
  /// "intStatus": value,
  /// "message":value,
  /// "senderId":value,
  /// "receiverId":value
  /// }
  Map<String, dynamic> getJson() {
    return {
      "stringStatus": orderStatusAsString,
      "intStatus": orderStatusAsInt,
      "message": message,
      "senderId": senderId,
      "recieverId": receiverId,
      "orderId": orderId
    };
  }
}
