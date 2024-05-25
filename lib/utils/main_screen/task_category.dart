
import 'package:flutter/material.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/utils/widgets.dart';

class TaskCategory extends StatelessWidget {
  const TaskCategory({
    super.key,
    required this.arrayController,
  });

  final ArrayController arrayController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        filteredWidget(context, 'Scheduled', 'No scheduled tasks',
            arrayController.scheduledTodos, Icons.schedule),
        filteredWidget(
            context,
            'Today',
            'No tasks scheduled for today',
            arrayController.todayTodos,
            Icons.calendar_today),
      ],
    ),
    const SizedBox(
      height: 20.0,
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        filteredWidget(context, 'Completed', 'No completed tasks',
            arrayController.doneTodos, Icons.done_rounded),
        filteredWidget(context, 'All', 'No tasks yet',
            arrayController.allTodos, Icons.task)
      ],
    ),
        ],
      ),
    );
  }
}
