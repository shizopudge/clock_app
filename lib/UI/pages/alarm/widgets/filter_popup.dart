import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../../theme/fonts.dart';
import '../../../../theme/pallete.dart';

class FilterPopup extends StatelessWidget {
  const FilterPopup({super.key});

  static void _onFilterTap(BuildContext context, FilterType filter) =>
      context.read<AlarmViewCubit>().setFilterType(filter);

  @override
  Widget build(BuildContext context) {
    final FilterType filter = context.watch<AlarmViewCubit>().state.filter;
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      icon: const Icon(
        Icons.filter_alt_rounded,
      ),
      //? icon: filter == FilterType.onlyLaunched
      //     ? Icon(
      //         Icons.alarm_on_rounded,
      //         color: Pallete.blueColor,
      //       )
      //     : filter == FilterType.onlyOffed
      //         ? Icon(
      //             Icons.alarm_off_rounded,
      //             color: Pallete.blueColor,
      //           )
      //         : const Icon(
      //             Icons.filter_alt_off_rounded,
      //           ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => _onFilterTap(context, FilterType.none),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filter == FilterType.none)
                Icon(
                  Icons.filter_alt_off_rounded,
                  color: Pallete.blueColor,
                )
              else
                const Icon(
                  Icons.filter_alt_off_rounded,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => _onFilterTap(context, FilterType.onlyLaunched),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filter == FilterType.onlyLaunched)
                Icon(
                  Icons.alarm_on_rounded,
                  color: Pallete.blueColor,
                )
              else
                const Icon(
                  Icons.alarm_on_rounded,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => _onFilterTap(context, FilterType.onlyOffed),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filter == FilterType.onlyOffed)
                Icon(
                  Icons.alarm_off_rounded,
                  color: Pallete.blueColor,
                )
              else
                const Icon(
                  Icons.alarm_off_rounded,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
