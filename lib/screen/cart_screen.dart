import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/model/orders.dart';
import 'package:mad/screen/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final OrderController orderController = Get.find<OrderController>();

  bool isShipping = true;

  double _calculateSubTotal() {
    return orderController.orderList.fold(
      0.0,
      (sum, item) => sum + ((item.amount ?? 0) * (item.qty ?? 0)),
    );
  }

  double _calculateVat() {
    return _calculateSubTotal() * 0.10;
  }

  double _calculateTotal() {
    return _calculateSubTotal() + _calculateVat() + (isShipping ? 5.0 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text("Cart"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Obx(() {
          if (orderController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderController.orderList.isEmpty) {
            return const Center(
              child: Text("No Items in Cart", style: TextStyle(fontSize: 18)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: orderController.orderList.length,

                  itemBuilder: (context, index) {
                    final Orders m = orderController.orderList[index];

                    return Dismissible(
                      key: UniqueKey(),

                      direction: DismissDirection.endToStart,

                      background: Container(
                        color: Colors.redAccent,

                        alignment: Alignment.centerRight,

                        padding: const EdgeInsets.only(right: 20),

                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      onDismissed: (direction) {
                        orderController.orderList.remove(m);

                        Get.snackbar(
                          "Removed",
                          "Item removed from cart",

                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },

                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(12),

                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/book2.png",

                                width: 60,
                                height: 90,

                                fit: BoxFit.cover,

                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.book, size: 50);
                                },
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "Order #${m.id ?? index}",

                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      "\$${m.amount}",

                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            orderController.decreaseQty(index);
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),

                                        Text(
                                          "${m.qty}",

                                          style: const TextStyle(fontSize: 18),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            orderController.increaseQty(index);
                                          },

                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              _buildOrderSummary(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [
          Card(
            elevation: 3,

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  _buildSummaryRow(
                    "Sub-Total",
                    "\$ ${_calculateSubTotal().toStringAsFixed(2)}",
                  ),

                  _buildSummaryRow(
                    "VAT (10%)",
                    "\$ ${_calculateVat().toStringAsFixed(2)}",
                  ),

                  _buildSummaryRow("Shipping Fee", "\$ ${isShipping ? 5 : 0}"),

                  const Divider(),

                  _buildSummaryRow(
                    "Total",
                    "\$ ${_calculateTotal().toStringAsFixed(2)}",
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 50,
            width: double.infinity,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),

              // NAVIGATE TO CHECKOUT SCREEN
              onPressed: () {
                if (orderController.orderList.isEmpty) {
                  Get.snackbar(
                    "Cart Empty",
                    "Please add items to cart",

                    snackPosition: SnackPosition.BOTTOM,

                    backgroundColor: Colors.redAccent,

                    colorText: Colors.white,
                  );

                  return;
                }

                Get.to(() => CheckoutScreen());
              },

              child: const Text(
                "Checkout",

                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            label,

            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          Text(
            value,

            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
