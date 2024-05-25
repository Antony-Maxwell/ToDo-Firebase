
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks/View/ArrayScreen.dart';
import 'package:tasks/View/HomeScreen.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/services/functions.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/routes.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.uid, required this.index, required this.arrayController,
  });

  final String uid;
  final int index;
  final ArrayController arrayController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.of(context).push(
            Routes.route(
                ArrayScreen(
                    index: index,
                    docId: arrayController
                        .arrays[index]
                        .id),
                const Offset(0.0, 1.0)));
      },
      onTap: () {
        Navigator.of(context).push(
            Routes.route(
                HomeScreen(index: index),
                const Offset(1.0, 0.0)));
      },
      child: Dismissible(
        key: UniqueKey(),
        direction:
            DismissDirection.startToEnd,
        onDismissed: (_) {
          HapticFeedback.heavyImpact();
          Functions.deleteArray(uid,
              arrayController, index);
        },
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context)
                  .size
                  .height *
              0.07,
          decoration: BoxDecoration(
              color: tertiaryColor,
              borderRadius:
                  BorderRadius.circular(
                      14.0)),
          child: Padding(
            padding:
                const EdgeInsets.only(
                    right: 25.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets
                              .only(
                          left: 20.0),
                  child: Text(
                    arrayController
                            .arrays[index]
                            .title ??
                        '',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets
                              .only(
                          left: 10.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Text(
                        '${arrayController.arrays[index].todos!.length}',
                      ),
                      Icon(
                        Icons
                            .arrow_forward_ios,
                        color:
                            primaryColor,
                      )
                    ],
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
