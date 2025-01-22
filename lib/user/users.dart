import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/transaksi.dart';
import 'package:ukk_flutter/main.dart';
import 'package:ukk_flutter/user/createCustomer.dart';
import 'package:ukk_flutter/user/createUser.dart';
import 'package:ukk_flutter/user/editCustomer.dart';
import 'package:ukk_flutter/user/editUser.dart';
import 'package:ukk_flutter/user/hapusUserCustomer.dart';

class userAndCustomers extends StatefulWidget {
  final Map? login;
  userAndCustomers({super.key, required this.login});

  State<userAndCustomers> createState() => userAndCustomersState();
}

class userAndCustomersState extends State<userAndCustomers>
    with TickerProviderStateMixin {
  var user;
  var customer;
  TabController? myTabControl;
  fetchUserCustomer() async {
    var responseUser = await Supabase.instance.client.from('user').select().order('id_user', ascending: true);
    var responseCustomer =
        await Supabase.instance.client.from('pelanggan').select().order('idPelanggan', ascending: true);
    setState(() {
      user = List<Map<String, dynamic>>.from(responseUser);
      customer = List<Map<String, dynamic>>.from(responseCustomer);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserCustomer();
    myTabControl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myTabControl?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    generateCard(List data, IconData icon) {
      return GridView.count(
        padding: EdgeInsets.all(10),
        childAspectRatio: 3,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data[index]['nama']),
                            Text(data[index]['email'] ?? data[index]['noTelp']),
                          ],
                        ),
                        Spacer(),
                        widget.login!['role'] == 'admin'
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        var result;
                                        if (data[index]['id_user'] != null) {
                                          result = await editDialogueUser(
                                              context, data[index]);
                                        }else{
                                          result= await editDialogueCustomer(context, data[index]);
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
                                        int id = data[index]['id_user'] ??
                                            data[index]['idPelanggan'];
                                        String idColumn =
                                            data[index]['id_user'] != null
                                                ? "id_user"
                                                : 'idPelanggan';
                                        String table =
                                            data[index]['id_user'] != null
                                                ? "user"
                                                : "pelanggan";
                                        var result = await hapusUserCustomer(
                                            id, idColumn, table, context);
                                        if (result == 'success') {
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
      floatingActionButton: widget.login!['role'] == 'admin'
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
            accountName: Text(widget.login!['nama']),
            accountEmail: Text(widget.login!['email']),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 255, 252, 221),
              child: Text(
                widget.login!['nama'].toString().toUpperCase()[0],
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
                  child: TabBarView(controller: myTabControl, children: [
                    generateCard(user, Icons.person_2),
                    generateCard(customer, Icons.person_4)
                  ]),
                )
              ],
            ),
    );
  }
}
