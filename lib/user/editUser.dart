import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

editDialogueUser(BuildContext context, Map data) {
  var namaController = TextEditingController(text: data['nama']);
  var emailController = TextEditingController(text: '${data['email']}');
  var passwordController = TextEditingController(text: '${data['password']}');
  var formKey = GlobalKey<FormState>();

  void EditUser() async {
    if (formKey.currentState!.validate()) {
      var checkEmail = await Supabase.instance.client
          .from('user')
          .select()
          .eq('email', emailController.text.trim());
      if (checkEmail.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Email sudah digunakan',
            style: GoogleFonts.lato(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1500),
        ));
      } else {
        var response = await Supabase.instance.client.from('user').update({
          'nama': namaController.text.trim(),
          'password': passwordController.text.trim(),
          'email': emailController.text.trim(),
        }).eq('id_user', data['id_user']);

        if (response == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Data berhasil di ubah'),
            backgroundColor: Colors.green,
          ));
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Transaction()));
          Navigator.pop(context, 'success');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Edit data gagal'),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  return showDialog(
      context: context,
      builder: (context) {
        return Form(
            key: formKey,
            child: AlertDialog(
                backgroundColor: Color.fromARGB(255, 168, 70, 237),
                titleTextStyle:
                    GoogleFonts.lato(color: Colors.white, fontSize: 25),
                title: Text(
                  'Edit data',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      EditUser();
                    },
                    child: Text(
                      'Edit',
                      style: GoogleFonts.lato(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 20,
                        backgroundColor: Color.fromARGB(255, 255, 253, 205)),
                  )
                ],
                actionsAlignment: MainAxisAlignment.center,
                contentPadding: const EdgeInsets.all(10),
                content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 253, 205),
                    ),
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 2,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.deepPurple))),
                            height: constraint.maxHeight / 3,
                            width: constraint.maxWidth,
                            child: Center(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama wajib di isi';
                                  }
                                  return null;
                                },
                                controller: namaController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Nama pengguna'),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.deepPurple))),
                            height: constraint.maxHeight / 3,
                            width: constraint.maxWidth,
                            child: Center(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email wajib di isi';
                                  } else if (!value
                                      .toString()
                                      .endsWith('@gmail.com')) {
                                    return 'Format email tidak valid';
                                  }

                                  return null;
                                },
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Email'),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: constraint.maxHeight / 3,
                            width: constraint.maxWidth,
                            child: Center(
                              child: TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password wajib di isi';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Password'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }))));
      });
}
