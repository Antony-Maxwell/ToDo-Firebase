import 'package:intl/intl.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/models/FTodo.dart';
import 'package:tasks/utils/appbar/icon_button.dart';
import 'package:tasks/utils/main_screen/task_category.dart';
import 'package:tasks/utils/main_screen/task_listtile.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tasks/utils/widgets.dart';
import 'package:tasks/view/ArrayScreen.dart';
import 'package:tasks/view/TodoScreen.dart';
import '../controllers/authController.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthController authController = Get.find();
  final ArrayController arrayController = Get.put(ArrayController());
  final String uid = Get.find<AuthController>().user!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Padding(
            padding: (MediaQuery.of(context).size.width < 768)
                ? const EdgeInsets.only(left: 0.0)
                : const EdgeInsets.only(left: 15.0),
            child: const Text(
              "Tasks",
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: primaryIcon(Icons.search)),
            MenuIconWidget(authController: authController),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              width: double.infinity,
              padding: (MediaQuery.of(context).size.width < 768)
                  ? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0)
                  : const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 15.0),
              child: Column(
                children: [
                  TaskCategory(arrayController: arrayController),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lists",
                      )),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.37,
                        child: GetX<ArrayController>(
                            init: Get.put<ArrayController>(ArrayController()),
                            builder: (ArrayController arrayController) {
                              return (arrayController.arrays.isEmpty)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Center(
                                          child: Icon(Icons.list,
                                              color: Colors.white, size: 90.0),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Center(
                                            child: Text('Add new lists',
                                                style: buttonTextStyleWhite)),
                                      ],
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          TaskListTile(
                                            uid: uid,
                                            arrayController: arrayController,
                                            index: index,
                                          ),
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                      itemCount: arrayController.arrays.length);
                            }),
                      ),
                    ],
                  )
                ],
              )),
        ),
        floatingActionButton: secondaryButton(() {
          Navigator.of(context)
              .push(Routes.route(const ArrayScreen(), const Offset(0.0, 1.0)));
        }, 'Add list', context));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(color: Color(0xFFA8A8A8), fontSize: 20.0),
            border: InputBorder.none),
        appBarTheme: const AppBarTheme(backgroundColor: tertiaryColor));
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: primaryIcon(Icons.arrow_back));
  @override
  List<Widget> buildActions(BuildContext context) => [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
              onPressed: () {
                if (query.isEmpty) {
                  close(context, null);
                } else {
                  query = '';
                }
              },
              icon: primaryIcon(Icons.close)),
        )
      ];
  @override
  Widget buildResults(BuildContext context) => Container();
  @override
  Widget buildSuggestions(BuildContext context) {
    final ArrayController arrayController = Get.put(ArrayController());
    List<FTodo> filteredTodos = arrayController.allTodos.where((todo) {
      final title = todo.title!.toLowerCase();
      final details = todo.details!.toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input) || details.contains(input);
    }).toList();

    if (query == '') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Icon(Icons.search, color: Colors.white, size: 100.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                "Search for tasks",
                style: infoTextStyle,
              ),
            ),
          ],
        ),
      );
    } else if (query != '' && filteredTodos.isEmpty) {
      var message = '"$query"';
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Icon(Icons.search, color: Colors.white, size: 100.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                "No task with $message",
                style: infoTextStyle,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      var arrayIndex = 0;
                      var todoIndex = 0;
                      for (var array in arrayController.arrays) {
                        if (array.title == filteredTodos[index].arrayTitle) {
                          arrayIndex = arrayController.arrays.indexOf(array);
                        }
                      }
                      for (var todo
                          in arrayController.arrays[arrayIndex].todos!) {
                        if (filteredTodos[index].id == todo.id) {
                          todoIndex = arrayController.arrays[arrayIndex].todos!
                              .indexOf(todo);
                        }
                      }
                      Navigator.of(context).push(
                        Routes.route(
                          TodoScreen(
                            arrayIndex: arrayIndex,
                            todoIndex: todoIndex,
                          ),
                          const Offset(0.0, 1.0),
                        ),
                      );
                    },
                    child: Padding(
                      padding: (MediaQuery.of(context).size.width < 768)
                          ? const EdgeInsets.only(left: 6.5, right: 6.5)
                          : const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: tertiaryColor,
                            borderRadius: BorderRadius.circular(14.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredTodos[index].title!,
                            ),
                            (filteredTodos[index].details != '')
                                ? const SizedBox(height: 5.0)
                                : const SizedBox(),
                            Visibility(
                              visible: filteredTodos[index].details == ''
                                  ? false
                                  : true,
                              child: Text(
                                filteredTodos[index].details!,
                              ),
                            ),
                            Visibility(
                                visible: filteredTodos[index].date == '' &&
                                        filteredTodos[index].time == ''
                                    ? false
                                    : true,
                                child: primaryDivider),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: filteredTodos[index].date == '' &&
                                          filteredTodos[index].time == ''
                                      ? false
                                      : true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      (filteredTodos[index].date !=
                                              DateFormat("MM/dd/yyyy")
                                                  .format(DateTime.now()))
                                          ? '${filteredTodos[index].date!}, ${filteredTodos[index].time}'
                                          : 'Today, ${filteredTodos[index].time}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            primaryDivider,
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                'List: ${filteredTodos[index].arrayTitle}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              separatorBuilder: (_, __) => const SizedBox(
                    height: 15.0,
                  ),
              itemCount: filteredTodos.length));
    }
  }
}
