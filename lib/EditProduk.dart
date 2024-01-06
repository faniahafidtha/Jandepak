
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditProduk extends StatefulWidget {
  final QueryDocumentSnapshot product;

  EditProduk({required this.product});

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  String? _selectedCategory;

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Sumber Gambar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Galeri'),
                onTap: () {
                  // Logika untuk memilih gambar dari galeri
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Kamera'),
                onTap: () {
                  // Logika untuk mengambil gambar dari kamera
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

@override
  void initState() {
    super.initState();
    Map<String, dynamic> data = widget.product.data() as Map<String, dynamic>;
    _nameController = TextEditingController(text: data['name']);
    _priceController = TextEditingController(text: data['price'].toString());
    _stockController = TextEditingController(text: data['stock'].toString());
    _selectedCategory = data['category'];
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('Edit Produk'),
      ),
      // Photo Produk
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _showImagePickerDialog(context);
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amber,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ), // Teks placeholder
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0), // Radius sudut melengkung
                side: BorderSide(color: Colors.brown, width: 3.0),
              ),
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Produk',
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Harga',
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    TextField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: 'Stok',
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: <String>['Makanan', 'Minuman'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: InputBorder.none,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          _updateProduct();
                        },
                        child: Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown,
                          shape: StadiumBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
    Future<void> _updateProduct() async {
    try {
      // Update logic here
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({
            'name': _nameController.text,
            'price': int.parse(_priceController.text),
            'stock': int.parse(_stockController.text),
            'category': _selectedCategory,
            // You need to handle the image update separately
          });
      Navigator.pop(context);
    } catch (e) {
      // Handle errors here
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}



// class _EditProdukState extends State<EditProduk> {
//   late TextEditingController _nameController;
//   late TextEditingController _priceController;
//   late TextEditingController _stockController;
//   String? _selectedCategory;


// class EditProduk extends StatelessWidget {
//   void _showImagePickerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Pilih Sumber Gambar'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: Text('Galeri'),
//                 onTap: () {
//                   // Logika untuk memilih gambar dari galeri
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text('Kamera'),
//                 onTap: () {
//                   // Logika untuk mengambil gambar dari kamera
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Produk'),
//       ),
//       // Photo Produk
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             GestureDetector(
//               onTap: () {
//                 _showImagePickerDialog(context);
//               },
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.amber,
//                 child: Center(
//                   child: Icon(
//                     Icons.person,
//                     size: 50,
//                   ), // Teks placeholder
//                 ),
//               ),
//             ),
//             Card(
//               margin: EdgeInsets.all(20),
//               shape: RoundedRectangleBorder(
//                 borderRadius:
//                     BorderRadius.circular(30.0), // Radius sudut melengkung
//                 side: BorderSide(color: Colors.brown, width: 3.0),
//               ),
//               elevation: 10,
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Nama Produk',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                     Divider(),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Harga',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                     Divider(),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Stok',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                     Divider(),
//                     DropdownButtonFormField<String>(
//                       items: <String>['Makanan', 'Minuman'].map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (_) {},
//                       decoration: InputDecoration(
//                         labelText: 'Kategori',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Logic to save profile
//                           Navigator.pop(context);
//                         },
//                         child: Text('Simpan'),
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.brown,
//                           shape: StadiumBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
