import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/model/orders.dart';
import 'package:mad/screen/cart_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final dynamic product;

  const BookDetailScreen({super.key, required this.product});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {

  final orderController = Get.find<OrderController>();

  Future<void> _orderProcess() async {
    final product = widget.product;

    final orderItem = Orders(
      bookId: product['id'],
      qty: 1,
      amount: product['price'],
      phoneNumber: "01234567",
      discount: 0,
      totalAmount: product['price'],
    );

    orderController.orderList.add(orderItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text("Book Detail"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(
                        product['image'],
                        height: 300,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          5,
                              (i) => const Icon(Icons.star, color: Colors.amber),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        product['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "\$${product['price']}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(product['description'] ?? "No description"),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3051A0),
                    ),
                    onPressed: _orderProcess,
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}