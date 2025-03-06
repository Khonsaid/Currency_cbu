import 'package:flutter/material.dart';
import 'package:valyuta_kurslari/data/source/remote/response/currency_response.dart';
import 'package:valyuta_kurslari/design/colors.dart';
import 'package:valyuta_kurslari/util/extensions.dart';

import '../data/data/currency_data.dart';

class ItemWidget extends StatelessWidget {
  final CurrencyResponse data;
  final String lang;
  final VoidCallback onTap;

  const ItemWidget({required this.data, required this.onTap, super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    final flag = currencyToCountry['${data.ccy}']?.toLowerCase();
    final ccyNmUZ = lang == 'uz'
        ? data.ccyNmUZ
        : lang == 'ru'
            ? data.ccyNmRU
            : data.ccyNmEN;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Image.network(
                  width: 48,
                  height: 48,
                  data.ccy == 'EUR'
                      ? 'https://uxwing.com/wp-content/themes/uxwing/download/flags-landmarks/europe-flag-icon.png'
                      : "https://flagpedia.net/data/flags/h80/$flag.png",
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return SizedBox(width: 48, height: 48, child: const Icon(Icons.currency_exchange));
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        data.ccy ?? "",
                        style: TextStyle(
                            color: AppColors.fontPrimary, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        "${data.rate?.formatToMoney(currency: ' UZS')}",
                        style: TextStyle(
                            color: AppColors.fontPrimary, fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        ccyNmUZ ?? "",
                        style: TextStyle(
                            color: AppColors.fontSecondary, fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        "${(!data.diff!.startsWith('-') && data.diff != '0') ? '+' : ''}${data.diff}%",
                        style: TextStyle(
                            color: AppColors.fontSecondary, fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        data.diff?.startsWith('-') ?? false
                            ? Icons.trending_down_outlined
                            : data.diff! == '0'
                                ? Icons.remove
                                : Icons.trending_up_outlined,
                        color: data.diff?.startsWith('-') ?? false
                            ? Colors.red
                            : data.diff! == '0'
                                ? AppColors.fontPrimary
                                : Colors.green,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
