import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class addUser extends StatefulWidget {
  const addUser({super.key});

  State<addUser> createState() => _addUserState();
}

class _addUserState extends State<addUser> {
  var response;
  final formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    void userAdd() async {
      if (formKey.currentState!.validate()) {
        response = await Supabase.instance.client.from('user').insert({
          "nama": namaController.text,
          "email": emailController.text,
          "password": pwController.text,
          "role": "petugas"
        });
        if (response == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Data berhasil ditambahkan',
              style: GoogleFonts.lato(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => Transaction()));
          Navigator.pop(context, 'success');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Tambah data gagal',
              style: GoogleFonts.lato(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        }
      }
    }

    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Color.fromARGB(255, 143, 13, 249),
                Color.fromARGB(255, 189, 114, 251),
                Color.fromARGB(255, 216, 176, 249),
              ],
                  // stops: [0, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Form(
              key: formKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            
                            'Registrasi Pengguna',
                            
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.height / 22),
                          ),
                          FaIcon(Icons.person_add)
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/35),
                      Card(
                        elevation: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 251, 251, 212),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            // boxShadow: [BoxShadow(offset: Offset(0, 6), blurRadius: 3)],
                          ),
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: LayoutBuilder(builder: (context, constraint) {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 189, 114, 251)))),
                                  height: constraint.maxHeight / 3,
                                  width: constraint.maxWidth,
                                  child: Center(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Nama tidak boleh kosong';
                                        }

                                        return null;
                                      },
                                      controller: namaController,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.abc),
                                          border: InputBorder.none,
                                          labelText: 'Nama pengguna',
                                          labelStyle: GoogleFonts.lato(fontSize: 20)),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 189, 114, 251)))),
                                  height: constraint.maxHeight / 3,
                                  width: constraint.maxWidth,
                                  child: Center(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email tidak boleh kosong';
                                        }else if(!value.endsWith('@gmail.com')){
                                          return 'Format email tidak valid';
                                        }

                                        return null;
                                      },
                                      controller: emailController,
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.email),
                                          border: InputBorder.none,
                                          labelText: 'Email',
                                          labelStyle: GoogleFonts.lato(fontSize: 20)),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  // decoration: BoxDecoration(
                                  //     border: Border(
                                  //         bottom: BorderSide(
                                  //             color: Color.fromARGB(
                                  //                 255, 189, 114, 251)))),
                                  height: constraint.maxHeight / 3,
                                  width: constraint.maxWidth,
                                  child: Center(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password tidak boleh kosong';
                                        }

                                        return null;
                                      },
                                      obscureText: true,
                                      controller: pwController,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.password),
                                          border: InputBorder.none,
                                          labelText: 'Password',
                                          labelStyle: GoogleFonts.lato(fontSize: 20)),
                                    ),
                                  ),
                                ),

                              ],
                            );
                          }),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextButton(
                        onPressed: userAdd,
                        child: Text('Tambah', style: GoogleFonts.lato(fontSize: 20),),
                        style: TextButton.styleFrom(
                          elevation: 15,
                          fixedSize: Size(MediaQuery.of(context).size.width / 1.5, 50),
                          backgroundColor: Color.fromARGB(255, 160, 51, 250),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }
}

