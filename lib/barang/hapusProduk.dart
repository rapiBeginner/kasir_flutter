import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

hapusDialogue(int id, BuildContext context) {
  void hapusData() async {
    dynamic response;
    var checkDetails = await Supabase.instance.client
        .from('detailPenjualan')
        .select()
        .eq('idProduk', id);
    if (checkDetails.isNotEmpty) {
      var deleteDetails = await Supabase.instance.client
          .from('detailPenjualan')
          .delete()
          .eq('idProduk', id);
      if (deleteDetails == null) {
        response =
            await Supabase.instance.client.from('produk').delete().eq('id', id);
      }
    } else {
      response =
          await Supabase.instance.client.from('produk').delete().eq('id', id);
    }

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
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Center(
              child: Text(
                'Anda yakin menghapus data produk ini?\n Semua data detail penjualan yang terkait dengan produk ini juga akan dihapusF',
                style: GoogleFonts.lato(fontSize: 15),
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
