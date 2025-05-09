import 'package:flutter/material.dart'; // Ensure this import is present
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cart_screen.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Removed duplicate _HomeScreenState class definition
  class _HomeScreenState extends State<HomeScreen> {
    User? user = FirebaseAuth.instance.currentUser; // ✅ Ahora se actualizará dinámicamente
    final List<Map<String, dynamic>> carrito = <Map<String, dynamic>>[];
  
    @override
    void initState() {
      super.initState();
      FirebaseAuth.instance.authStateChanges().listen((User? usuario) {
        setState(() {
          user = usuario; // ✅ Se actualiza automáticamente al iniciar/cerrar sesión
        });
      });
    }
  
// ✅ Guarda el carrito en almacenamiento persistente
void guardarCarrito() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('carrito', jsonEncode(carrito));
}

// ✅ Carga el carrito al iniciar la app
void cargarCarrito() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? carritoGuardado = prefs.getString('carrito');

  if (carritoGuardado != null) {
    setState(() {
      carrito.clear();
      carrito.addAll(List<Map<String, dynamic>>.from(jsonDecode(carritoGuardado)));
    });
  }
}

// ✅ Modifica `_verCarrito()` para siempre usar los datos actualizados
void _verCarrito() {
  cargarCarrito(); // ✅ Asegura que el carrito tenga la última versión guardada

  if (carrito.isNotEmpty) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => CartScreen(carrito: carrito)),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ El carrito está vacío')));
  }
}

// ✅ Modifica `vaciarCarrito()` para eliminar el carrito también en almacenamiento persistente
void vaciarCarrito() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  setState(() {
    carrito.clear();
  });

  prefs.remove('carrito'); // ✅ Elimina la versión guardada del carrito
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Carrito vacío')));
}
  void _abrirAuthScreen() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => AuthScreen()),
    );
  }

  void _abrirProfileScreen() {
    if (user != null) {
      Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => ProfileScreen()));
    } else {
      _abrirAuthScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
  title: const Text('Venta de Termos'),
  actions: <Widget>[
    if (user == null) // ✅ Icono de registro aparece solo si el usuario NO ha iniciado sesión
      IconButton(icon: const Icon(Icons.person_add), onPressed: _abrirAuthScreen),
    if (user != null) // ✅ Icono de perfil aparece solo si el usuario ha iniciado sesión
      IconButton(icon: const Icon(Icons.person), onPressed: _abrirProfileScreen),
    Stack(
      children: <Widget>[
        IconButton(icon: const Icon(Icons.shopping_cart), onPressed: _verCarrito),
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
      body: Column(
        children: <Widget>[
          _mostrarCarrusel(),
          const SizedBox(height: 10),
          Expanded(child: _mostrarProductos()),
        ],
      ),
    );
  }

  Widget _mostrarCarrusel() {
    final List<String> imagenesCarrusel = <String>[
      'assets/images/carrusel1.jpg',
      'assets/images/carrusel2.jpg',
      'assets/images/carrusel3.jpg',
    ];

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text('Online Thermos', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 163, 26, 201))),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          items: imagenesCarrusel.map((String imgPath) {
            return Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.contain),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _agregarAlCarrito(Map<String, dynamic> producto) {
    setState(() {
      carrito.add(producto);
    });
    guardarCarrito(); // Save the updated cart persistently
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${producto['nombre']} añadido al carrito')));
  }

  Widget _mostrarProductos() {
    final List<Map<String, dynamic>> productos = <Map<String, dynamic>>[
      <String, dynamic>{'nombre': 'Termo Azul', 'precio': 250.0, 'imagen': 'assets/images/azul.png', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Rojo', 'precio': 230.0, 'imagen': 'assets/images/rojo.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Verde', 'precio': 260.0, 'imagen': 'assets/images/verde.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Cafe', 'precio': 250.0, 'imagen': 'assets/images/cafe.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Negro', 'precio': 230.0, 'imagen': 'assets/images/negro.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Rosa', 'precio': 260.0, 'imagen': 'assets/images/rosa.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Amarillo', 'precio': 250.0, 'imagen': 'assets/images/amarillo.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Morado', 'precio': 230.0, 'imagen': 'assets/images/morado.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Naranja', 'precio': 260.0, 'imagen': 'assets/images/naranja.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Tornasol', 'precio': 250.0, 'imagen': 'assets/images/tornasolch.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Personalizados', 'precio': 230.0, 'imagen': 'assets/images/personalisadoNom.jpg', 'cantidad': 1},
      <String, dynamic>{'nombre': 'Termo Flores', 'precio': 260.0, 'imagen': 'assets/images/flores.jpg', 'cantidad': 1},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // ✅ Muestra 3 productos por fila
        crossAxisSpacing: 8, // ✅ Espaciado horizontal entre productos
        mainAxisSpacing: 8, // ✅ Espaciado vertical entre filas
        childAspectRatio: 0.85, // ✅ Ajuste proporcional de cada producto
      ),
      itemCount: productos.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> producto = productos[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  producto['imagen']!,
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Icon(Icons.image_not_supported, color: Colors.red);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: <Widget>[
                    Text(producto['nombre']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('\$${producto['precio']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              ElevatedButton(onPressed: () => _agregarAlCarrito(producto), child: const Text('Añadir al carrito')),
            ],
          ),
        );
      },
    );
  }
}