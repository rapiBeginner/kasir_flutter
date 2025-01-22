import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/transaksi.dart';

hapusUserCustomer(
    int idData, String idColumn, String table, BuildContext context) {
  void hapusData() async {
    var response = await Supabase.instance.client
        .from(table)
        .delete()
        .eq(idColumn, idData);
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data berhasil di hapus'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, 'success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Hapus data gagal'),
        backgroundColor: Colors.red,
      ));
    }
  }

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 20,
          backgroundColor: Color.fromARGB(255, 252, 255, 227),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: Text(
                'Anda yakin menghapus data ini?',
                style: GoogleFonts.lato(fontSize: 25),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                hapusData();
              },
              child: Text(
                'Hapus',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.shade700, elevation: 20),
            )
          ],
        );
      });
}
