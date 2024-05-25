
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/View/DeleteScreen.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/widgets.dart';

class MenuIconWidget extends StatelessWidget {
  const MenuIconWidget({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (MediaQuery.of(context).size.width < 768)
          ? const EdgeInsets.only(right: 0.0)
          : const EdgeInsets.only(right: 25.0),
      child: IconButton(
          onPressed: () {
            showModalBottomSheet<void>(
              backgroundColor: tertiaryColor,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.only(top: 15.0),
                  height: 260,
                  child: ListView(children: [
                    const SizedBox(height: 10.0),
                    Center(
                      child: Icon(
                        Icons.account_circle,
                        size: 40.0,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Center(
                        child: Text(
                      authController.user!.email ?? '',
                      style: accountTextStyle,
                    )),
                    const SizedBox(height: 15.0),
                    primaryDivider,
                    ListTile(
                      title: Text(
                        "Sign out",
                       
                      ),
                      leading: Icon(
                        Icons.logout,
                        color: primaryColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        authController.signOut(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Delete account",
                        // style: optionsTextStyle,
                      ),
                      leading: Icon(
                        Icons.delete,
                        color: primaryColor,
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await showDialog<String>(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) =>
                              AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 37, 37, 37),
                            title: const Text('Delete account',
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                                'Are you sure you want to delete your account?',
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 187, 187, 187))),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: Text('Cancel',
                                    style:
                                        TextStyle(color: primaryColor)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context, 'Ok');
                                  Get.to(const DeleteScreen());
                                },
                                child: Text('OK',
                                    style:
                                        TextStyle(color: primaryColor)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]),
                );
              },
            );
          },
          icon: primaryIcon(Icons.menu)),
    );
  }
}
