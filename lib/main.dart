import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_flutter/transaksi.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Center(
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
                            fontSize: MediaQuery.of(context).size.height / 15)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Text('Our beloved casier',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 35)),
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
                                height: MediaQuery.of(context).size.height / 5,
                                // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.height /
                                                50)),
                                    color: Colors.white,
                                    // border: Border.all(color: Colors.grey.shade200),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 30,
                                          offset: Offset(0, 10),
                                          color: Colors.purple.shade200)
                                    ]),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.purple.shade200))),
                                      child: Center(
                                        child: TextField(
                                          textAlignVertical: TextAlignVertical.top,
                                          style: GoogleFonts.lato(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40),
                                          decoration: InputDecoration(
                                            
                                              hintText: 'Email',
                                              hintStyle: GoogleFonts.lato(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          35),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      // color: Colors.blue,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5 /
                                              2,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Center(
                                        child: TextField(
                                          style: GoogleFonts.lato(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40),
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              hintText: 'Password',
                                              hintStyle: GoogleFonts.lato(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          35),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      // color: Colors.red,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5 /
                                              2,
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Transaction()));
                              },
                              child: Text(
                                'Login',
                                style: GoogleFonts.lato(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 35,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  backgroundColor:
                                      Color.fromARGB(255, 189, 114, 251),
                                  foregroundColor: Colors.white,
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width / 1.5,
                                      MediaQuery.of(context).size.height / 15)),
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
                                              55),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Register here',
                                    style: GoogleFonts.lato(
                                        decorationColor:
                                            Color.fromARGB(255, 189, 114, 251),
                                        decoration: TextDecoration.underline,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                55),
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
      ],
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
