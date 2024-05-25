// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/models/Todo.dart';
import 'package:tasks/services/functions.service.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/appbar/to_do_appbar.dart';
import 'package:tasks/utils/global.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/utils/todo/todo_textfeild.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/utils/widgets.dart';

final formKey = GlobalKey<FormState>();

class TodoScreen extends StatefulWidget {
  final int? todoIndex;
  final int? arrayIndex;

  const TodoScreen({Key? key, this.todoIndex, this.arrayIndex})
      : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ArrayController arrayController = Get.find();
  final AuthController authController = Get.find();
  final String uid = Get.find<AuthController>().user!.uid;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController titleEditingController;
  late TextEditingController detailEditingController;

  late String _setTime, _setDate;
  late String _hour, _minute, _time;
  late String dateTime;
  late bool done;

  @override
  void initState() {
    super.initState();
    String title = '';
    String detail = '';
    String date = '';
    String? time = '';

    if (widget.todoIndex != null) {
      title = arrayController
              .arrays[widget.arrayIndex!].todos![widget.todoIndex!].title ??
          '';
      detail = arrayController
              .arrays[widget.arrayIndex!].todos![widget.todoIndex!].details ??
          '';
      date = arrayController
          .arrays[widget.arrayIndex!].todos![widget.todoIndex!].date!;
      time = arrayController
          .arrays[widget.arrayIndex!].todos![widget.todoIndex!].time;
    }

    _dateController = TextEditingController(text: date);
    _timeController = TextEditingController(text: time);
    titleEditingController = TextEditingController(text: title);
    detailEditingController = TextEditingController(text: detail);
    done = (widget.todoIndex == null)
        ? false
        : arrayController
            .arrays[widget.arrayIndex!].todos![widget.todoIndex!].done!;
  }

  @override
  void dispose() {
    super.dispose();
    titleEditingController.dispose();
    detailEditingController.dispose();
    _timeController.dispose();
    _dateController.dispose();
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(
      hour: (TimeOfDay.now().minute > 55)
          ? TimeOfDay.now().hour + 1
          : TimeOfDay.now().hour,
      minute: (TimeOfDay.now().minute > 55) ? 0 : TimeOfDay.now().minute + 5);

  Future<DateTime?> _selectDate() => showDatePicker(
      builder: (context, child) {
        return datePickerTheme(child);
      },
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5));

  Future<TimeOfDay?> _selectTime() => showTimePicker(
      builder: (context, child) {
        return timePickerTheme(child);
      },
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input);

  Future _pickDateTime() async {
    DateTime? date = await _selectDate();
    if (date == null) return;
    if (date != null) {
      selectedDate = date;
      _dateController.text = DateFormat("MM/dd/yyyy").format(selectedDate);
    }
    TimeOfDay? time = await _selectTime();
    if (time == null) {
      _timeController.text = formatDate(
          DateTime(
              DateTime.now().year,
              DateTime.now().day,
              DateTime.now().month,
              DateTime.now().hour,
              DateTime.now().minute + 5),
          [hh, ':', nn, " ", am]).toString();
    }
    if (time != null) {
      selectedTime = time;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = '$_hour : $_minute';
      _timeController.text = _time;
      _timeController.text = formatDate(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
          [hh, ':', nn, " ", am]).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool visible =
        (_dateController.text.isEmpty && _timeController.text.isEmpty)
            ? false
            : true;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text((widget.todoIndex == null) ? 'New Task' : 'Edit Task',
              style: menuTextStyle),
          leadingWidth:
              (MediaQuery.of(context).size.width < 768) ? 90.0 : 100.0,
          leading: Center(
            child: Padding(
              padding: (MediaQuery.of(context).size.width < 768)
                  ? const EdgeInsets.only(left: 0)
                  : const EdgeInsets.only(left: 21.0),
              child: TextButton(
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel",
                  style: paragraphPrimary,
                ),
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButtonAppbarToDo(widget: widget, hashCode: hashCode, arrayController: arrayController, titleEditingController: titleEditingController, detailEditingController: detailEditingController, dateController: _dateController, timeController: _timeController, uid: uid, done: done)
          ],
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: (MediaQuery.of(context).size.width < 768)
                ? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0)
                : const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
            child: Column(
              children: [
                ToDoTextFeild(titleEditingController: titleEditingController, detailEditingController: detailEditingController),
                Visibility(
                  visible: (widget.todoIndex != null) ? true : false,
                  child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: tertiaryColor,
                          borderRadius: BorderRadius.circular(14.0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Completed",
                          ),
                          Transform.scale(
                            scale: 1.3,
                            child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: const Color.fromARGB(
                                        255, 187, 187, 187)),
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    checkColor: Colors.white,
                                    activeColor: primaryColor,
                                    value: done,
                                    side: Theme.of(context).checkboxTheme.side,
                                    onChanged: (value) {
                                      setState(() {
                                        done = value!;
                                      });
                                    })),
                          )
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () async {
                    await _pickDateTime();
                    setState(() {
                      visible = true;
                    });
                  },
                  child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 15.0),
                      decoration: BoxDecoration(
                          color: tertiaryColor,
                          borderRadius: BorderRadius.circular(14.0)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  enabled: false,
                                  controller: _dateController,
                                  onChanged: (String val) {
                                    _setDate = val;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Date",
                                      hintStyle: hintTextStyle,
                                      border: InputBorder.none),
                                  // style: todoScreenStyle,
                                ),
                              ),
                              visible
                                  ? IconButton(
                                      onPressed: () {
                                        _dateController.clear();
                                        _timeController.clear();
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ))
                                  : Container()
                            ],
                          ),
                          primaryDivider,
                          TextField(
                            onChanged: (String val) {
                              _setTime = val;
                            },
                            enabled: false,
                            controller: _timeController,
                            decoration: InputDecoration(
                                hintText: "Enter",
                                hintStyle: hintTextStyle,
                                border: InputBorder.none),
                            // style: todoScreenStyle,
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
