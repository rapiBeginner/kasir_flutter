import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/produk.dart';
import 'package:ukk_flutter/main.dart';
import 'package:ukk_flutter/penjualan/penjualan.dart';
import 'package:ukk_flutter/user/createCustomer.dart';
import 'package:ukk_flutter/user/createUser.dart';
import 'package:ukk_flutter/user/editCustomer.dart';
import 'package:ukk_flutter/user/editUser.dart';
import 'package:ukk_flutter/user/hapusCustomer.dart';
import 'package:ukk_flutter/user/hapusUser.dart';

class userAndCustomers extends StatefulWidget {
  final Map login;
  userAndCustomers({super.key, required this.login});

  State<userAndCustomers> createState() => userAndCustomersState();
}

class userAndCustomersState extends State<userAndCustomers>
    with TickerProviderStateMixin {
  var user;
  var customer;
  var filterUser;
  var searchCustomer;
  dynamic barTitle = Text(
    'Users & Customers',
  );
  TabController? myTabControl;
  bool? searchActive = false;
  TextEditingController userSearchCtrl = TextEditingController();
  TextEditingController customerSearchCtrl = TextEditingController();

  fetchUserCustomer() async {
    var responseUser = await Supabase.instance.client
        .from('user')
        .select()
        .order('id_user', ascending: true);
    var responseCustomer = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .order('idPelanggan', ascending: true);
    setState(() {
      user = List<Map<String, dynamic>>.from(responseUser);
      customer = List<Map<String, dynamic>>.from(responseCustomer);
    });
  }

  @override
  void initState() {
    //
    super.initState();
    fetchUserCustomer();
    myTabControl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    //
    super.dispose();
    myTabControl?.dispose();
  }

  void popUpSearch() {
    if (myTabControl!.index == 0) {
      userSearchCtrl.clear();
      searchUser();
      setState(() {
        customer = searchCustomer;
      });
    } else {
      customerSearchCtrl.clear();
      searchPelanggan();
      setState(() {
        user = filterUser;
      });
    }
  }

  searchUser() {
    filterUser = user;
    setState(() {
      barTitle = SizedBox(
        height: kToolbarHeight / 1.5,
        child: TextField(
          controller: userSearchCtrl,
          style: GoogleFonts.lato(color: Colors.white),
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty) {
                setState(() {
                  user = filterUser!.where((item) {
                    return item["email"]
                            .toString()
                            .toLowerCase()
                            .startsWith(value.toLowerCase()) ||
                        item["nama"]
                            .toString()
                            .toLowerCase()
                            .startsWith(value.toLowerCase());
                  }).toList();
                });
              } else {
                user = filterUser;
              }
            });
          },
          cursorColor: Colors.white,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    barTitle = Text('User & customer');
                  });
                  myTabControl!.removeListener(popUpSearch);
                  userSearchCtrl.clear();
                  setState(() {
                    user = filterUser;
                  });
                },
                icon: Icon(Icons.close)),
            labelText: 'Cari Pengguna',
            filled: true,
            fillColor: Colors.transparent,
            labelStyle: GoogleFonts.lato(color: Colors.white),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(50)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
      );
    });
  }

  searchPelanggan() {
    searchCustomer = customer;
    setState(() {
      barTitle = SizedBox(
        height: kToolbarHeight / 1.5,
        child: TextField(
          controller: customerSearchCtrl,
          cursorColor: Colors.white,
          style: GoogleFonts.lato(color: Colors.white),
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty) {
                customer = searchCustomer!.where((item) {
                  return item["nama"]
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase()) ||
                      item["alamat"]
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      item["noTelp"].toString().contains(value);
                }).toList();
              }else{
                customer=searchCustomer;
              }
            });
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    barTitle = Text('User & customer');
                    customer=searchCustomer;
                  });
                  myTabControl!.removeListener(popUpSearch);
                  customerSearchCtrl.clear();
                },
                icon: Icon(Icons.close)),
            labelText: 'Cari Pelanggan',
            filled: true,
            fillColor: Colors.transparent,
            labelStyle: GoogleFonts.lato(color: Colors.white),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(50)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    generateCard(List data, IconData icon) {
      return GridView.count(
        padding: EdgeInsets.all(10),
        childAspectRatio: 2.5,
        crossAxisCount: 1,
        children: [
          ...List.generate(data.length, (index) {
            return Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(255, 182, 149, 202)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(icon),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data[index]['nama']),
                              Text(data[index]['email'] ??
                                  data[index]['noTelp']),
                            ],
                          ),
                        ),
                        Spacer(),
                        widget.login['role'] == 'admin'
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        var result;
                                        if (data[index]['id_user'] != null) {
                                          result = await editDialogueUser(
                                              context, data[index]);
                                        } else {
                                          result = await editDialogueCustomer(
                                              context, data[index]);
                                        }
                                        if (result == 'success') {
                                          fetchUserCustomer();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        var result;
                                        if (data[index]['id_user'] != null) {
                                          result = await hapusUser(
                                              data[index]['id_user'], context);
                                        } else {
                                          result = await hapusCustomer(
                                              data[index]['idPelanggan'],
                                              context);
                                        }
                                        if (result == true) {
                                          fetchUserCustomer();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              )
                            : SizedBox(),
                      ]),
                ),
              ),
            );
          }),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: barTitle,
        titleTextStyle:
            GoogleFonts.lato(fontSize: kToolbarHeight / 2, color: Colors.white),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 160, 51, 250),
        actions: [
          IconButton(
              onPressed: () {
                myTabControl!.index == 0 ? searchUser() : searchPelanggan();
                myTabControl!.addListener(popUpSearch);
              },
              icon: Icon(Icons.search))
        ],
      ),
      floatingActionButton: widget.login['role'] == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white),
                              onPressed: () async {
                                Navigator.pop(context);
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => addUser()));
                                if (result == 'success') {
                                  fetchUserCustomer();
                                }
                              },
                              child: Text('Pengguna')),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white),
                              onPressed: () async {
                                Navigator.pop(context);
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => addCustomer()));
                                if (result == 'success') {
                                  fetchUserCustomer();
                                }
                              },
                              child: Text('Pelanggan')),
                        ],
                      ),
                    );
                  },
                );
              },
              elevation: 15,
              backgroundColor: Color.fromARGB(255, 160, 51, 250),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
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
                        builder: (context) => Transaction(user: widget.login)));
              },
              leading: FaIcon(FontAwesomeIcons.cartShopping),
              title: Text('Product')),
          ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Penjualan(login: widget.login)));
              },
              leading: FaIcon(FontAwesomeIcons.dollarSign),
              title: Text('Sales')),
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
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                    color: Color.fromARGB(255, 252, 250, 225),
                    width: MediaQuery.of(context).size.width,
                    height: kToolbarHeight / 1.1,
                    child: TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(Icons.person_2),
                          text: 'User',
                        ),
                        Tab(
                          icon: Icon(Icons.person_4),
                          text: 'Costumer',
                        ),
                      ],
                      controller: myTabControl,
                    )),
                Expanded(
                  child: TabBarView(
                    controller: myTabControl,
                    children: [
                      generateCard(user, Icons.person_2),
                      generateCard(customer, Icons.person_4),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
