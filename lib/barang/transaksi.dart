import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/createProduk.dart';
import 'package:ukk_flutter/barang/editProduk.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final _pageControl = PageController();
  var response;

  List produk = [];
  int selectedIndex = 0;

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
  Future<void> fetchProduct() async {
    response = await Supabase.instance.client.from('produk').select();

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
    GridView generateCard([String? filter]) {
      dynamic data;

      if (filter == null) {
        data = produk;
      } else {
        data = produk.where((item) => item["jenis"] == filter).toList();
      }

      return GridView.count(
        padding: const EdgeInsets.all(15),
        // crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 4 : 2,
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.5,
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
              elevation: 10,
              child: LayoutBuilder(builder: (context, constraint) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          IconButton(onPressed: (){
                            editDialogue(context, data[index]);
                          }, icon:Icon(Icons.edit))
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
      drawer: Drawer(width: MediaQuery.of(context).size.width / 1.3),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(right: 5),
          height: kToolbarHeight / 1.4,
          width: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              border: Border.all(width: 2, color: Colors.white)),
          child: TextField(
            style: GoogleFonts.inter(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
                hintText: 'Cari barang',
                hintStyle: GoogleFonts.inter(color: Colors.white),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10)),
          ),
        ),

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
                    _pageControl.animateToPage(selectedIndex,
                        duration: const Duration(milliseconds: 300),
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
                  generateCard('makanan'),
                  generateCard('minuman'),
                  generateCard('lainnya')
                ],
              ))
            ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => addProduct()));
        },
        elevation: 15,
        backgroundColor: Color.fromARGB(255, 160, 51, 250),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
