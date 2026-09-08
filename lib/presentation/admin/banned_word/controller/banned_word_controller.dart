import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';
import 'package:train_link/presentation/admin/banned_word/view/list_banned_words_view.dart';

import '../../../../core/app_export.dart';
import '../model/banned_word_model.dart';
import '../view/add_banned_word_view.dart';

class BannedWordController extends GetxController {
  final RxList<BannedWord> bannedWords = <BannedWord>[].obs;
  final RxList<String> categories = [
    'عام',
    'عنصري',
    'سياسي',
    'ديني',
    'إباحي',
  ].obs;
  final formKey = GlobalKey<FormState>();
  final wordController = TextEditingController();
  final isEditing = false.obs;
  final editingId = ''.obs;
  final isActive = true.obs;

  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );
  final AdminRemoteDataSource adminRemoteDataSource =
      Get.find<AdminRemoteDataSourceImpl>();

  @override
  void onInit() {
    fetchBannedWords();
    super.onInit();
  }

  Future<void> fetchBannedWords() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await adminRemoteDataSource.getAllBannedWords()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        bannedWords.value = r;
        flowState.value = ContentState();
      },
    );
  }

  Future<void> addOrUpdateBannedWord() async {
    if (!formKey.currentState!.validate()) return;

    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    final bannedWord = BannedWord(
      id: isEditing.value
          ? editingId.value
          : DateTime.now().millisecondsSinceEpoch.toString(),
      word: wordController.text.trim(),
      createdAt: DateTime.now(),
    );

    if (isEditing.value) {
      (await adminRemoteDataSource.updateBannedWord(bannedWord)).fold(
        (l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r) async {
          await fetchBannedWords();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم تحديث الكلمة المحظورة بنجاح',
          );
        },
      );
    } else {
      (await adminRemoteDataSource.addBannedWord(bannedWord)).fold(
        (l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r) async {
          await fetchBannedWords();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم إضافة الكلمة المحظورة بنجاح',
          );
        },
      );
    }
    clearForm();

  }

  void editBannedWord(BannedWord bannedWord) {
    isEditing.value = true;
    editingId.value = bannedWord.id;
    wordController.text = bannedWord.word;
    //  Get.toNamed(Routes.ADD_BANNED_WORD);
    Get.dialog(AddBannedWordView());
  }

  Future<void> deleteBannedWord(String id) async {
    Get.defaultDialog(
      title: 'حذف الكلمة المحظورة',
      content: Text(
        'هل أنت متأكد من رغبتك في حذف هذه الكلمة؟',
        textDirection: TextDirection.rtl,
      ),
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        flowState.value = LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
        );
        Get.back();
        (await adminRemoteDataSource.deleteBannedWord(id)).fold(
          (l) {
            flowState.value = ErrorState(
              StateRendererType.popupErrorState,
              l.message,
            );
          },
          (r) async {
            await fetchBannedWords();
            flowState.value = SuccessState(
              StateRendererType.popupSuccessState,
              'تم حذف الكلمة المحظورة بنجاح',
            );
          },
        );

      },
    );
  }


  void clearForm() {
    wordController.clear();
    isActive.value = true;
    isEditing.value = false;
    editingId.value = '';
  }

  @override
  void onClose() {
    wordController.dispose();
    super.onClose();
  }
}

extension BannedWordExtension on BannedWord {
  BannedWord copyWith({
    String? id,
    String? word,
    String? reason,
    String? category,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return BannedWord(
      id: id ?? this.id,
      word: word ?? this.word,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
