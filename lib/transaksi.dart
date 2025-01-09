import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final _pageControl = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    GridView generateCard([int? length]) {
      return GridView.count(
        padding: EdgeInsets.all(15),
        crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 4 : 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
        children: [
          ...List.generate(length ?? 5, (index) {
            return Card(
              elevation: 10,
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
        body: Column(children: [
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
                selectedIndex = index;
                _pageControl.animateToPage(selectedIndex,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              });
            },
            activeColor: Colors.purple.shade500,
            inactiveColor: Colors.grey.shade600,
          ),
          Expanded(
              child: PageView(
            controller: _pageControl,
            children: [
              generateCard(),
              generateCard(10),
              generateCard(7),
              generateCard(3)
            ],
          ))
        ]));
  }
}
