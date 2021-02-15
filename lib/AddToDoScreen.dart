import 'package:flutter/material.dart';
import 'package:flutter_app/providers.dart';
import 'package:flutter_riverpod/all.dart';

import 'MainScreen.dart';
import 'RandomColors.dart';
import 'design.dart';

class AddToDoScreen extends StatelessWidget {
  final Function() action;

  final todoField = TextEditingController();

  final checkValueProvider = StateProvider<bool>((_) => false);
  //TODO:add DateTIme logic
  AddToDoScreen({this.action});
  @override
  Widget build(BuildContext context) {
    // final dateTime = watch(dateTimeProvider).dateTime;
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: CustomColors.backgroundColor,
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ))),
              child: Container(
                height: 120,
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                        alignment: Alignment.bottomLeft,
                        margin:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 25),
                        child: Text(
                          'Add ToDO',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                        )),
                    Positioned(
                      child: FloatingActionButton(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      bottom: -30,
                      left: 10,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                            padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.notes_rounded,
                              size: 28,
                              color: Colors.white,
                            )),
                        flex: 3,
                      ),
                      Flexible(
                        child: CustomTextFormInput(
                          borderColor: Colors.white,
                          labelText: "note",
                          validator: normalValidator,
                          textEditingController: todoField,
                          icon: Icons.notes_rounded,
                        ),
                        flex: 9,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Priority',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: Consumer(
                          builder: (context, watch, child) {
                            return Slider(
                                divisions: 4,
                                label: watch(sliderProvider)
                                    .sliderValue
                                    .toString(),
                                min: 1,
                                max: 5,
                                value: watch(sliderProvider).sliderValue,
                                onChanged: (val) => context
                                    .read(sliderProvider)
                                    .updateValue(val));
                          },
                        ),
                        flex: 8,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(right: 25),
                          child: Text(
                            'Date',
                            textAlign: TextAlign.end,
                          ).whiteText(),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: FlatButton(onPressed: () async {
                          FocusScope.of(context).unfocus();
                          setDate(context);
                        }, child: Consumer(
                          builder: (context, watch, child) {
                            return Text(watch(dateTimeProvider).dateTime == null
                                    ? 'Pick Date (Optional)'
                                    : watch(dateTimeProvider)
                                            .dateTime
                                            .difference(DateTime.now())
                                            .inHours
                                            .toString() +
                                        ' hours tap here to Edit')
                                .whiteText();
                          },
                        )),
                        flex: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Show In Notification?').whiteText(),
                      Consumer(
                        builder: (context, watch, child) {
                          return Theme(
                            data:
                                ThemeData(unselectedWidgetColor: Colors.white),
                            child: Checkbox(
                                checkColor: Colors.white,
                                focusColor: Colors.grey,
                                value: watch(checkValueProvider).state,
                                onChanged: (newVal) {
                                  context.read(checkValueProvider).state =
                                      newVal;
                                }),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.pop(
                          context,
                          AddToDoData(
                              task: todoField.text,
                              priority: context
                                  .read(sliderProvider)
                                  .sliderValue
                                  .toInt(),
                              datetime: context.read(dateTimeProvider).dateTime,
                              tobeShownInNotification:
                                  context.read(checkValueProvider).state));
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label: Text('Add').whiteText(),
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: action,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      // child: Container(
      //   height: 50,
      //   child: Row(
      //     children: [
      //       IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
      //       Navigator.pop(context);
      //       }),
      //     ],
      //   ),
      // ),
      // ),
    );
  }

  void setDate(BuildContext context) async {
    DateTime _tempVar = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
    if (_tempVar != null) context.read(dateTimeProvider).updateDate(_tempVar);
  }
}