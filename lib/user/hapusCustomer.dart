import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

hapusCustomer(int id, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 253, 233),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Center(
              child: Text(
                  'Anda yakin menghapus data pelanggan ini?\n Semua data penjualan dan detail penjualan terkait pelanggan ini juga akan di hapus'),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                var result;
                var checkSales = await Supabase.instance.client
                    .from('penjualan')
                    .select()
                    .eq('idPelanggan', id);
                if (checkSales.isNotEmpty) {
                  List idPenjualan = [];
                  for (var i = 0; i < checkSales.length; i++) {
                    idPenjualan.add(checkSales[i]['idPenjualan']);
                  }
                  var checkSalesDetail = await Supabase.instance.client
                      .from('detailPenjualan')
                      .select()
                      .inFilter('idPenjualan', idPenjualan);
                  if (checkSalesDetail.isNotEmpty) {
                    var deleteDetails = await Supabase.instance.client
                        .from('detailPenjualan')
                        .delete()
                        .inFilter('idPenjualan', idPenjualan);
                    if (deleteDetails == null) {
                      var deleteSales = await Supabase.instance.client
                          .from('penjualan')
                          .delete()
                          .eq('idPelanggan', id);
                      if (deleteSales == null) {
                        result = await Supabase.instance.client
                            .from('pelanggan')
                            .delete()
                            .eq('idPelanggan', id);
                      }
                    }
                  } else {
                    var deleteSales = await Supabase.instance.client
                        .from('penjualan')
                        .delete()
                        .eq('idPelanggan', id);
                    if (deleteSales == null) {
                      result =await Supabase.instance.client
                          .from('pelanggan')
                          .delete()
                          .eq('idPelanggan', id);
                    }
                  }
                } else {
                  result =await Supabase.instance.client
                      .from('pelanggan')
                      .delete()
                      .eq('idPelanggan', id);
                }

                if (result==null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil dihapus'), backgroundColor: Colors.green,));
                  Navigator.pop(context,true);
                }
              },
              child: Text('Hapus'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 167, 57, 240),
                  foregroundColor: Colors.white),
            )
          ],
        );
      });
}
