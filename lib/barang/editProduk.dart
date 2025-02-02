import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

editDialogue(BuildContext context, Map data) {
  var namaController = TextEditingController(text: data['Nama']);
  var hargaController = TextEditingController(text: '${data['Harga']}');
  var stokController = TextEditingController(text: '${data['Stok']}');
  var jenisController = SingleValueDropDownController(
      data: DropDownValueModel(name: data['jenis'], value: data['jenis']));
  var formKey = GlobalKey<FormState>();

  void EditProduct() async {
    if (formKey.currentState!.validate()) {
      var checkNames = await Supabase.instance.client
          .from('produk')
          .select()
          .eq('Nama', namaController.text.trim());
      if (checkNames.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Nama produk sudah digunakan',
            style: GoogleFonts.lato(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1500),
        ));
      } else {
        var response = await Supabase.instance.client.from('produk').update({
          'Nama': namaController.text.trim(),
          'Stok': stokController.text.trim(),
          'Harga': hargaController.text.trim(),
          'jenis': jenisController.dropDownValue!.value,
        }).eq('id', data['id']);

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
                      EditProduct();
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
                            height: constraint.maxHeight / 4,
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
                                    labelText: 'Nama produk'),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.deepPurple))),
                            height: constraint.maxHeight / 4,
                            width: constraint.maxWidth,
                            child: Center(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Harga wajib di isi';
                                  }

                                  return null;
                                },
                                controller: hargaController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Harga'),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.deepPurple))),
                            height: constraint.maxHeight / 4,
                            width: constraint.maxWidth,
                            child: Center(
                              child: TextFormField(
                                controller: stokController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Stok wajib di isi';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Stok'),
                              ),
                            ),
                          ),
                          Container(
                            // decoration: BoxDecoration(
                            //     border: Bor),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: constraint.maxHeight / 4,
                            width: constraint.maxWidth,
                            child: Center(
                              child: DropDownTextField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'jenis wajib di isi';
                                  }
                                  return null;
                                },
                                controller: jenisController,
                                dropDownList: [
                                  DropDownValueModel(
                                      name: 'makanan', value: 'makanan'),
                                  DropDownValueModel(
                                      name: 'minuman', value: 'minuman'),
                                  DropDownValueModel(
                                      name: 'lainnya', value: 'lainnya')
                                ],
                                textFieldDecoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Jenis'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }))));
      });
}
