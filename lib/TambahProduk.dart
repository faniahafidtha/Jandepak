import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Mendapatkan instance dari Firebase Firestore
  var db = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image; // Variabel untuk menyimpan file gambar

  // Variabel untuk menyimpan input teks
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String? _selectedCategory; // Nullable karena pengguna mungkin tidak memilih apapun

  // Fungsi untuk menampilkan dialog pemilihan sumber gambar
  Future<void> _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Sumber Gambar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Galeri'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Kamera'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk mengunggah gambar dan mendapatkan URL-nya
  Future<String> _uploadImageAndGetDownloadUrl(File imageFile) async {
    String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.png';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Fungsi untuk validasi dan menyimpan produk
  Future<void> _validateAndUpload() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _selectedCategory == null ||
        _image == null) {
      // Tampilkan dialog jika ada field yang kosong atau gambar tidak dipilih
      _showErrorDialog('Semua field harus diisi dan gambar harus dipilih.');
    } else {
      try {
        // Unggah gambar dan dapatkan URL
        String imageUrl = await _uploadImageAndGetDownloadUrl(_image!);

        // Konversi harga dan stok menjadi angka
        final int? price = int.tryParse(_priceController.text.trim());
        final int? stock = int.tryParse(_stockController.text.trim());

        // Periksa apakah harga dan stok adalah angka yang valid
        if (price == null || stock == null) {
          throw Exception('Harga dan stok harus berupa angka yang valid.');
        }

        // Tambahkan detail produk ke Firestore
        await db.collection('products').add({
          'name': _nameController.text.trim(),
          'price': price,
          'stock': stock,
          'category': _selectedCategory ?? "",
          'imageUrl': imageUrl, // URL dari gambar yang diunggah
        });

        // Bersihkan input setelah upload berhasil
        _clearInputs();

        // Tampilkan pesan sukses
        print('Produk berhasil ditambahkan ke Firestore.');

        // Navigasi kembali ke HomeScreen
        // (Pastikan Anda memiliki navigasi yang sesuai ke layar beranda)
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        //   ModalRoute.withName('/'),
        // );
      } catch (e) {
        // Tangani error dalam pengunggahan gambar atau pembaruan Firestore
        _showErrorDialog('Terjadi kesalahan saat mengunggah data: $e');
      }
    }
  }

  // Bersihkan input setelah upload berhasil
  void _clearInputs() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
    setState(() {
      _selectedCategory = null;
      _image = null;
    });
  }

  // Tampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Hapus controllers ketika state dihapus
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Implementasi tampilan UI untuk menambahkan produk
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
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
                        items: <String>['Makanan', 'Minuman']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          border: InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: _image == null
                              ? null
                              : () {
                                  _validateAndUpload();
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
      ),
    );
  }
}
