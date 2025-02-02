import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/produk.dart';
import 'package:ukk_flutter/penjualan/penjualan.dart';

LoginFunction(String email, String password, BuildContext context) async {
  try {
    var response = await Supabase.instance.client
        .from('user')
        .select()
        .eq('email', email)
        .eq('password', password)
        .single();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Penjualan(login: response)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Email atau password salah'),
      backgroundColor: Colors.red,
      
    ));
  }
}
