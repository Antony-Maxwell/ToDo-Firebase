
import 'package:flutter/material.dart';
import 'package:tasks/View/ArrayScreen.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/utils/widgets.dart';

class ToDoTextFeild extends StatelessWidget {
  const ToDoTextFeild({
    super.key,
    required this.titleEditingController,
    required this.detailEditingController,
  });

  final TextEditingController titleEditingController;
  final TextEditingController detailEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: tertiaryColor,
            borderRadius: BorderRadius.circular(14.0)),
        padding: const EdgeInsets.symmetric(
            horizontal: 24.0, vertical: 15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  validator: Validator.titleValidator,
                  controller: titleEditingController,
                  autofocus: true,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  maxLines: 1,
                  maxLength: 25,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      counterStyle: counterTextStyle,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      hintText: "Title",
                      border: InputBorder.none),
                  // style: todoScreenStyle
                  ),
              primaryDivider,
              TextField(
                  controller: detailEditingController,
                  maxLines: null,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      counterStyle: counterTextStyle,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      hintText: "Notes",
                      border: InputBorder.none),
                  // style: todoScreenDetailsStyle
                  ),
            ],
          ),
        ));
  }
}
