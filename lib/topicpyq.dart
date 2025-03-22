import 'package:exammate/pyqdisplay.dart';
import 'package:exammate/utils/button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Topic extends StatefulWidget {
  const Topic({super.key});

  @override
  State<Topic> createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  String? selectedSchool,
      selectedBranch,
      selectedSemester,
      selectedSubject,
      selectedTopic;
  bool enableBranch = false, enableSemester = false, enableSubject = false;
  bool isLoading = false;

  final Map<String, List<String>> branches = {
    "School of Computer Engineering": ["CSE", "IT", "CSSE", "CSCE"],
    "School of Electronics Engineering": ["EEE", "ETC", "ECSE"],
  };

  final Map<String, List<String>> subjects = {
    "CSE": ["DSA", "OOP", "DBMS"],
    "IT": ["CN", "SE", "AI"],
    "CSSE": ["Cyber Security", "Cloud Computing"],
    "CSCE": ["IoT", "Blockchain"],
    "EEE": ["Power Systems", "Control Systems"],
    "ETC": ["VLSI", "Embedded Systems"],
    "ECSE": ["Analog Circuits", "Digital Signal Processing"],
  };

  final Map<String, List<String>> semesterSubjects = {
    "Semester 1": [
      "Physics",
      "DE&LA",
      "Science of Living Systems",
      "Environmental Science",
      "Elements of Machine Learning",
      "Engineering Mechanics",
      "Biomedical Engineering",
      "Basic Instrumentation",
      "Nano-Science",
      "Smart Materials",
      "Molecular Diagnostics",
      "Science of Public Health",
      "Optimization Techniques",
    ],
    "Semester 2": [
      "Chemistry",
      "Transform Calculus & Numerical Analysis",
      "English",
      "Basic Civil Engineering",
      "Basic Mechanical Engineering",
      "Basic Electrical Engineering",
    ],
    "Semester 3": [
      "Scientific and Technical Writing",

      "Probability and Statistics"
          "Industry 4.0 Technologies 2",

      "Data Structures",

      "Digital Systems Design",

      "Automata Theory and Formal Languages",

      "Organizational Behavior",

      "Economics of Development",

      "International Economic Cooperation",
      "OOP",
    ],
    "Semester 4": [
      "Scientific and Technical Writing",
      "Discrete Structures",
      "Operating Systems",

      "Object Oriented Programming in JAVA",
      "Database Management Systems",
      "Computer Organization and Architecture"
          "Organizational Behavior",
      "Economics of Development",
      "International Economic Cooperation",
    ],
    "Semester 5": [
      "Software Engineering",
      "Computer Networks",
      "Design & Analysis of Algorithms",
      "Engineering Economics & Costing",
      "Distributed Operating Systems"
          "Computational Intelligence",
      "High Performance Computing",
      "ARM and Advanced Microprocessors",
      "Multi-Core Programming"
          "Compiler",
      "Data Mining and Data Warehousing",
      "Image Processing and Applications",
    ],
  };

  final List<String> semesters = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
  ];

  final Map topics = {
    "Data Structures": ["Arrays", "Linked Lists"],
    "Operating Systems": ["Process Management", "Memory Management"],
    "OOP": ["Encapsulation", "Heirarchichal Inheritence"],
    "Discrete Mathematics": [""],
  };

  bool areAllFieldsFilled() {
    return selectedSchool != null &&
        selectedBranch != null &&
        selectedSemester != null &&
        selectedSubject != null;
  }

  String mapSchoolToServerFormat(String school) {
    switch (school) {
      case "School of Computer Engineering":
        return "SCSE";
      case "School of Electronics Engineering":
        return "SEEE";
      default:
        return school;
    }
  }

  String mapSemesterToServerFormat(String semester) {
    return semester.replaceAll("Semester ", "");
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final String serverSchool = mapSchoolToServerFormat(selectedSchool!);
    final String serverSemester = mapSemesterToServerFormat(selectedSemester!);

    try {
      final Uri url = Uri.parse(
        'https://krs-hackathon-server.vercel.app/api/data/pdf',
      ).replace(
        queryParameters: {
          'school': serverSchool,
          'branch': selectedBranch,
          'semester': serverSemester,
          'subject': selectedSubject,
        },
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Recieved data')));

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    TopicWiseQuestions(data: response.body),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.1, end: 1).animate(animation),
                child: child,
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/dash.jpg"),
          opacity: 0.2,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.black),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ExamMate",
                  style: TextStyle(
                    color: Color.fromARGB(255, 39, 207, 193),
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: h * 0.05),
                Text(
                  "Select your course details",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: h * 0.02),
                Card(
                  shadowColor: Color.fromARGB(255, 39, 207, 193),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),

                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            hint: Text("Select school"),
                            value: selectedSchool,
                            items:
                                branches.keys.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSchool = newValue;
                                selectedBranch = null;
                                selectedSemester = null;
                                selectedSubject = null;
                                enableBranch = true;
                                enableSemester = false;
                                enableSubject = false;
                              });
                            },
                          ),
                          SizedBox(height: h * 0.05),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),

                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            hint: Text("Select branch"),
                            value: selectedBranch,
                            items:
                                (selectedSchool != null &&
                                            branches[selectedSchool] != null
                                        ? branches[selectedSchool]!
                                        : <String>[])
                                    .map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                    .toList(),
                            onChanged:
                                enableBranch
                                    ? (String? newValue) {
                                      setState(() {
                                        selectedBranch = newValue;
                                        selectedSemester = null;
                                        selectedSubject = null;
                                        enableSemester = true;
                                        enableSubject = false;
                                      });
                                    }
                                    : null,
                          ),
                          SizedBox(height: h * 0.05),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),

                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),

                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            hint: Text("Select semester"),
                            value: selectedSemester,
                            items:
                                semesters.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged:
                                enableSemester
                                    ? (String? newValue) {
                                      setState(() {
                                        selectedSemester = newValue;
                                        selectedSubject = null;
                                        enableSubject = true;
                                      });
                                    }
                                    : null,
                          ),
                          SizedBox(height: h * 0.05),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(98, 39, 207, 193),
                                  width: 3,
                                ),

                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            hint: Text("Select subject"),
                            value: selectedSubject,
                            items:
                                (selectedSemester != null &&
                                            semesterSubjects.containsKey(
                                              selectedSemester,
                                            )
                                        ? semesterSubjects[selectedSemester]!
                                        : <String>[])
                                    .map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.7, // Prevents overflow
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                            onChanged:
                                enableSubject
                                    ? (String? newValue) {
                                      setState(() {
                                        selectedSubject = newValue;
                                      });
                                    }
                                    : null,
                            selectedItemBuilder: (BuildContext context) {
                              return (selectedSemester != null &&
                                          semesterSubjects.containsKey(
                                            selectedSemester,
                                          )
                                      ? semesterSubjects[selectedSemester]!
                                      : <String>[])
                                  .map<Widget>((String value) {
                                    return Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    );
                                  })
                                  .toList();
                            },
                          ),
                          SizedBox(height: h * 0.05),

                          CustomButton(
                            label: "Submit",
                            color: Color.fromARGB(255, 39, 207, 193),
                            onPressed: fetchData,
                            textcolor: Colors.black,
                            height: h * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
