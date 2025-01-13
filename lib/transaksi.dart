import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final _pageControl = PageController();
  var response;
  var produk;
  int selectedIndex = 0;
  var jenis = [
    null,
    'makanan',
    'minuman',
    'lainnya',
  ];
  var warnaBarItem = [
    Color.fromARGB(255, 160, 51, 250),
    Colors.red,
    Colors.blue,
    Colors.black
  ];
  void fetchProduct([String? filter]) async {
    if (filter == null) {
      response = await Supabase.instance.client.from('produk').select();
    } else {
      response = await Supabase.instance.client
          .from('produk')
          .select()
          .eq('jenis', filter);
    }
    setState(() {
      produk = response;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    GridView generateCard() {
      return GridView.count(
        padding: EdgeInsets.all(15),
        // crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 4 : 2,
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 5,
        children: [
          ...List.generate(produk.length, (index) {
            Color warnaLingkaran;

            if (produk[index]['jenis'] == 'makanan') {
              warnaLingkaran = Colors.red;
            } else if (produk[index]['jenis'] == 'minuman') {
              warnaLingkaran = Colors.blue;
            } else {
              warnaLingkaran = Colors.black;
            }
            return Card(
              elevation: 10,
              child: LayoutBuilder(builder: (context, constraint) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${produk[index]["Nama"]}'),
                        Text('Sisa stok:${produk[index]["Stok"]}'),
                        Text('${produk[index]["Harga"]}'),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: constraint.maxHeight * 0.2,
                      width: constraint.maxHeight * 0.2,
                      decoration: BoxDecoration(
                          color: warnaLingkaran,
                          borderRadius: BorderRadius.circular(500)),
                    ),
                    SizedBox(
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
        drawer: Drawer(width: MediaQuery.of(context).size.width / 1.3),
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.only(right: 5),
            height: kToolbarHeight / 1.4,
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(width: 2, color: Colors.white)),
            child: TextField(
              style: GoogleFonts.inter(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  hintText: 'Cari barang',
                  hintStyle: GoogleFonts.inter(color: Colors.white),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10)),
            ),
          ),

          // ),
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 160, 51, 250),
        ),
        body: produk == null
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
                    setState(() {
                      fetchProduct(jenis[index]);
                      selectedIndex = index;
                      _pageControl.animateToPage(selectedIndex,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    });
                  },
                  activeColor: warnaBarItem[selectedIndex],
                  inactiveColor: Colors.grey.shade600,
                ),
                Expanded(
                    child: PageView(
                  controller: _pageControl,
                  children: [
                    generateCard(),
                    generateCard(),
                    generateCard(),
                    generateCard()
                  ],
                ))
              ]));
  }
}
