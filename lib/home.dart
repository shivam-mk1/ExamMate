import 'package:exammate/admin.dart';
import 'package:exammate/topics_pages/topic_selector.dart';
import 'package:exammate/pdf_pages/subject_selector.dart';
import 'package:flutter/material.dart';
import '../utils/button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage("assets/images/dash.jpg"),
          fit: BoxFit.cover,
          opacity: 0.376,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.black),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "ExamMate",
                        style: TextStyle(
                          color: Color.fromARGB(255, 39, 207, 193),
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      child: CircleAvatar(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.upload,
                          color: Color.fromARGB(255, 39, 207, 193),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Admin(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0.1,
                                  end: 1,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: h * 0.08),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 39, 207, 193),
                      width: 5,
                    ),
                  ),
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      return CircleAvatar(
                        radius:
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? MediaQuery.of(context).size.width * 0.3
                                : MediaQuery.of(context).size.height * 0.3,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          "assets/images/scholar.png",
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: h * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hey Scholar",
                      style: TextStyle(
                        fontSize: h * 0.035,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: w * 0.01),
                    Image(
                      image: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/6389/6389595.png",
                      ),
                      height: w * 0.06,
                      width: w * 0.06,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: h * 0.1),
                Column(
                  children: [
                    CustomButton(
                      height: h * 0.08,
                      width: w * 0.6,
                      color: Color(0xff24b5a9),
                      label: "Topic Wise PYQs",
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    TopicSelector(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.1,
                                  end: 1,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      textcolor: Colors.black,
                    ),
                    SizedBox(height: h * 0.05),
                    CustomButton(
                      height: h * 0.08,
                      width: w * 0.6,
                      color: Color(0xff24b5a9),
                      label: "PYQ PDFs",

                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SubjectSelector(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.1,
                                  end: 1,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      textcolor: Colors.black,
                    ),
                    SizedBox(height: h * 0.05),
                    CustomButton(
                      height: h * 0.08,
                      width: w * 0.6,
                      color: Color(0xff24b5a9),
                      label: "Predict Questions",
                      onPressed: () {},
                      textcolor: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
