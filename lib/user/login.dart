import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/transaksi.dart';

LoginFunction(String email, String password, BuildContext context) async {
  try {
    var response = await Supabase.instance.client
        .from('user')
        .select()
        .eq('email', email)
        .eq('password', password)
        .single();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Transaction(user: response)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Email atau password salah'),
      backgroundColor: Colors.red,
    ));
  }
}
