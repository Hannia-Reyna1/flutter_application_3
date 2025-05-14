import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';

class Product {
  final String nombre;
  final double precio;
  final String imagen;

  Product({required this.nombre, required this.precio, required this.imagen});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'nombre': nombre,
        'precio': precio,
        'imagen': imagen,
      };
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  final List<Product> carrito = [];

  void _agregarAlCarrito(Product producto) {
    setState(() {
      carrito.add(producto);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${producto.nombre} añadido al carrito')),
    );
  }

  void _abrirCarrito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const CartScreen(), // ✅ Eliminamos el parámetro `carrito`
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> productos = [
      Product(nombre: 'Termo Azul', precio: 250.0, imagen: 'assets/images/azul.png'),
      Product(nombre: 'Termo Rojo', precio: 230.0, imagen: 'assets/images/rojo.jpg'),
      Product(nombre: 'Termo Verde', precio: 260.0, imagen: 'assets/images/verde.jpg'),
      Product(nombre: 'Termo Cafe', precio: 250.0, imagen: 'assets/images/cafe.jpg'),
      Product(nombre: 'Termo Negro', precio: 230.0, imagen: 'assets/images/negro.jpg'),
      Product(nombre: 'Termo Rosa', precio: 260.0, imagen: 'assets/images/rosa.jpg'),
      Product(nombre: 'Termo Amarillo', precio: 250.0, imagen: 'assets/images/amarillo.jpg'),
      Product(nombre: 'Termo Morado', precio: 230.0, imagen: 'assets/images/morado.jpg'),
      Product(nombre: 'Termo Naranja', precio: 260.0, imagen: 'assets/images/naranja.jpg'),
      Product(nombre: 'Termo Tornasol', precio: 250.0, imagen: 'assets/images/tornasolch.jpg'),
      Product(nombre: 'Termo Personalizado', precio: 230.0, imagen: 'assets/images/personalisadoNom.jpg'),
      Product(nombre: 'Termo Flores', precio: 260.0, imagen: 'assets/images/flores.jpg'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _abrirCarrito,
              ),
              if (carrito.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('${carrito.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (BuildContext context, int index) {
          final Product producto = productos[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: Image.asset(
                producto.imagen,
                width: 60,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.red),
              ),
              title: Text(producto.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text('\$${producto.precio} MXN', style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
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