// ignore_for_file: use_rethrow_when_possible, avoid_print

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders {
    return [..._orders];
  }

  final String token;
  final String userId;

  OrdersProvider(
    this.token,
    this.userId,
    this._orders,
  );

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        "https://shop-app-cb3a6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token");
    final response = await http.get(url);
    final List<OrderModel> loadedData = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedData.add(
        OrderModel(
          id: orderId,
          amount: orderData["amount"],
          products: (orderData["products"] as List<dynamic>)
              .map((item) => CartModel(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"]))
              .toList(),
          dateTime: DateTime.parse(orderData["dateTime"]),
        ),
      );
    });
    _orders = loadedData.reversed.toList();

    notifyListeners();
  }

  Future<void> addOrder(List<CartModel> cartProducts, double total) async {
    final url = Uri.parse(
        "https://shop-app-cb3a6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token");
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderModel(
          id: json.decode(response.body)["name"],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
