import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valyuta_kurslari/data/source/remote/response/currency_response.dart';
import 'package:valyuta_kurslari/design/colors.dart';
import 'package:valyuta_kurslari/screen/calculate_screen.dart';

import '../bloc/calculate/calculate_bloc.dart';
import '../bloc/main/main_bloc.dart';
import '../widget/item_language.dart';
import '../widget/item_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.fontTernary,
            title: Text(
              state.lang == 'uz'
                  ? 'Valyuta kurslari'
                  : state.lang == 'ru'
                      ? 'Курс валют'
                      : 'Exchange rates',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
                onPressed: () {
                  _langBottomSheet(context, state.lang ?? 'uz', (lang) {
                    context.read<MainBloc>().add(ChangeLang(lang));
                  });
                },
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                )),
            actions: [
              Text(
                state.currDate ?? "",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              IconButton(
                  onPressed: () {
                    _openDialog(context, state.lang ?? 'uz');
                  },
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                  ))
            ],
          ),
          body: switch (state.status) {
            null => Center(),
            Status.loading => Center(child: CircularProgressIndicator()),
            Status.error => Center(child: Text(state.errorMessage ?? 'Unknown Error')),
            Status.success => ListView.separated(
                itemBuilder: (context, index) {
                  return ItemWidget(
                    data: state.data![index],
                    lang: state.lang ?? 'uz',
                    onTap: () {
                      _calculateBottomSheet(context, state.data![index]);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16, left: 80),
                        child: Divider(color: Colors.grey.withAlpha(60)),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                },
                itemCount: state.data?.length ?? 0),
          },
        );
      },
    );
  }

  void _openDialog(BuildContext context, String lang) {
    BottomPicker.date(
      pickerTitle: Text(
        lang == 'uz'
            ? 'Sanani tanlang'
            : lang == 'ru'
                ? 'Выберите дату'
                : 'Choose the date',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.fontTernary,
        ),
      ),
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: DateTime.now(),
      maxDateTime: DateTime.now(),
      minDateTime: DateTime(2010),
      pickerTextStyle: TextStyle(
        color: AppColors.fontTernary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      onChange: (index) {
      },
      buttonSingleColor: Colors.transparent,
      buttonContent: Text(
        lang == 'uz'
            ? 'Tanlash'
            : lang == 'ru'
                ? 'Готово'
                : 'Choose',
      ),
      onSubmit: (index) {
        context.read<MainBloc>().add(SearchByDateEvent(index.toString().split(' ')[0]));
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }

  Future<void> _langBottomSheet(BuildContext context, String lang, Function onTap) {
    return showModalBottomSheet(
        barrierColor: Colors.black.withValues(alpha: 0.5),
        isDismissible: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    indent: 120,
                    endIndent: 120,
                    color: Colors.grey,
                    thickness: 4,
                  ),
                ),
                ItemLanguage(
                    isSelected: lang == 'ru',
                    text: 'Русский',
                    onTap: () {
                      Navigator.pop(context);
                      onTap('ru');
                    }),
                ItemLanguage(
                    isSelected: lang == 'uz',
                    text: "O'zbek",
                    onTap: () {
                      Navigator.pop(context);
                      onTap('uz');
                    }),
                ItemLanguage(
                    isSelected: lang == 'en',
                    text: 'English',
                    onTap: () {
                      Navigator.pop(context);
                      onTap('en');
                    }),
                SizedBox(height: 16)
              ],
            ));
  }

  Future<void> _calculateBottomSheet(BuildContext context, CurrencyResponse data) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        backgroundColor: Colors.white,
        builder: (context) => BlocProvider(
              create: (context) => CalculateBloc()..add(SelectedDataEvent(data)),
              child: CalculateScreen(),
            ));
  }
}