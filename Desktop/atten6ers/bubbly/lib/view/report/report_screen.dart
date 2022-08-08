import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/view/dialog/loader_dialog.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportScreen extends StatefulWidget {
  final int reportType;
  final String id;

  ReportScreen(this.reportType, this.id);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String currentValue = 'Select';
  String reason = '';
  String description = '';
  String contactInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colorPrimaryDark,
        padding: EdgeInsets.only(top: 40),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'Report ${widget.reportType == 1 ? 'Post' : 'User'}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 0.2,
                  color: colorTextLight,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select reason',
                        style:
                            TextStyle(fontSize: 15, fontFamily: fNSfUiMedium),
                      ),
                      Container(
                        width: double.infinity,
                        height: 55,
                        margin: EdgeInsets.only(top: 5, bottom: 20),
                        padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: DropdownButton<String>(
                          value: currentValue,
                          underline: Container(),
                          isExpanded: true,
                          elevation: 16,
                          style: TextStyle(color: colorTextLight),
                          dropdownColor: colorPrimary,
                          onChanged: (String newValue) {
                            currentValue = newValue;
                            setState(() {});
                          },
                          items: <String>[
                            'Select',
                            'Sexual',
                            'Nudity',
                            'Religion',
                            'Other'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontFamily: fNSfUiMedium),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Text(
                        'How it hurts you',
                        style: TextStyle(
                          fontFamily: fNSfUiMedium,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        margin: EdgeInsets.only(top: 5, bottom: 20),
                        padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            hintText: 'Explain briefly',
                            hintStyle: TextStyle(
                              color: colorTextLight,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Colors.white, fontFamily: fNSfUiMedium),
                          onChanged: (value) {
                            description = value;
                          },
                          maxLines: 7,
                          scrollPhysics: BouncingScrollPhysics(),
                        ),
                      ),
                      Text(
                        'Contact detail (Mail or Mobile)',
                        style:
                            TextStyle(fontSize: 15, fontFamily: fNSfUiMedium),
                      ),
                      Container(
                        width: double.infinity,
                        height: 55,
                        margin: EdgeInsets.only(top: 5, bottom: 20),
                        padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            hintText: 'Mail or phone',
                            hintStyle: TextStyle(
                              color: colorTextLight,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            contactInfo = value;
                          },
                          style: TextStyle(
                              color: Colors.white, fontFamily: fNSfUiMedium),
                          maxLines: 1,
                          scrollPhysics: BouncingScrollPhysics(),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          width: 175,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentValue == null ||
                                  currentValue.isEmpty ||
                                  currentValue == 'Select') {
                                showToast('Please select reason');
                                return;
                              }
                              if (description == null || description.isEmpty) {
                                showToast('Please enter description');
                                return;
                              }
                              if (contactInfo == null || contactInfo.isEmpty) {
                                showToast('Please enter contact detail');
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (context) => LoaderDialog(),
                              );
                              ApiService()
                                  .reportUserOrPost(
                                widget.reportType == 1 ? "2" : "1",
                                widget.id,
                                currentValue,
                                description,
                                contactInfo,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(colorTheme),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'Submit'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: fNSfUiSemiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          'By clicking this submit button,you agree that\n'
                          'you are taking all the responsibilities of all the\n'
                          'process that may be done by us or the content\n'
                          'uploader. Click the link below to knowmore\n'
                          'about that',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorTextLight,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Policy center',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorTheme,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colorPrimary,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
