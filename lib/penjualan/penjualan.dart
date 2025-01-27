//Penjualan:TanggalPenjualan,TotalHarga, nama, noTelp
//DetailPenjualan:TanggalPenjualan,subtotal,nama,noTelp,jumlah,namaBarang
//

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/editProduk.dart';
import 'package:ukk_flutter/barang/transaksi.dart';
import 'package:ukk_flutter/main.dart';
import 'package:ukk_flutter/penjualan/createPenjualan.dart';
import 'package:ukk_flutter/user/users.dart';

class Penjualan extends StatefulWidget {
  final Map login;
  const Penjualan({super.key, required this.login});

  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> with TickerProviderStateMixin {
  TabController? myTabControl;
  List penjualan = [];
  List detailPenjualan = [];
  List produk = [];
  List pelanggan = [];

  void fetchSales() async {
    var myProduk = await Supabase.instance.client
        .from('produk')
        .select()
        .order('id', ascending: true);
    var myCustomer = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .order('idPelanggan', ascending: true);

    var responseSales = await Supabase.instance.client
        .from('penjualan')
        .select('*, pelanggan(*)');
    var responseSalesDetail = await Supabase.instance.client
        .from('detailPenjualan')
        .select('*, penjualan(*, pelanggan(*)), produk(*)');
    // print(responseSalesDetail);
    setState(() {
      penjualan = responseSales;
      detailPenjualan = responseSalesDetail;
      produk = myProduk;
      pelanggan = myCustomer;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSales();
    myTabControl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myTabControl?.dispose();
  }

  generateSales() {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: [
        ...List.generate(penjualan.length, (index) {
          var tanggalPenjualan = DateFormat(
            'dd MMMM yyyy',
          ).format(DateTime.parse(penjualan[index]['TanggalPenjualan']));
          return Card(
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(penjualan[index]['idPelanggan'] == null
                            ? 'Pelanggan tidak terdaftar'
                            : '${penjualan[index]['pelanggan']['nama']} (${penjualan[index]['pelanggan']['noTelp']})')
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.rupiahSign,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text('${penjualan[index]['TotalHarga']}')
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.calendar,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text('${tanggalPenjualan}')
                      ],
                    ),
                  ],
                ),
              ));
        })
      ],
    );
  }

  generateSalesDetail() {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: [
        ...List.generate(detailPenjualan.length, (index) {
          var tanggalPenjualan = DateFormat('dd MMMM yyyy').format(
              DateTime.parse(
                  detailPenjualan[index]['penjualan']['TanggalPenjualan']));
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 10,
                    ),
                    Text(detailPenjualan[index]['penjualan']['idPelanggan'] ==
                            null
                        ? 'Pelanggan tidak terdaftar'
                        : '${detailPenjualan[index]['penjualan']['pelanggan']['nama']} (${detailPenjualan[index]['penjualan']['pelanggan']['noTelp']})'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.cartShopping),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        '${detailPenjualan[index]['produk']['Nama']} (${detailPenjualan[index]['jumlahProduk']})'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.rupiahSign),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${detailPenjualan[index]['subtotal']}'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.calendar),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${tanggalPenjualan}'),
                  ],
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // ),
          centerTitle: true,
          title: Text('Sales'),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 160, 51, 250),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 139, 28, 250),
                Color.fromARGB(255, 175, 95, 255),
                Color.fromARGB(255, 206, 157, 255),
              ], begin: Alignment.topLeft)),
              accountName: Text(widget.login['nama']),
              accountEmail:
                  Text('${widget.login['email']} (${widget.login['role']})'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 255, 252, 221),
                child: Text(
                  widget.login['nama'].toString().toUpperCase()[0],
                  style: GoogleFonts.lato(fontSize: 24),
                ),
              ),
            ),
            ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              userAndCustomers(login: widget.login)));
                },
                leading: FaIcon(FontAwesomeIcons.person),
                title: Text('Users & Customers')),
            ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Transaction(user: widget.login)));
                },
                leading: FaIcon(FontAwesomeIcons.cartShopping),
                title: Text('Product')),

            // Menu Items
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   // MaterialPageRoute(
                //     // builder: (context) => ProfilePage(user: user),
                //   // ),
                // );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Tutup Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Tutup Drawer
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        )),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Sales'),
                Tab(text: 'Sales Detail'),
              ],
              controller: myTabControl,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  penjualan.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : generateSales(),
                  detailPenjualan.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : generateSalesDetail()
                ],
                controller: myTabControl,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var jual = await showDialogSales(produk, pelanggan, context);
            if (jual == 'success') {
              fetchSales();
            }
          },
          child: Icon(Icons.add,color: Colors.white,),
          backgroundColor: Color.fromARGB(255, 160, 51, 250),
        ));
  }
}
