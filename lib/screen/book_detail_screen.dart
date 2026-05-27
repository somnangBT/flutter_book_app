import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/model/orders.dart';
import 'package:mad/screen/cart_screen.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  // Use Get.find because OrderController is initialized globally in main.dart
  final orderController = Get.find<OrderController>();

  Future<void> _orderProcess() async {
    final orderItem = Orders(
        bookId: 1,
        qty: 1,
        amount: 2.0,
        phoneNumber: "01234567",
        discount: 0,
        totalAmount: 2);
    
    orderController.orderList.add(orderItem);
    
    const snackBar = SnackBar(
      content: Text("Order success"),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final bookImage = SizedBox(
      height: 300,
      child: Center(
        child: Image.asset(
          "assets/images/book2.png",
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => 
              const Icon(Icons.book, size: 100, color: Colors.grey),
        ),
      ),
    );

    List<Widget> star = List.generate(5, (i) {
      return const Icon(Icons.star, color: Colors.amber);
    }).toList();

    final rateStateRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: star,
    );

    const bookTitle = Text(
      "កម្រងគតិបណ្ឌិត",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
    const author = Text("គឹម ពេជ្រពីរនន់");

    const description = Text(
      "រាប់ពាន់ឆ្នាំមកហើយដែលបុព្វបុរសជាច្រើនធ្លាប់បានរៀនសូត្រ ទទួលបទពិសោធផ្ទាល់ខ្លួន ឬត្រិះរិះពិចារណារកឃើញសច្ចភាពដ៏មានតម្លៃផ្សេងៗនិងបានចងក្រងនូវអ្វីដែលខ្លួនបានរកឃើញទាំងនោះដើម្បីទុកជាប្រយោជន៍ដល់អនុជនជំនាន់ក្រោយ។",
    );

    final addToCartButton = Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3051A0)),
          onPressed: _orderProcess,
          child: const Text(
            "Add to Cart",
            style: TextStyle(color: Colors.white, fontFamily: 'KantumruyPro'),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text("Book Detail"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to CartScreen
              Get.to(() => const CartScreen());
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      bookImage,
                      rateStateRow,
                      bookTitle,
                      author,
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("ពិពណ៌នា", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 4),
                      description,
                    ],
                  ),
                ),
              ),
              addToCartButton,
            ],
          ),
        ),
      ),
    );
  }
}
