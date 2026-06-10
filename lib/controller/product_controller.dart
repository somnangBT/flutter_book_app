import 'package:get/get.dart';
import '../service/product_service.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var products = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading(true);

      final product = await ProductService.instance.getProducts();
      products.assignAll(product);

    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}