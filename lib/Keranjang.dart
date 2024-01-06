import 'package:flutter/material.dart';


class CartItem {
  String productName;
  int quantity;
  int price;
  bool isSelected;

  CartItem({
    required this.productName,
    required this.quantity,
    required this.price,
    this.isSelected = false,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Keranjang(),
    );
  }
}

class Keranjang extends StatefulWidget {
  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  int number = 1;
  List<CartItem> cartItems = [
    CartItem(productName: 'Pempek', quantity: 1, price: 10000),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  CartItem item = cartItems[index];

                  return ListTile(
                    leading: Image.asset('assets/product/pempek.png'), 
                    title: Text(item.productName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              item.quantity = item.quantity > 1 ? item.quantity - 1 : 1;
                            });
                          },
                        ),
                        Text('${item.quantity}'), 
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                        ),
                        Checkbox(
                          value: item.isSelected,
                          onChanged: (value) {
                            setState(() {
                              item.isSelected = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    subtitle: Text('Rp. ${item.price * item.quantity}'), 
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total Pesanan'),
                  Text('Rp. ${calculateTotalPrice()}'), 
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Pesan Sekarang'),
              onPressed: () {
              
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown, 
                onPrimary: Colors.white, 
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateTotalPrice() {
    int totalPrice = 0;
    for (var item in cartItems) {
      if (item.isSelected) {
        totalPrice += item.price * item.quantity;
      }
    }
    return totalPrice;
  }
}

