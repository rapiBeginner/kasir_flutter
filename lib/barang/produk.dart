import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/createProduk.dart';
import 'package:ukk_flutter/barang/editProduk.dart';
import 'package:ukk_flutter/barang/hapusProduk.dart';
import 'package:ukk_flutter/main.dart';
import 'package:ukk_flutter/penjualan/penjualan.dart';
import 'package:ukk_flutter/user/users.dart';

class Transaction extends StatefulWidget {
  final Map user;
  const Transaction({super.key, required this.user});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final _pageControl = PageController();
  var response;
  List produk = [];
  List afterSearchProduct = [];
  int selectedIndex = 0;
  var slidingBarKey;
  dynamic title = Text(
    'Product',
  );
  TextEditingController searchController = TextEditingController();
  var jenis = [
    null,
    'makanan',
    'minuman',
    'lainnya',
  ];
  var warnaBarItem = [
    const Color.fromARGB(255, 160, 51, 250),
    Colors.red,
    Colors.blue,
    Colors.black
  ];
  fetchProduct() async {
    response = await Supabase.instance.client
        .from('produk')
        .select()
        .order('id', ascending: true);

    setState(() {
      afterSearchProduct = response;
    });
  }

  searchProduct() {
    produk = afterSearchProduct;
    setState(() {
      title = TextField(
        onChanged: (value) {
          setState(() {
            if (value.isNotEmpty) {
              afterSearchProduct = produk
                  .where((item) => item['Nama']
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                  .toList();
            } else {
              afterSearchProduct = produk;
            }
          });
        },
        controller: searchController,
        decoration: InputDecoration(
          suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.close)),
          hintText: 'Cari barang',
          filled: true,
          fillColor: Colors.transparent,
          hintStyle: GoogleFonts.lato(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(50)),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    GridView generateCard([String? filter]) {
      List data;

      if (filter == null) {
        data = afterSearchProduct;
      } else {
        data = afterSearchProduct
            .where((item) => item["jenis"] == filter)
            .toList();
      }

      return GridView.count(
        padding: const EdgeInsets.all(15),
        // crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 4 : 2,
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.5,
        children: [
          ...List.generate(data.length, (index) {
            IconData iconJenis;
            Color warnaIcon;
            if (data[index]['jenis'] == 'makanan') {
              iconJenis = FontAwesomeIcons.burger;
              warnaIcon = Colors.red;
            } else if (data[index]['jenis'] == 'minuman') {
              iconJenis = Icons.local_bar;
              warnaIcon = Colors.blue;
            } else {
              iconJenis = FontAwesomeIcons.ellipsis;
              warnaIcon = Colors.black;
            }
            return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromARGB(255, 169, 75, 240),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              elevation: 10,
              child: LayoutBuilder(builder: (context, constraint) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  child: Row(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('$data')
                        Text('${data[index]["Nama"]}'),
                        Text('Sisa stok:${data[index]["Stok"]}'),
                        Text('${data[index]["Harga"]}'),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                var result =
                                    await editDialogue(context, data[index]);
                                if (result == 'success') {
                                  fetchProduct();
                                }
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () async {
                                var result = await hapusDialogue(
                                    data[index]['id'], context);
                                if (result == 'success') {
                                  fetchProduct();
                                }
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                    Icon(
                      iconJenis,
                      color: warnaIcon,
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ]),
                );
              }),
            );
          })
        ],
      );
    }

    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 1.3,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user['nama']),
              accountEmail:
                  Text('${widget.user['email']} (${widget.user['role']})'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 245, 246, 212),
                child: Text(
                  widget.user['nama'].toString().toUpperCase()[0],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 176, 80, 255),
              ),
            ),

            ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => userAndCustomers(login: user)));
                },
                leading: Icon(Icons.person),
                title: Text('User and Customer')),
            ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Penjualan(login: user)));
                },
                leading: FaIcon(FontAwesomeIcons.dollarSign),
                title: Text('Sales')),

// Tutup Drawer

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
        ),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: kToolbarHeight / 4),
            child: IconButton(
                onPressed: () {
                  searchProduct();
                },
                icon: Icon(
                  Icons.search,
                  size: kToolbarHeight / 1.7,
                )),
          )
        ],
        centerTitle: true,
        // title: Container(
        //   padding: const EdgeInsets.only(right: 5),
        //   height: kToolbarHeight / 1.4,
        //   width: MediaQuery.of(context).size.width / 2.5,
        //   decoration: BoxDecoration(
        //       borderRadius: const BorderRadius.all(Radius.circular(25)),
        //       border: Border.all(width: 2, color: Colors.white)),
        //   child: TextField(
        //     style: GoogleFonts.inter(color: Colors.white),
        //     cursorColor: Colors.white,
        //     decoration: InputDecoration(
        //         hintText: 'Cari barang',
        //         hintStyle: GoogleFonts.inter(color: Colors.white),
        //         border: const OutlineInputBorder(borderSide: BorderSide.none),
        //         prefixIcon: const Icon(
        //           Icons.search,
        //           color: Colors.white,
        //         ),
        //         contentPadding: const EdgeInsets.symmetric(vertical: 10)),
        //   ),
        // ),
        title: title,
        titleTextStyle: GoogleFonts.lato(fontSize: 30, color: Colors.white),
        // ),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 160, 51, 250),
      ),
      body: response == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              SlidingClippedNavBar(
                backgroundColor: Color.fromARGB(255, 254, 255, 224),
                barItems: [
                  BarItem(title: 'All', icon: Icons.apps),
                  BarItem(title: 'Food', icon: FontAwesomeIcons.burger),
                  BarItem(title: 'Drinks', icon: Icons.local_bar),
                  BarItem(title: 'Others', icon: FontAwesomeIcons.ellipsis)
                ],
                selectedIndex: selectedIndex,
                onButtonPressed: (index) {
                  // fetchProduct(jenis[index]);
                  setState(() {
                    selectedIndex = index;
                    _pageControl.animateToPage(index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  });
                },
                activeColor: warnaBarItem[selectedIndex],
                inactiveColor: Colors.grey.shade600,
              ),
              Expanded(
                  child: PageView(
                physics: ClampingScrollPhysics(),
                controller: _pageControl,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: [
                  generateCard(),
                  generateCard('makanan'),
                  generateCard('minuman'),
                  generateCard('lainnya')
                ],
              ))
            ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => addProduct()));
          if (result == 'success') {
            fetchProduct();
          }
        },
        elevation: 15,
        backgroundColor: Color.fromARGB(255, 160, 51, 250),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
