import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/model/orders.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final OrderController orderController =
  Get.find<OrderController>();

  double _total() {
    return orderController.orderList.fold(
      0.0,
          (sum, item) =>
      sum + ((item.amount ?? 0) * (item.qty ?? 0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: orderController.orderList.length,
              itemBuilder: (context, index) {

                final Orders m =
                orderController.orderList[index];

                return Card(
                  margin: const EdgeInsets.all(8),

                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/book2.png",
                      width: 50,
                    ),

                    title: Text("Order #${m.id ?? index}"),

                    subtitle: Text("Qty: ${m.qty}"),

                    trailing: Text(
                      "\$${((m.amount ?? 0) * (m.qty ?? 0)).toStringAsFixed(2)}",
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "\$${_total().toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),

                    onPressed: () {
                      orderController.orderList.clear();

                      Get.offAllNamed("/home");

                      Get.snackbar(
                        "Success",
                        "Order placed successfully",
                        snackPosition:
                        SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },

                    child: const Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}