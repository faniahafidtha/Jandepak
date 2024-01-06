import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MinumanItem extends StatefulWidget {
  final Map<String, dynamic> data;

  const MinumanItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _MinumanItemState createState() => _MinumanItemState();
}

class _MinumanItemState extends State<MinumanItem> {
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
          // Add any additional widgets or functionality here as needed.
        ],
      ),
    );
  }
}

class MinumanPage extends StatefulWidget {
  @override
  _MinumanPageState createState() => _MinumanPageState();
}

class _MinumanPageState extends State<MinumanPage> {
  List<Map<String, dynamic>> daftarMinuman = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    var result = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: 'Minuman')
        .get();

    var products = result.docs.map((doc) => doc.data()).toList();

    setState(() {
      daftarMinuman = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minuman'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: daftarMinuman.length,
        itemBuilder: (context, index) {
          return MinumanItem(
            data: daftarMinuman[index],
          );
        },
      ),
    );
  }
}
