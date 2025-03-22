import 'package:flutter/material.dart';
import 'dart:convert';

class TopicWiseQuestions extends StatefulWidget {
  const TopicWiseQuestions({super.key, required this.data});
  final String data;

  @override
  State<TopicWiseQuestions> createState() => _ViewPYQState();
}

class _ViewPYQState extends State<TopicWiseQuestions> {
  late Map<String, dynamic> parsedData;
  List<String> questions = [];
  String selectedTopic = '';
  String selectedSubject = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    parseData();
  }

  void parseData() {
    try {
      parsedData = jsonDecode(widget.data);
      print('Parsed data: $parsedData');
      selectedSubject = "Data Structures";
      selectedTopic = "Arrays";

      if (parsedData.containsKey('response') &&
          parsedData['response'] == 'ok' &&
          parsedData.containsKey('topicData') &&
          parsedData['topicData'].containsKey('questions')) {
        questions = List<String>.from(parsedData['topicData']['questions']);
        print('Questions found: ${questions.length}');
      } else {
        print('Expected data structure not found');
        print('Response key exists: ${parsedData.containsKey('response')}');
        if (parsedData.containsKey('response')) {
          print('Response is ok: ${parsedData['response'] == 'ok'}');
        }
        print('TopicData key exists: ${parsedData.containsKey('topicData')}');
        if (parsedData.containsKey('topicData')) {
          print(
            'Questions key exists: ${parsedData['topicData'].containsKey('questions')}',
          );
        }
        questions = [];
      }
    } catch (e) {
      print('Error parsing data: $e');
      questions = ["Error loading questions. Please try again."];
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 39, 207, 193),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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
              SizedBox(height: 20),
              Text(
                "$selectedSubject - $selectedTopic",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Previous Year Questions",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: "Times New Roman",
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child:
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 39, 207, 193),
                          ),
                        )
                        : questions.isEmpty
                        ? Center(
                          child: Text(
                            "No questions found for this topic.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                        : Card(
                          elevation: 8,
                          shadowColor: Color.fromARGB(100, 39, 207, 193),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                              padding: EdgeInsets.all(10),
                              itemCount: questions.length,
                              separatorBuilder:
                                  (context, index) => Divider(
                                    color: Color.fromARGB(50, 39, 207, 193),
                                    thickness: 1,
                                  ),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            50,
                                            39,
                                            207,
                                            193,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                              255,
                                              39,
                                              207,
                                              193,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Text(
                                          questions[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Text("Year : 20XX"),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
