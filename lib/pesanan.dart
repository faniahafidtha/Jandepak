import 'package:flutter/material.dart';

void main() {
  runApp(Pesanan());
}

class Pesanan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = [
      {
        'image': 'assets/wallet.png',
        'title': 'Belum Bayar',
        'arrow': 'assets/arrow_right.png'
      },
      {
        'image': 'assets/disiapkan.png',
        'title': 'Disiapkan',
        'arrow': 'assets/arrow_right.png'
      },
      {
        'image': 'assets/dikirim.png',
        'title': 'Dikirim',
        'arrow': 'assets/arrow_right.png'
      },
      {
        'image': 'assets/selesai.png',
        'title': 'Selesai',
        'arrow': 'assets/arrow_right.png'
      },
    ];

    return MaterialApp(
      title: 'Menu Aplikasi',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pesanan'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: item.length,
          itemBuilder: (context, index) {
            return buildItem(context, item[index]);
          },
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        // Tindakan saat item diklik (menuju halaman lain)
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              item['image'],
              width: 50,
              height: 50,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                item['title'],
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            Image.asset(
              item['arrow'],
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
