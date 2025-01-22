import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_flutter/barang/transaksi.dart';
import 'package:ukk_flutter/user/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://fhdchhzmjajsyloogyvd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZoZGNoaHptamFqc3lsb29neXZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTI5MDYsImV4cCI6MjA0NzEyODkwNn0.Ll3x7fBm2G5NhXZ3EA80sJQIj0VWb8RUJ00AAMjQWWk');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var emailController = TextEditingController();
  var pwController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Form(
          key: formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                        Color.fromARGB(255, 143, 13, 249),
                        Color.fromARGB(255, 189, 114, 251),
                        Color.fromARGB(255, 216, 176, 249),
                      ],
                          // stops: [0, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.center)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 8,
                      ),
                      Text('Welcome',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height / 15)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      Text('Our beloved casier',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height / 35)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow()
                            // ],
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  MediaQuery.of(context).size.height / 9),
                              topRight: Radius.circular(
                                  MediaQuery.of(context).size.height / 9),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 15,
                              left: MediaQuery.of(context).size.height / 17,
                              right: MediaQuery.of(context).size.height / 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              50)),
                                      color: Colors.white,
                                      // border: Border.all(color: Colors.grey.shade200),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 30,
                                            offset: const Offset(0, 10),
                                            color: Colors.purple.shade200)
                                      ]),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors
                                                        .purple.shade200))),
                                        // color: Colors.blue,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5 /
                                                2,
                                        child: Center(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Email kosong';
                                              }
                                              return null;
                                            },
                                            controller: emailController,
                                            style: GoogleFonts.lato(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    40),
                                            decoration: InputDecoration(
                                                labelText: 'Email',
                                                labelStyle: GoogleFonts.lato(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            35),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        // color: Colors.red,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5 /
                                                2,
                                        child: Center(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Password kosong';
                                              }
                                              return null;
                                            },
                                            controller: pwController,
                                            style: GoogleFonts.lato(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    40),
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                labelText: 'Password',
                                                labelStyle: GoogleFonts.lato(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            35),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginFunction(emailController.text,
                                        pwController.text, context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 20,
                                    backgroundColor: const Color.fromARGB(
                                        255, 189, 114, 251),
                                    foregroundColor: Colors.white,
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width / 1.5,
                                        MediaQuery.of(context).size.height /
                                            15)),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 35,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Dont have an acount yet?',
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                58),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Register here',
                                      style: GoogleFonts.lato(
                                          decorationColor: const Color.fromARGB(
                                              255, 189, 114, 251),
                                          decoration: TextDecoration.underline,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              58),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                  // width: MediaQuery.of(context),
                )
              ],
            ),
          ),
        )
      ],
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
