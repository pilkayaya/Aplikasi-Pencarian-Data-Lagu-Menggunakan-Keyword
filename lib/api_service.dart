import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/lagu_response.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<ProductResponse?> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/data.php'));
      debugPrint('GET Product : ${response.body}');

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<ProductResponse?> searchLagu(String query) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/search_data.php/?keyword=$query'));
      debugPrint('GET Search Lagu : ${response.body}');

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
