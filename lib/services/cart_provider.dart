import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Ensures ChangeNotifier is available
import 'dart:convert';

import 'package:flutter/material.dart'; // ✅ Asegura que esta importación está presente

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _carrito = [];

  List<Map<String, dynamic>> get carrito => List.unmodifiable(_carrito);

  Future<void> cargarCarrito() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? carritoGuardado = prefs.getString('carrito');
    if (carritoGuardado != null) {
      _carrito.clear();
      _carrito.addAll(List<Map<String, dynamic>>.from(jsonDecode(carritoGuardado)));
      notifyListeners(); // ✅ Asegura que la UI refleje los productos guardados
    }
  }

  Future<void> guardarCarrito() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('carrito', jsonEncode(_carrito));
  }

  void agregarProducto(Map<String, dynamic> producto) {
    _carrito.add(producto);
    notifyListeners();
    guardarCarrito(); // ✅ Guarda los productos en almacenamiento persistente
  }

  void eliminarProducto(int index) {
    if (index >= 0 && index < _carrito.length) {
      _carrito.removeAt(index);
      notifyListeners();
      guardarCarrito();
    }
  }

  void vaciarCarrito() {
    if (_carrito.isNotEmpty) {
      _carrito.clear();
      notifyListeners();
      guardarCarrito();
    }
  }

  double calcularTotal() {
    return _carrito.fold(0.0, (total, producto) =>
        total + ((producto['precio'] ?? 0.0) * (producto['cantidad'] ?? 1.0)));
  }
}
// The duplicate CartProvider class definition has been removed.