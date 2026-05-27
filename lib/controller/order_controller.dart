import 'package:get/get.dart';
import 'package:mad/model/orders.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var orderList = <Orders>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    isLoading(true);
    Future.delayed(const Duration(seconds: 1), () {
      // Example: Setting dummy data with prices
      orderList.assignAll([
        Orders(bookId: 1, qty: 1, amount: 15.0), // Price set to 15.0
        Orders(bookId: 2, qty: 2, amount: 25.5), // Price set to 25.5
      ]);
      isLoading(false);
    });
  }

  void increaseQty(int index) {
    var order = orderList[index];
    order.qty = (order.qty ?? 0) + 1;
    orderList[index] = order; // Trigger RxList update
  }

  void decreaseQty(int index) {
    var order = orderList[index];
    if ((order.qty ?? 0) > 1) {
      order.qty = (order.qty ?? 0) - 1;
      orderList[index] = order; // Trigger RxList update
    }
  }

  // Fixed: Initial value should be 0.0 (double) to avoid type errors with double amount
  double get subTotal => orderList.fold(0.0, (sum, item) => sum + ((item.amount ?? 0) * (item.qty ?? 0)));
}
