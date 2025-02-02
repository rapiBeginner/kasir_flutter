import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

editDialogueCustomer(BuildContext context, Map data) {
  var namaController = TextEditingController(text: data['nama']);
  var alamatController = TextEditingController(text: '${data['alamat']}');
  var noTelpController = TextEditingController(text: '${data['noTelp']}');
  var formKey = GlobalKey<FormState>();

  void EditCustomer() async {
    if (formKey.currentState!.validate()) {
      var checkPhoneNumber = await Supabase.instance.client
          .from('user')
          .select()
          .eq('noTelp', noTelpController.text.replaceAll(" ", ""));
      if (checkPhoneNumber.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Nama produk sudah digunakan',
            style: GoogleFonts.lato(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1500),
        ));
      } else {
        var response = await Supabase.instance.client.from('pelanggan').update({
          'nama': namaController.text.trim(),
          'noTelp': noTelpController.text.trim(),
          'alamat': alamatController.text.trim(),
        }).eq('idPelanggan', data['idPelanggan']);

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
                      EditCustomer();
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
                                    labelText: 'Nama pelanggan'),
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
                                    return 'Alamat wajib di isi';
                                  }
                                  return null;
                                },
                                controller: alamatController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Alamat'),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: constraint.maxHeight / 3,
                            width: constraint.maxWidth,
                            child: Center(
                              child: TextFormField(
                                controller: noTelpController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nomor telepon wajib di isi';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Nomor telepon'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }))));
      });
}
