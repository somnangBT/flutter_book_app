import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/data/shared_pref_manager.dart';
import 'package:mad/screen/book_detail_screen.dart';
import 'package:badges/badges.dart' as badges;

import '../controller/product_controller.dart';
import '../service/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _fullName = "Guest";
  final orderController = Get.put(OrderController());



  final List<String> categories = [
    "All",
    "ប្រលោមលោក",
    "បច្ចេកវិទ្យា",
    "សាសនា"
  ];

  final productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _loadUsername();

  }



  Future<void> _loadUsername() async {
    final pref = SharedPrefManager();
    final name = await pref.getSharedPref("fullName");
    setState(() => _fullName = name ?? "");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ───── APP BAR ─────
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $_fullName 👋",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Find your next book",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          badges.Badge(
            badgeContent: Obx(
                  () => Text(
                "${orderController.orderList.length}",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            child: const Icon(Icons.shopping_cart, color: Colors.black),
          ),
          const SizedBox(width: 12),
        ],
      ),

      // ───── BODY ─────
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // SEARCH
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search books...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CATEGORY
          const Text(
            "Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(categories[i]),
                    backgroundColor: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // BOOKS SECTION
          sectionTitle("Popular Books"),
          const SizedBox(height: 10),

          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, i) {
                return bookCard(i);
              },
            ),
          ),

          const SizedBox(height: 20),

          sectionTitle("New Arrival"),
          const SizedBox(height: 10),
          const SizedBox(height: 20),

          sectionTitle("Products from API"),
          const SizedBox(height: 10),

          // Get Product From API

          Obx(() {
            if (productController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product = productController.products[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            product['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            product['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          "\$${product['price']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, i) {
                return bookCard(i);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ───── WIDGETS ─────

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }



  Widget bookCard(int i) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailScreen(
              product: {
                "id": i,
                "title": "Book ${i + 1}",
                "image": "assets/images/book${i + 1}.png",
                "price": 10 * (i + 1),
              },
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                "assets/images/book${i + 1}.png",
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Book ${i + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

}