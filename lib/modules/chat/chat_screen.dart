import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:happy_care/core/themes/colors.dart';
import 'package:happy_care/data/models/room_chat/room_chat_pass.dart';
import 'package:happy_care/modules/chat/chat_controller.dart';
import 'package:happy_care/modules/chat/widget/profile_item.dart';
import 'package:happy_care/modules/chat/widget/room_mess_list_tile.dart';
import 'package:happy_care/modules/main_screen/controller/doctor_controller.dart';
import 'package:happy_care/modules/user/user_controller.dart';
import 'package:happy_care/routes/app_pages.dart';

class ChatScreen extends GetWidget<ChatController> {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: kMainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GetBuilder<UserController>(
                      builder: (controller) {
                        return controller.user.value.profile?.avatar == null
                            ? CircleAvatar(
                                backgroundImage:
                                    Image.asset("assets/images/icon.png").image,
                              )
                            : CircleAvatar(
                                backgroundImage: Image.memory(base64Decode(
                                        controller.user.value.profile!.avatar!))
                                    .image,
                              );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.04,
                ),
                Text(
                  "Trò chuyện",
                  style: GoogleFonts.openSans(
                      color: kMainColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(),
              children: [
                SizedBox(
                  height: size.height * 0.265,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSearchBar(function: () {
                        Get.toNamed(AppRoutes.rChatSearch);
                      }),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Bác sĩ đang trực tuyến",
                          style: GoogleFonts.openSans(
                            color: kMainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.16,
                        child: GetBuilder<DoctorController>(
                            builder: (docController) {
                          final status = docController.status.value;
                          if (status == DocStatus.idle) {
                            return ListView.builder(
                              itemCount: docController.listDoctor.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return ProfileItem(
                                  fullName: docController
                                      .listDoctor[index].profile?.fullname,
                                  size: size,
                                  avatar: docController
                                      .listDoctor[index].profile?.avatar,
                                  function: () async {
                                    await controller
                                        .joinToChatRoom(
                                            doctorId: docController
                                                .listDoctor[index].id)
                                        .then((value) => Get.toNamed(
                                            AppRoutes.rChatRoom,
                                            arguments: docController
                                                .listDoctor[index]));
                                  },
                                  isOnline:
                                      docController.listDoctor[index].isOnline!,
                                );
                              },
                            );
                          } else if (status == DocStatus.loading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Center(
                                child: Icon(
                              Icons.error_rounded,
                              color: kMainColor,
                            ));
                          }
                        }),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final status = controller.status.value;
                  if (status == ChatStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kMainColor,
                      ),
                    );
                  } else if (status == ChatStatus.error) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error,
                            color: kMainColor,
                          ),
                          Text(
                            "Có lỗi xảy ra, vui lòng thử lại",
                            style: GoogleFonts.openSans(
                              color: kMainColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (controller.listRoom.isEmpty) {
                      return Center(
                        child: Text(
                          "Bạn chưa có cuộc tư vấn nào",
                          style: GoogleFonts.openSans(
                            color: kMainColor,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.only(),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: controller.listRoom.length,
                        itemBuilder: (context, index) {
                          return RoomMessListTile(
                            function: () async {
                              await controller
                                  .joinToChatRoom(
                                      doctorId: controller
                                          .listUserChatWithByRoom[index].id)
                                  .then((value) => Get.toNamed(
                                          AppRoutes.rChatRoom,
                                          arguments: RoomChatPass(controller.listRoom[index].id!, controller
                                          .listUserChatWithByRoom[index])));
                            },
                            title: controller.listUserChatWithByRoom[index]
                                    .profile?.fullname ??
                                'Bác sĩ ${controller.listUserChatWithByRoom[index].email}',
                            avatar: controller
                                .listUserChatWithByRoom[index].profile?.avatar,
                          );
                        },
                      );
                    }
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar({required void Function() function}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(
          left: 15,
          right: 30,
        ),
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kSecondColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: kMainColor,
              size: 24,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Tìm kiếm",
              style: GoogleFonts.openSans(
                color: kMainColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
