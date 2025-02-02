//Penjualan:TanggalPenjualan,TotalHarga, nama, noTelp
//DetailPenjualan:TanggalPenjualan,subtotal,nama,noTelp,jumlah,namaBarang
//

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/editProduk.dart';
import 'package:ukk_flutter/barang/produk.dart';
import 'package:ukk_flutter/main.dart';
import 'package:ukk_flutter/penjualan/createPenjualan.dart';
import 'package:ukk_flutter/penjualan/hapusPDetail.dart';
import 'package:ukk_flutter/penjualan/hapusPenjualan.dart';
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

  void fetchProductAndCustomer() async {
    var myProduk = await Supabase.instance.client
        .from('produk')
        .select()
        .order('id', ascending: true);
    var myCustomer = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .order('idPelanggan', ascending: true);

    setState(() {
      produk = myProduk;
      pelanggan = myCustomer;
    });
  }

  void fetchSales() async {
    var responseSales = await Supabase.instance.client
        .from('penjualan')
        .select('*, pelanggan(*), detailPenjualan(*, produk(*))');

    var responseSalesDetail = await Supabase.instance.client
        .from('detailPenjualan')
        .select('*, penjualan(*, pelanggan(*)), produk(*)');
    // print(responseSalesDetail);
    setState(() {
      penjualan = responseSales;
      detailPenjualan = responseSalesDetail;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSales();
    fetchProductAndCustomer();
    myTabControl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myTabControl?.dispose();
  }

  generateSales() {
    var sales = penjualan;
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
                child: Row(
                  children: [
                    Column(
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
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              generateSalesDetail(sales[index]);
                            },
                            icon: Icon(Icons.menu)),
                        // IconButton(
                        //     onPressed: () async {
                        //       var result = await hapusPenjualan(
                        //           penjualan[index]['idPenjualan'], context);
                        //       if (result == true) {
                        //         fetchSales();
                        //       }
                        //     },
                        //     icon: Icon(Icons.delete)),
                      ],
                    )
                  ],
                ),
              ));
        })
      ],
    );
  }

  generateSalesDetail(Map data) {
    Map? Pelanggan = data['pelanggan'];
    List detail = data['detailPenjualan'];
    String tanggalPenjualan = DateFormat('dd MMMM yyyy')
        .format(DateTime.parse(data['TanggalPenjualan']));
    String totalHarga = data['TotalHarga'].toString();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 253, 232),
            // contentPadding: EdgeInsets.zero,
            content: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pelanggan == null
                        ? Text(
                            "Pelanggan Tidak terdaftar",
                          )
                        : Column(
                            children: [
                              Text(Pelanggan['nama']),
                              Text(Pelanggan['noTelp']),
                              Text(Pelanggan['alamat'])
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month),
                        Text(tanggalPenjualan)
                      ],
                    ),
                    ...List.generate(
                      detail.length,
                      (index) {
                        return Row(
                          children: [
                            Text(
                                '${detail[index]['produk']['Nama']} (${detail[index]['jumlahProduk']})'),
                            Spacer(),
                            Text('${detail[index]['subtotal']}')
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [Text('Total:'), Spacer(), Text(totalHarga)],
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // return GridView.count(
    //   crossAxisCount: 1,
    //   childAspectRatio: 2,
    //   children: [
    //     ...List.generate(detailPenjualan.length, (index) {
    //       var tanggalPenjualan = DateFormat('dd MMMM yyyy').format(
    //           DateTime.parse(
    //               detailPenjualan[index]['penjualan']['TanggalPenjualan']));
    //       return Card(
    //         child: Row(
    //           children: [
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Icon(Icons.person),
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     Text(detailPenjualan[index]['penjualan']
    //                                 ['idPelanggan'] ==
    //                             null
    //                         ? 'Pelanggan tidak terdaftar'
    //                         : '${detailPenjualan[index]['penjualan']['pelanggan']['nama']} (${detailPenjualan[index]['penjualan']['pelanggan']['noTelp']})'),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 5,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Icon(FontAwesomeIcons.cartShopping),
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     Text(
    //                         '${detailPenjualan[index]['produk']['Nama']} (${detailPenjualan[index]['jumlahProduk']})'),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 5,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Icon(FontAwesomeIcons.rupiahSign),
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     Text('${detailPenjualan[index]['subtotal']}'),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 5,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Icon(FontAwesomeIcons.calendar),
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     Text('${tanggalPenjualan}'),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Spacer(),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 IconButton(
    //                     onPressed: () async {
    //                       // var result =
    //                       //     await editDialogue(context, data[index]);
    //                       // if (result == 'success') {
    //                       //   fetchProduct();
    //                       // }
    //                     },
    //                     icon: Icon(Icons.edit)),
    //                 IconButton(
    //                     onPressed: () async {
    //                       var result = await hapusDetailPenjualan(
    //                           detailPenjualan[index]['idDetail'], context);
    //                       if (result == true) {
    //                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                           content: Text(
    //                             'Data berhasil dihapus',
    //                             style: TextStyle(color: Colors.white),
    //                           ),
    //                           backgroundColor: Colors.green,
    //                           duration: Duration(milliseconds: 1500),
    //                         ));
    //                         fetchSales();
    //                       }
    //                     },
    //                     icon: Icon(Icons.delete))
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     })
    //   ],
    // );
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
        body: penjualan.isEmpty
            ? Center(child: CircularProgressIndicator())
            : generateSales(),
        // Column(
        //   children: [
        //     TabBar(
        //       tabs: [
        //         Tab(text: 'Sales'),
        //         Tab(text: 'Sales Detail'),
        //       ],
        //       controller: myTabControl,
        //     ),
        //     Expanded(
        //       child: TabBarView(
        //         children: [
        //           penjualan.isEmpty
        //               ? Center(
        //                   child: CircularProgressIndicator(),
        //                 )
        //               : generateSales(),
        //           // detailPenjualan.isEmpty
        //           //     ? Center(
        //           //         child: CircularProgressIndicator(),
        //           //       )
        //           // : generateSalesDetail()
        //         ],
        //         controller: myTabControl,
        //       ),
        //     )
        //   ],
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var jual = await showDialogSales(produk, pelanggan, context);
            if (jual == 'success') {
              fetchSales();
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 160, 51, 250),
        ));
  }
}
