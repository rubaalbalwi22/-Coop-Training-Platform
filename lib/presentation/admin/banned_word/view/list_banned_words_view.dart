import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/presentation/admin/banned_word/view/add_banned_word_view.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/drawer/admin_drawer.dart';
import '../controller/banned_word_controller.dart';

class ListBannedWordsView extends GetWidget<BannedWordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('إدارة الكلمات المحظورة', textDirection: TextDirection.rtl),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.clearForm();
              //  Get.toNamed(Routes.ADD_BANNED_WORD);
              Get.dialog(AddBannedWordView());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: 'بحث في الكلمات المحظورة',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {

              },
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.flowState.value.getScreenWidget(_body(), () {
                controller.flowState.value = ContentState();
              }),
            ),
          ),
        ],
      ),
    );
  }

  _body() => ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: controller.bannedWords.length,
    itemBuilder: (context, index) {
      final bannedWord = controller.bannedWords[index];
      return Card(
        margin: EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(bannedWord.word, textDirection: TextDirection.rtl),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xFF8417F4)),
                onPressed: () => controller.editBannedWord(bannedWord),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteBannedWord(bannedWord.id),
              ),
            ],
          ),
        ),
      );
    },
  );
}
