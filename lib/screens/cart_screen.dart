import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  CartScreen({Key? key, required this.carrito}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> carrito;

  @override
  void initState() {
    super.initState();
    carrito = List<Map<String, dynamic>>.from(widget.carrito); // ✅ Mantiene los productos en el carrito
  }

  double _calcularTotal() {
    return carrito.fold(0.0, (double total, Map<String, dynamic> producto) =>
        total + ((producto['precio'] ?? 0) * (producto['cantidad'] ?? 1))); // ✅ Evita errores con valores `null`
  }

  void _eliminarProducto(int index) {
    setState(() {
      carrito.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('❌ Producto eliminado del carrito')),
    );
  }

  void _vaciarCarrito() {
    setState(() {
      carrito.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🛒 Carrito vacío')),
    );
  }

  void _procesarPago() {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user == null) { // ✅ Solo pide login al pagar, no antes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔒 Debes iniciar sesión para completar la compra.')),
      );
      Navigator.push<void>(context, MaterialPageRoute<void>(builder: (BuildContext context) => AuthScreen()));
    } else if (!user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📩 Verifica tu correo antes de comprar.')),
      );
      user.sendEmailVerification();
    } else {
      debugPrint('Procesando pago...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de Compras')),
      body: carrito.isEmpty
          ? const Center(child: Text('Tu carrito está vacío'))
          : ListView.builder(
              itemCount: carrito.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> producto = carrito[index];
                return Container(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: Image.asset(
                      producto['imagen']!,
                      width: 60,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return const Icon(Icons.error, size: 60);
                      },
                    ),
                    title: Text(producto['nombre']),
                    subtitle: Text("Cantidad: ${producto['cantidad'] ?? 1}"), // ✅ Muestra cantidad correctamente
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarProducto(index),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: carrito.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text('Total: \$${_calcularTotal()} MXN', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _vaciarCarrito,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Vaciar carrito'),
                      ),
                      ElevatedButton(
                        onPressed: _procesarPago, // ✅ Solo solicita login cuando se presiona
                        child: const Text('Pagar con Mercado Pago'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
}