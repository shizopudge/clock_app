import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../core/enums.dart';
import '../../theme/fonts.dart';

class FilterPopup extends StatelessWidget {
  const FilterPopup({super.key});

  static void _onFilterTap(BuildContext context, FilterType filter) {
    context.read<AlarmViewCubit>().clearAlarms();
    context.read<AlarmViewCubit>().setFilterType(filter);
  }

  @override
  Widget build(BuildContext context) {
    final FilterType filter = context.watch<AlarmViewCubit>().state.filter;
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      padding: const EdgeInsets.all(0),
      elevation: 4,
      icon:
          filter == FilterType.onlyEnabled || filter == FilterType.onlyDisabled
              ? Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const Icon(
                      Icons.filter_alt_rounded,
                      size: 32,
                    ),
                    Text(
                      'ON',
                      style: AppFonts.labelStyle
                          .copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : const Icon(
                  Icons.filter_alt_rounded,
                  size: 32,
                ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => _onFilterTap(context, FilterType.none),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filter == FilterType.none)
                const Icon(
                  Icons.filter_alt_off_rounded,
                )
              else
                const Icon(
                  Icons.filter_alt_off_rounded,
                  color: Colors.white,
                ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'No filter',
                style: AppFonts.labelStyle,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => _onFilterTap(context, FilterType.onlyEnabled),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filter == FilterType.onlyEnabled)
                const Icon(
                  Icons.alarm_on_rounded,
                )
              else
                const Icon(
                  Icons.alarm_on_rounded,
                  color: Colors.white,
                ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'Enabled',
                style: AppFonts.labelStyle,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => _onFilterTap(context, FilterType.onlyDisabled),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filter == FilterType.onlyDisabled)
                const Icon(
                  Icons.alarm_off_rounded,
                )
              else
                const Icon(
                  Icons.alarm_off_rounded,
                  color: Colors.white,
                ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'Disabled',
                style: AppFonts.labelStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
