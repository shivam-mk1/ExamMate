import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PYQDisplay extends StatefulWidget {
  const PYQDisplay({super.key, required this.data});
  final String data;

  @override
  State<PYQDisplay> createState() => _PYQDisplayState();
}

class _PYQDisplayState extends State<PYQDisplay> {
  late Map<String, dynamic> parsedData;
  Map<String, Map<String, List<String>>> yearData = {};
  List<String> years = [];
  bool isLoading = true;

  String? selectedYear;
  bool showMidsemOnly = false;
  bool showEndsemOnly = false;

  @override
  void initState() {
    super.initState();
    parseData();
  }

  void parseData() {
    try {
      parsedData = jsonDecode(widget.data);
      if (parsedData.containsKey('response') &&
          parsedData['response'] == 'ok' &&
          parsedData.containsKey('subjectData') &&
          parsedData['subjectData'].containsKey('years')) {
        years = parsedData["subjectData"]["years"].keys.toList();
        Map<String, dynamic> yearsData = parsedData['subjectData']['years'];
        yearData = yearsData.map((year, exams) {
          return MapEntry(
            year,
            (exams as Map<String, dynamic>).map((examType, urls) {
              return MapEntry(examType, List<String>.from(urls));
            }),
          );
        });
      }
    } catch (e) {
      print("Error occurred: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  List<Map<String, String>> getPdfList() {
    List<Map<String, String>> pdfList = [];
    for (var year in years) {
      if (selectedYear != null && year != selectedYear) continue;

      Map<String, List<String>> examTypes = yearData[year]!;
      for (var examType in examTypes.keys) {
        if (showMidsemOnly && examType != "Midsem") continue;
        if (showEndsemOnly && examType != "Endsem") continue;

        List<String> urls = examTypes[examType]!;
        for (var url in urls) {
          pdfList.add({"year": year, "examType": examType, "url": url});
        }
      }
    }
    return pdfList;
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    List<Map<String, String>> pdfList = getPdfList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage("assets/images/dash.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.black),
          backgroundColor: Colors.transparent,
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
                SizedBox(height: h * 0.01),
                Text(
                  "Previous Year Question Papers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: h * 0.02),
                Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<String>(
                        value: selectedYear,
                        hint: Text(
                          "Year",
                          style: TextStyle(color: Colors.white),
                        ),
                        dropdownColor: Colors.white,
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text("All Years"),
                          ),
                          ...years.map(
                            (year) => DropdownMenuItem<String>(
                              value: year,
                              child: Text(year),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                            showMidsemOnly = false;
                            showEndsemOnly = false;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showMidsemOnly = !showMidsemOnly;
                            if (showMidsemOnly) {
                              showEndsemOnly = false;
                            } // Exclusive filter
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              showMidsemOnly
                                  ? Color.fromARGB(255, 39, 207, 193)
                                  : Colors.white,
                        ),
                        child: Text(
                          "Midsem",
                          style: TextStyle(
                            color:
                                showMidsemOnly
                                    ? Colors.black
                                    : Color.fromARGB(255, 39, 207, 193),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // Endsem Filter Button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showEndsemOnly = !showEndsemOnly;
                            if (showEndsemOnly) {
                              showMidsemOnly = false;
                            } // Exclusive filter
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              showEndsemOnly
                                  ? Color.fromARGB(255, 39, 207, 193)
                                  : Colors.white,
                        ),
                        child: Text(
                          "Endsem",
                          style: TextStyle(
                            color:
                                showEndsemOnly
                                    ? Colors.black
                                    : Color.fromARGB(255, 39, 207, 193),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.02),
                pdfList.isNotEmpty
                    ? Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Color.fromARGB(255, 39, 207, 193),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                          itemCount: pdfList.length,
                          itemBuilder: (context, index) {
                            var pdf = pdfList[index];
                            String year = pdf["year"]!;
                            String examType = pdf["examType"]!;
                            String url = pdf["url"]!;
                            String filename = Uri.parse(url).pathSegments.last;

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PDFViewer(
                                          url: url,
                                          year: year,
                                          type: examType,
                                        ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: h * 0.135,
                                child: Card(
                                  margin: EdgeInsets.all(10),
                                  shadowColor: Color.fromARGB(
                                    255,
                                    39,
                                    207,
                                    193,
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        SizedBox(width: w * 0.05),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                filename,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "$examType - $year",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    : SizedBox(
                      child: Center(
                        child: Text(
                          "No Data Available",
                          style: TextStyle(color: Colors.white, fontSize: 24),
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

class PDFViewer extends StatelessWidget {
  final String url;
  final String year, type;

  const PDFViewer({
    super.key,
    required this.url,
    required this.year,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("$type - $year", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PDF().cachedFromUrl(
            url,
            placeholder:
                (progress) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 39, 207, 193),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("$progress%", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
            errorWidget:
                (error) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      SizedBox(height: 10),
                      Text(
                        error.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
