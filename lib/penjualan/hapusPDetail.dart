import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

hapusDetailPenjualan(int id, BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 249, 197),
          content: Container(
            height: MediaQuery.of(context).size.height/3.5,
            width: MediaQuery.of(context).size.width/1.5,
            child: Center(
              child: Text(
                'Anda yakin menghapus data detail penjualan ini?',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 15,
                backgroundColor: Color.fromARGB(255, 142, 62, 217),
                foregroundColor: Colors.white
              ),
                onPressed: () async {
                  var result = await Supabase.instance.client
                      .from('detailPenjualan')
                      .delete()
                      .eq('idDetail', id);

                  if (result == null) {
                    Navigator.pop(context,true);
                  }
                },
                child: Text('Hapus'))
          ],
        );
      });
}
