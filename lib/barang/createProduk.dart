import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/transaksi.dart';

class addProduct extends StatefulWidget {
  const addProduct({super.key});

  State<addProduct> createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  var response;
  final formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController stokController = TextEditingController();
  final jenisController = SingleValueDropDownController();

  @override
  Widget build(BuildContext context) {
    void productAdd() async {
      if (formKey.currentState!.validate()) {
        response = await Supabase.instance.client.from('produk').insert({
          "Nama": namaController.text,
          "Harga": hargaController.text,
          "Stok": stokController.text,
          "jenis": jenisController.dropDownValue!.value
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
                            
                            'Tambah Barang',
                            
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.height / 20),
                          ),
                          FaIcon(FontAwesomeIcons.cartPlus)
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
                                  height: constraint.maxHeight / 4,
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
                                          labelText: 'Nama produk',
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
                                  height: constraint.maxHeight / 4,
                                  width: constraint.maxWidth,
                                  child: Center(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Harga tidak boleh kosong';
                                        }

                                        return null;
                                      },
                                      controller: hargaController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(FontAwesomeIcons.dollarSign),
                                          border: InputBorder.none,
                                          labelText: 'Harga',
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
                                  height: constraint.maxHeight / 4,
                                  width: constraint.maxWidth,
                                  child: Center(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Stok tidak boleh kosong';
                                        }

                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: stokController,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.list_alt),
                                          border: InputBorder.none,
                                          labelText: 'Stok',
                                          labelStyle: GoogleFonts.lato(fontSize: 20)),
                                    ),
                                  ),
                                ),
                                Container(
                                    height: constraint.maxHeight / 4,
                                    width: constraint.maxWidth,
                                    child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Center(
                                          child: DropDownTextField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Jenis tidak boleh kosong';
                                              }

                                              return null;
                                            },
                                            controller: jenisController,
                                            textFieldDecoration:
                                                InputDecoration(
                                                    labelText: 'Jenis',
                                                    labelStyle: GoogleFonts.lato(fontSize: 20),
                                                    border: InputBorder.none),
                                            // dropDownItemCount: 2,
                                            dropDownList: [
                                            ...List.generate(10, (index){
                                              return DropDownValueModel(name: '${index}', value: '${index}') ;
                                            })
                                              // DropDownValueModel(name: 'Makanan', value: 'makanan')
                                            ],
                                          ),
                                        ))),
                              ],
                            );
                          }),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextButton(
                        onPressed: productAdd,
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
