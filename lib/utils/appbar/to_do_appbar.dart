
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tasks/View/TodoScreen.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/models/Todo.dart';
import 'package:tasks/services/Notification.service.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/services/functions.service.dart';
import 'package:tasks/utils/global.dart';

class IconButtonAppbarToDo extends StatelessWidget {
  const IconButtonAppbarToDo({
    super.key,
    required this.widget,
    required this.hashCode,
    required this.arrayController,
    required this.titleEditingController,
    required this.detailEditingController,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required this.uid,
    required this.done,
  }) : _dateController = dateController, _timeController = timeController;

  final TodoScreen widget;
  final int hashCode;
  final ArrayController arrayController;
  final TextEditingController titleEditingController;
  final TextEditingController detailEditingController;
  final TextEditingController _dateController;
  final TextEditingController _timeController;
  final String uid;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: (MediaQuery.of(context).size.width < 768)
            ? const EdgeInsets.only(left: 0)
            : const EdgeInsets.only(right: 21.0),
        child: TextButton(
          style: const ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () async {
            if (widget.todoIndex == null &&
                formKey.currentState!.validate()) {
              var finalId = UniqueKey().hashCode;
              arrayController.arrays[widget.arrayIndex!].todos!
                  .add(Todo(
                title: titleEditingController.text,
                details: detailEditingController.text,
                id: finalId,
                date: _dateController.text,
                time: _timeController.text,
                dateAndTimeEnabled: (_dateController.text != '' &&
                        _timeController.text != '')
                    ? true
                    : false,
                done: false,
                dateCreated: Timestamp.now(),
              ));
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .collection("arrays")
                  .doc(arrayController.arrays[widget.arrayIndex!].id)
                  .set({
                "title":
                    arrayController.arrays[widget.arrayIndex!].title,
                "dateCreated": arrayController
                    .arrays[widget.arrayIndex!].dateCreated,
                "todos": arrayController
                    .arrays[widget.arrayIndex!].todos!
                    .map((todo) => todo.toJson())
                    .toList()
              });
              Database().addAllTodo(
                uid,
                finalId,
                arrayController.arrays[widget.arrayIndex!].title!,
                titleEditingController.text,
                detailEditingController.text,
                Timestamp.now(),
                _dateController.text,
                _timeController.text,
                false,
                (_dateController.text != '' &&
                        _timeController.text != '')
                    ? true
                    : false,
                finalId,
              );
              Get.back();
              HapticFeedback.heavyImpact();
              if (_dateController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty) {
                    final scheduleDateTime = Functions.parse(_dateController.text, _timeController.text);
                    final notificationTime = scheduleDateTime.subtract(const Duration(minutes: 10));
                NotificationService().scheduleNotification(
                  scheduleNotificationDateTime: notificationTime,
                        body: 'Its your time to do your task....',
                        id: finalId,
                        title: 'Reminder'
                        );
              }
            }
            if (widget.todoIndex != null &&
                formKey.currentState!.validate()) {
              var editing = arrayController
                  .arrays[widget.arrayIndex!].todos![widget.todoIndex!];
              editing.title = titleEditingController.text;
              editing.details = detailEditingController.text;
              editing.date = _dateController.text;
              editing.time = _timeController.text;
              editing.done = done;
              editing.dateAndTimeEnabled =
                  (_dateController.text != '' &&
                          _timeController.text != '')
                      ? true
                      : false;
    
              arrayController.arrays[widget.arrayIndex!]
                  .todos![widget.todoIndex!] = editing;
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .collection("arrays")
                  .doc(arrayController.arrays[widget.arrayIndex!].id)
                  .set({
                "title":
                    arrayController.arrays[widget.arrayIndex!].title,
                "dateCreated": arrayController
                    .arrays[widget.arrayIndex!].dateCreated,
                "todos": arrayController
                    .arrays[widget.arrayIndex!].todos!
                    .map((todo) => todo.toJson())
                    .toList()
              });
              Database().updateAllTodo(
                uid,
                arrayController.arrays[widget.arrayIndex!]
                    .todos![widget.todoIndex!].id!, // get doc id
                arrayController.arrays[widget.arrayIndex!].title!,
                titleEditingController.text,
                detailEditingController.text,
                Timestamp.now(),
                _dateController.text,
                _timeController.text,
                done,
                (_dateController.text != '' &&
                        _timeController.text != '')
                    ? true
                    : false,
                arrayController.arrays[widget.arrayIndex!]
                    .todos![widget.todoIndex!].id!,
              );
              Get.back();
              HapticFeedback.heavyImpact();
            }
          },
          child: Text((widget.todoIndex == null) ? 'Add' : 'Update',
              style: paragraphPrimary),
        ),
      ),
    );
  }
}
