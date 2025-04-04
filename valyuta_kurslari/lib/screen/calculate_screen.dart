import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valyuta_kurslari/util/extensions.dart';

import '../bloc/calculate/calculate_bloc.dart';
import '../data/data/currency_data.dart';
import '../design/colors.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> with SingleTickerProviderStateMixin{
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // 0.5 sekundlik animatsiya
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _rotateIcon() {
    _animationController.forward(from: 0); // Har safar qaytadan boshlash
    context.read<CalculateBloc>().add(SwipeConvertEvent()); // Bloc event yuborish
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: BlocConsumer<CalculateBloc, CalculateState>(
        listener: (context, state) {
          if (state.inputSum != null && state.inputSum!.isNotEmpty) _controller.text = state.inputSum!;
        },
        builder: (context, state) {
          final checkFlag = state.selectedData?.ccy == 'EUR'
              ? 'https://uxwing.com/wp-content/themes/uxwing/download/flags-landmarks/europe-flag-icon.png'
              : state.selectedData?.ccy;
          final flag = currencyToCountry['$checkFlag']?.toLowerCase();
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    "1 ${state.selectedData?.ccy} = ${state.selectedData?.rate?.formatToMoney()} UZS",
                    style: TextStyle(color: AppColors.fontTernary, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close)),
                ]),
                SizedBox(height: 12),
                Text(
                  state.lang == 'uz'
                      ? 'Qiymati'
                      : state.lang == 'ru'
                      ? 'Номинал'
                      : 'Quantity',
                  style: TextStyle(color: AppColors.fontPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Image.network(
                      width: 48,
                      height: 48,
                      state.isReversed ?? false
                          ? "https://flagpedia.net/data/flags/h80/uz.png"
                          : "https://flagpedia.net/data/flags/h80/$flag.png",
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return SizedBox(width: 48, height: 48, child: Icon(Icons.currency_exchange));
                      },
                    ),
                    SizedBox(width: 24),
                    Text(
                      state.isReversed ?? false ? "UZS" : state.selectedData?.ccy ?? "",
                      style:
                          TextStyle(color: AppColors.fontPrimary, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: '0',
                              counterText: "",
                              fillColor: Colors.grey.withAlpha(70),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none)),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: AppColors.fontPrimary, fontWeight: FontWeight.w600),
                          showCursor: false,
                          maxLines: 1,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.isNotEmpty && value.startsWith('0')) {
                              _controller.text = '';
                              _controller.selection =
                                  TextSelection.collapsed(offset: 0); // Kursorni boshiga qo'yadi
                              return;
                            }

                            // Agar kiritilgan qiymat 0 bilan boshlangan bo'lsa
                            context.read<CalculateBloc>().add(InputSumEvent(value));
                          },
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * pi,
                          child: child,
                        );
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.fontTernary),
                        child: IconButton(
                            icon: Icon(Icons.swap_horiz, color: Colors.white), onPressed: _rotateIcon),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  state.lang == 'uz'
                      ? 'Konvertatsiya qilingan qiymati'
                      : state.lang == 'ru'
                      ? 'Конвертируемая номинал'
                      : 'Convertible face value',
                  style: TextStyle(color: AppColors.fontSecondary, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Image.network(
                      width: 48,
                      height: 48,
                      state.isReversed ?? false
                          ? "https://flagpedia.net/data/flags/h80/$flag.png"
                          : "https://flagpedia.net/data/flags/h80/uz.png",
                      errorBuilder: (BuildContext context, Object exeption, StackTrace? stackTrace) {
                        return const SizedBox(
                            width: 48, height: 48, child: Icon(Icons.currency_exchange_outlined));
                      },
                    ),
                    SizedBox(width: 24),
                    Text(
                      state.isReversed ?? false ? state.selectedData?.ccy ?? "" : "UZS",
                      style:
                          TextStyle(color: AppColors.fontPrimary, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    SizedBox(width: 32),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.grey.withAlpha(70),
                        ),
                        child: Text(
                          state.convertedSum?.formatToMoney() ?? "0",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: AppColors.fontSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
