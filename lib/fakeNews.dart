import 'dart:convert';

import 'package:fake_news_detection/config/Config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class FakeNews extends StatefulWidget {
  const FakeNews({super.key});

  @override
  State<FakeNews> createState() => _FakeNewsState();
}

class _FakeNewsState extends State<FakeNews> {
  TextEditingController _fakeNewsTitle = TextEditingController();
  double _pointerValue = 50.0; // Initialize to center of "Not Confirmed"
  bool _isloading = false;
  String baseUrl = Config().baseUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text("Enter the News Title, We Will Provide you Status Of News: ",
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: TextFormField(
                        controller: _fakeNewsTitle,
                        decoration: InputDecoration(
                          hintText: 'Enter Title Of News',
                          contentPadding: EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a news title';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          bool? isRealNews = await determineNewsType();
                          print(isRealNews);
                          updateGauge(isRealNews);
                        }
                        // Example logic to update gauge
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.9),
                        elevation: 15,
                        padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 33.33,
                                color: Colors.red.withOpacity(0.8),
                                startWidth: 20, // Reduced width
                                endWidth: 20, // Reduced width
                                label: 'Fake News',
                                labelStyle: GaugeTextStyle(fontSize: 15, color: Colors.white)
                            ),
                            GaugeRange(
                                startValue: 33.33,
                                endValue: 66.66,
                                color: Colors.orange.withOpacity(0.8),
                                startWidth: 20, // Reduced width
                                endWidth: 20, // Reduced width
                                label: 'Not Confirmed',
                                labelStyle: GaugeTextStyle(fontSize: 15, color: Colors.white)),
                            GaugeRange(
                                startValue: 66.66,
                                endValue: 100,
                                color: Colors.green.withOpacity(0.8),
                                startWidth: 20, // Reduced width
                                endWidth: 20, // Reduced width
                                label: 'Real News',
                                labelStyle: GaugeTextStyle(fontSize: 15, color: Colors.white)),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(value: _pointerValue),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Container(
                                child: Text(
                                  'News Status',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.9,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
            if(_isloading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
      ]
        ),
      ),
    );
  }

  // Example logic to determine news type (replace with your actual logic)
  Future<bool?> determineNewsType() async {
    bool? value = await checkNews();
    return value;
  }


  Future<bool?> checkNews() async {
    setState(() {
      _isloading = true;
    });
    try {
      final response = await http.get(Uri.parse("$baseUrl/fakeNews/getNews/${_fakeNewsTitle.text}"));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final label = responseData['data']['Label'];
        if (label == 'true') {
          setState(() {
            _isloading = false;
          });
          Fluttertoast.showToast(
            msg: "It is a real news",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        } else if (label == 'false') {
          setState(() {
            _isloading = false;
          });
          Fluttertoast.showToast(
            msg: "It is fake News!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 3,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false;
        } else {
          setState(() {
            _isloading = false;
          });
          Fluttertoast.showToast(
            msg: " Sorry AI is not able to decide!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 3,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return null;
        }
      } else {
        setState(() {
          _isloading = false;
        });
        throw Exception('Failed to load Structure type');
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      Fluttertoast.showToast(
        msg: " Sorry AI is not able to decide!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // You might want to handle the error or rethrow it
      return null;
    }
  }


  void updateGauge(bool? isRealNews) {
    setState(() {
      if (isRealNews == true) {
        _pointerValue = 83.33; // Real News (Middle of Real News section)
      } else if (isRealNews == false) {
        _pointerValue = 16.66; // Fake News (Middle of Fake News section)
      } else {
        _pointerValue = 50.0; // Not Confirmed (Middle of Not Confirmed section)
      }
    });
  }


}
