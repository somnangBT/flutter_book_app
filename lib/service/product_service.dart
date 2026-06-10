import 'dart:convert';



import 'package:http/http.dart' as http;

    class ProductService {
      static final ProductService instance = ProductService._init();
      ProductService._init();

      Future<List<dynamic>> getProducts() async {

        String apiUrl = "https://fakestoreapi.com/products";
        final header ={
          "Content-Type": "application/json"
        };
        final response = await http.get(Uri.parse(apiUrl), headers: header);
        if(response.statusCode == 200){
          final data = jsonDecode(response.body) as List<dynamic>;
          print("data :$data");
          return data;
        }else{
          print(response.statusCode);
          throw("Inter error");
        }

        }
      }




