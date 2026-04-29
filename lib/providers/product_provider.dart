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
      } else {
        print('FakeStoreAPI failed with status: \${response.statusCode}, falling back to mock data');
        _fallbackToMockData();
      }
    } catch (e) {
      print('Error fetching products: \$e');
      _fallbackToMockData();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _fallbackToMockData() {
    _products = [
      Product(
        id: 1,
        title: "Fjallraven - Foldsack No. 1 Backpack",
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
      ),
      Product(
        id: 2,
        title: "Mens Casual Premium Slim Fit T-Shirts",
        price: 22.3,
        description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing.",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
      ),
      Product(
        id: 9,
        title: "WD 2TB Elements Portable External Hard Drive - USB 3.0",
        price: 64,
        description: "USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7",
        category: "electronics",
        image: "https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg",
      ),
      Product(
        id: 10,
        title: "SanDisk SSD PLUS 1TB Portable External Hard Drive",
        price: 109,
        description: "Easy and simple to use, plug and play, Fast data transfers with USB 3.0. Up to 1TB capacities to hold your digital life",
        category: "electronics",
        image: "https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg",
      ),
    ];
  }
}
