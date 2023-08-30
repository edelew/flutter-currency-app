import 'package:currency_app/app/route/app_router.dart';
import 'package:currency_app/core/utils/colors.dart';
import 'package:currency_app/core/utils/constants.dart';
import 'package:currency_app/presentation/bloc/base_currency_bloc/base_currency_bloc.dart';
import 'package:currency_app/presentation/bloc/currency_bloc/currency_bloc.dart';
import 'package:currency_app/presentation/bloc/currency_info_bloc/currency_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CurrencySliverAppBar extends StatefulWidget {
  const CurrencySliverAppBar({
    required this.expandedHeight,
    super.key,
  });

  final double? expandedHeight;

  @override
  State<CurrencySliverAppBar> createState() => _CurrencySliverAppBarState();
}

class _CurrencySliverAppBarState extends State<CurrencySliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: widget.expandedHeight,
      backgroundColor: AppColors.white,
      floating: true,
      forceElevated: true,
      elevation: 20.h,
      shadowColor: AppColors.shadowGrey,
      flexibleSpace: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.mainPaddingWidth,
        ),
        child: const Center(
          child: _BaseCurrencyWidget(),
        ),
      ),
    );
  }
}

class _BaseCurrencyWidget extends StatelessWidget {
  const _BaseCurrencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        return BlocBuilder<CurrencyInfoBloc, CurrencyInfoState>(
          builder: (context, state) {
            return BlocConsumer<BaseCurrencyBloc, BaseCurrencyState>(
              builder: (context, state) {
                print('BaseCurrencyWidget BUILD');
                final currentBase = state.base;

                return GestureDetector(
                  onTap: () {
                    context.goNamed(AppRouter.selectBaseCurrency,
                        extra: currentBase);
                    BlocProvider.of<CurrencyInfoBloc>(context)
                        .add(const GetCurrenciesInfoEvent());
                  },
                  child: Row(
                    children: [
                      Text(
                        currentBase,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 36.r,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.goNamed(AppRouter.login);
                            },
                            child: const Text('Log in'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              listener: (context, state) {
                print('BaseCurrencyBlocListener HERE WE ARE)))');
                BlocProvider.of<CurrencyBloc>(context)
                    .add(GetAllCurrencyEvent(state.base));
              },
            );
          },
        );
      },
    );
  }
}
