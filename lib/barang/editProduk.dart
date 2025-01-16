import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

editDialogue(BuildContext context, Map data) {
  return showDialog(
      context: context,
      builder: (context) {
        return Form(
            child: AlertDialog(
                backgroundColor: Color.fromARGB(255, 255, 253, 205),
                titleTextStyle:
                    GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                title: Text(
                  'Edit data',
                  textAlign: TextAlign.center,
                ),
                content: 
                    Column(
                      children: [
                        TextFormField(
                          initialValue: data["Nama"],
                        ),
                        TextFormField(),
                        TextFormField(),
                        TextFormField(),
                      ],
                    )));
      });
}
