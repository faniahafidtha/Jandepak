import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MakananItem extends StatefulWidget {
  final Map<String, dynamic> data;

  const MakananItem({
    Key? key,
    required this.data,
    required this.onAddToCart,
  }) : super(key: key);

  final Function(Map<String, dynamic>) onAddToCart;

  @override
  _MakananItemState createState() => _MakananItemState();
}

class _MakananItemState extends State<MakananItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              widget.data['imageUrl'],
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.data['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Harga: ${widget.data['price']}',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Stok: ${widget.data['stock']}',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.brown,
            onPressed: () => widget.onAddToCart(widget.data),
          ),
        ],
      ),
    );
  }
}

class MakananPage extends StatefulWidget {
  @override
  _MakananPageState createState() => _MakananPageState();
}

class _MakananPageState extends State<MakananPage> {
  List<Map<String, dynamic>> daftarMakanan = [];
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    var result = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: 'Makanan')
        .get();

    var products = result.docs.map((doc) => doc.data()).toList();

    setState(() {
      daftarMakanan = products;
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Makanan'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _navigateToCart,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: daftarMakanan.length,
        itemBuilder: (context, index) {
          return MakananItem(
            data: daftarMakanan[index],
            onAddToCart: _addToCart,
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index]['name']),
            trailing: Text('Harga: ${cartItems[index]['price']}'),
          );
        },
      ),
    );
  }
}
