import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    User? user =
        FirebaseAuth.instance.currentUser; // Get the currently logged-in user
    String email = user?.email ?? "No email registered";
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        // Menggunakan SingleChildScrollView
        child: Padding(
          padding:
              EdgeInsets.only(top: 20), // Menambahkan padding di bagian atas
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Mengatur alignment ke start
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
              ), // Placeholder untuk foto profil
              SizedBox(height: 20), // Memberikan sedikit ruang
              Card(
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Radius sudut melengkung
                  side: BorderSide(color: Colors.brown, width: 3.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                        controller: TextEditingController(
                            text: email), // Display the user's email
                        readOnly: true, // Make the TextField read-only
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Pengaturan Akun'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputProfilePage()),
                          ); // Aksi ketika ListTile diketuk
                        },
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

class InputProfilePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
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
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'No.hp',
                        border: InputBorder.none,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic to save profile
                          Navigator.pop(context);
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
}
