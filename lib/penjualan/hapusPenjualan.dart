import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

hapusPenjualan(int id, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Center(
              child: Text(
                  'Anda yakin menghapus data penjualan ini?\n Semua data detail pembelian akan ikut dihapus'),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                var result;
                var checkDetails = await Supabase.instance.client
                    .from('detailPenjualan')
                    .select()
                    .eq('idPenjualan', id);
                if (checkDetails.isNotEmpty) {
                  await Supabase.instance.client
                      .from('detailPenjualan')
                      .delete()
                      .eq('idPenjualan', id);
                  await Supabase.instance.client
                      .from('penjualan')
                      .delete()
                      .eq('idPenjualan', id);
                  result = true;
                } else {
                  await Supabase.instance.client
                      .from('penjualan')
                      .delete()
                      .eq('idPenjualan', id);
                  result = true;
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Data telah dihapus'),
                  backgroundColor: Colors.green,
                ));
                Navigator.pop(context, result);
              },
              child: Text('Hapus'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 166, 34, 233),
                  foregroundColor: Colors.white),
            )
          ],
        );
      });
}
