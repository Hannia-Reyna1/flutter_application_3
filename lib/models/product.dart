import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final List<Map<String, dynamic>> carrito =
      <Map<String, dynamic>>[]; // ✅ Carrito global de productos

  void _agregarAlCarrito(Map<String, dynamic> producto) {
    setState(() {
      carrito.add(
        Map<String, dynamic>.from(producto),
      ); // ✅ Copia el producto para evitar referencias duplicadas
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${producto["nombre"]} añadido al carrito')),
    );
  }

  void _abrirCarrito() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder:
            (BuildContext context) =>
                CartScreen(carrito: carrito), // ✅ Envía el carrito completo
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> productos = <Map<String, dynamic>>[
      <String, dynamic>{
        'nombre': 'Termo Azul',
        'precio': 250.0,
        'imagen': 'assets/images/azul.png',
      },
      <String, dynamic>{
        'nombre': 'Termo Rojo',
        'precio': 230.0,
        'imagen': 'assets/images/rojo.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Verde',
        'precio': 260.0,
        'imagen': 'assets/images/verde.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Cafe',
        'precio': 250.0,
        'imagen': 'assets/images/cafe.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Negro',
        'precio': 230.0,
        'imagen': 'assets/images/negro.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Rosa',
        'precio': 260.0,
        'imagen': 'assets/images/rosa.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Amarillo',
        'precio': 250.0,
        'imagen': 'assets/images/amarillo.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Morado',
        'precio': 230.0,
        'imagen': 'assets/images/morado.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Naranja',
        'precio': 260.0,
        'imagen': 'assets/images/naranja.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Tornasol',
        'precio': 250.0,
        'imagen': 'assets/images/tornasolch.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Personalisados',
        'precio': 230.0,
        'imagen': 'assets/images/personalisadoNom.jpg',
      },
      <String, dynamic>{
        'nombre': 'Termo Flores',
        'precio': 260.0,
        'imagen': 'assets/images/flores.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _abrirCarrito,
              ),
              Positioned(
                right: 8,
                top: 8,
                child:
                    carrito.isNotEmpty
                        ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${carrito.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : const SizedBox(),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> producto = productos[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: Image.asset(
                producto['imagen']!,
                width: 60,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  return const Icon(
                    Icons.image_not_supported,
                    color: Colors.red,
                  );
                },
              ),
              title: Text(
                producto['nombre']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '\$${producto['precio']} MXN',
                style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
              ),
              trailing: ElevatedButton(
                onPressed: () => _agregarAlCarrito(producto),
                child: const Text('Añadir al carrito'),
              ),
            ),
          );
        },
      ),
    );
  }
}
