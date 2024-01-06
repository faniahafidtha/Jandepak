import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jandepak/EditProduk.dart';
import 'package:jandepak/Keranjang.dart';
import 'package:jandepak/LoginScreen.dart';
import 'package:jandepak/Profile.dart';
import 'package:jandepak/MakananPage.dart';
import 'package:jandepak/MinumanPage.dart';
import 'package:jandepak/TambahProduk.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar di tengah
                  Image.asset(
                    'assets/logo.png', // Ganti dengan path gambar Anda
                    width: 150, // Sesuaikan ukuran gambar sesuai keinginan
                    height: 135,
                  ),
                  // Teks di bagian bawah
                  // Text(
                  // 'JANDEPAK',
                  //style: TextStyle(
                  // color: Colors.white,
                  //fontSize: 20.0,
                  //fontWeight: FontWeight.bold,
                  //),
                  //),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Colors.black,
              ), // Icon for "Akun"
              title: Text('Akun'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ), // Icon for "Keranjang"
              title: Text('Keranjang'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Keranjang()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle,
                color: Colors.black,
              ), // Icon untuk menambahkan produk
              title: Text('Tambah Produk Baru'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.brown),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                print('bisa logut');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Kategori', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MakananPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/makanan.png',
                            width: 50, height: 50),
                        Text('Makanan'),
                      ],
                    )),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MinumanPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/minuman.png',
                            width: 50, height: 50),
                        Text('Minuman'),
                      ],
                    ))
              ],
            ),
            SizedBox(height: 30),
            Text('Rekomendasi Produk',
                style: Theme.of(context).textTheme.headline6),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .orderBy('name', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: snapshot.data!.docs[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final QueryDocumentSnapshot product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Map<String, dynamic> data = {};
  void navigateToEditProductPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProduk(
          product: widget.product,),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    data = widget.product.data() as Map<String, dynamic>;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Yakin akan menghapus produk ini?"),
          actions: <Widget>[
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Hapus"),
              onPressed: () async {
                await _deleteProduct();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.product.id)
        .delete()
        .then((value) {
      print('Produk berhasil dihapus');
    }).catchError((error) {
      print('Error saat menghapus produk: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.network(
                data['imageUrl'], // Replace with your image field
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data['name'], // Replace with your product name field
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Harga: ${data['price']}', // Replace with your price field
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Stok: ${data['stock']}', // Replace with your stock field
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.brown,
                    onPressed: () {
                      _confirmDelete();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.brown,
                    onPressed: () {
                      navigateToEditProductPage(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Cari Produk...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              query = value.trim();
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                query = '';
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          var filteredDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredDocs[index]['name']),
                // Add other product details here if necessary
              );
            },
          );
        },
      ),
    );
  }
}
