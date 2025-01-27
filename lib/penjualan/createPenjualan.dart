// produk object = {
//   'id'
//   'Nama'
//   'Stok'
//   'Harga'
//   'Jenis'
//   'jumlahProduk
//    'subtotal'
// }

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

showDialogSales(List produk, List pelanggan, BuildContext context) {
  var formKeyProduk = GlobalKey<FormState>();
  var formKeyPenjualan = GlobalKey<FormState>();
  List<Map<String, dynamic>> selectedProduk = [];
  List<Map<String, dynamic>> detailSales = [];
  int totalHarga = 0;
  var pelangganController = SingleValueDropDownController();

  excecuteSales() async {
    if (pelangganController.dropDownValue?.name == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Pilih pelanggan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1500),
      ));
    } else if (selectedProduk.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Isi data barang yang dibeli',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      var penjualan = await Supabase.instance.client
          .from('penjualan')
          .insert({
            'idPelanggan': pelangganController.dropDownValue!.value,
            'TotalHarga': totalHarga
          })
          .select()
          .single();

      if (penjualan.isNotEmpty) {
        for (var i = 0; i < selectedProduk.length; i++) {
          detailSales.add({
            'idPenjualan': penjualan['idPenjualan'],
            'idProduk': selectedProduk[i]['id'],
            'jumlahProduk': (selectedProduk[i]['jumlahProduk'] as int),
            'subtotal': (selectedProduk[i]['subtotal'] as int)
          });
        }
        ;

        var detail = await Supabase.instance.client
            .from('detailPenjualan')
            .insert(detailSales);
        if (detail == null) {
          for (var i = 0; i < selectedProduk.length; i++) {
            selectedProduk[i].remove('subtotal');
            selectedProduk[i]['Stok'] -= selectedProduk[i]['jumlahProduk'];
            selectedProduk[i].remove('jumlahProduk');
          }

          var produkUpdate = await Supabase.instance.client
              .from('produk')
              .upsert(selectedProduk);
          if (produkUpdate == null) {
            Navigator.pop(context, 'success');
          }
        }
      }
    }
  }
  // List? updatedProduk;
  // int idPelanggan;
  // List<int>? jumlahBarang;

  addProductSales() {
    var produkController = SingleValueDropDownController();
    var jumlahController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: formKeyProduk,
            child: AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  children: [
                    DropDownTextField(
                      dropDownList: [
                        ...List.generate(
                            produk.where((item) => item['Stok'] >= 1).length,
                            (index) {
                          return DropDownValueModel(
                              name:
                                  '${produk[index]['Nama']}(Stok:${produk[index]['Stok']})',
                              value: produk[index]);
                        })
                      ],
                      controller: produkController,
                      enableSearch: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih barang yang dibeli';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: jumlahController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah barang yang dibeli tidak boleh kosong';
                        } else if (int.parse(value) >
                            produkController.dropDownValue!.value['Stok']) {
                          return 'Jumlah yang dibeli melebihi stok yang tersedia';
                        }

                        return null;
                      },
                    )
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (formKeyProduk.currentState!.validate()) {
                        produkController.dropDownValue!.value['jumlahProduk'] =
                            int.parse(jumlahController.text);
                        produkController.dropDownValue!.value['subtotal'] =
                            produkController.dropDownValue!.value['Harga'] *
                                int.parse(jumlahController.text);
                        totalHarga += (produkController
                            .dropDownValue!.value['subtotal'] as int);
                        Navigator.pop(
                            context, produkController.dropDownValue!.value);
                      }
                    },
                    child: Text('Tambah'))
              ],
            ),
          );
        });
  }

  return showDialog(
    context: context,
    builder: (context) {
      // return StatefulBuilder(
      // builder: (context, setState)
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Text('Penjualan'),
              titleTextStyle:
                  GoogleFonts.lato(fontSize: 20, color: Colors.white),
              backgroundColor: Color.fromARGB(255, 164, 42, 215),
              content: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 249, 246, 222),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Form(
                  key: formKeyPenjualan,
                  child: Container(
                      padding: EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropDownTextField(
                                enableSearch: true,
                                controller: pelangganController,
                                dropDownList: [
                                  DropDownValueModel(
                                      name: 'Pelanggan non member',
                                      value: null),
                                  ...List.generate(pelanggan.length, (index) {
                                    return DropDownValueModel(
                                        name:
                                            '${pelanggan[index]['nama']} (${pelanggan[index]['noTelp']})',
                                        value: pelanggan[index]['idPelanggan']);
                                  })
                                ]),
                            Container(
                                height: constraint.maxHeight / 2,
                                width: constraint.maxWidth / 1.05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.purple)),
                                child: selectedProduk.isNotEmpty
                                    ? ListView(
                                        children: [
                                          ...List.generate(
                                              selectedProduk.length, (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                elevation: 15,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(selectedProduk[
                                                              index]['Nama']),
                                                          Text(
                                                              'Jumlah dibeli:${selectedProduk[index]['jumlahProduk']}'),
                                                          Text(
                                                              'Subtotal:${selectedProduk[index]['subtotal']}')
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(
                                                              () {
                                                                selectedProduk
                                                                    .removeAt(
                                                                        index);
                                                              },
                                                            );
                                                          },
                                                          icon: Icon(
                                                              Icons.delete)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })
                                        ],
                                      )
                                    : Center(
                                        child: Text(
                                            'Tambahkan barang dan jumlah yang  dibeli')))
                          ],
                        );
                      })),
                ),
              ),
              actions: [
                Text(
                  'Total harga: ${totalHarga}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var newProduct = await addProductSales();
                      if (newProduct != null) {
                        setState(
                          () {
                            selectedProduk.add(newProduct);
                          },
                        );
                      }
                    },
                    child: Text('Tambah Barang'))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  excecuteSales();
                },
                child: Text('Simpan penjualan'))
          ],
        );
      });
    },
  );
  // });
}
