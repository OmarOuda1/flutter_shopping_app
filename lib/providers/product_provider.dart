import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data
            .map((item) => Product.fromJson(item))
            .where((p) => p.category.contains('clothing') || p.category == 'electronics')
            .toList();
      }
    } catch (e) {
      print('Error fetching products: \$e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
