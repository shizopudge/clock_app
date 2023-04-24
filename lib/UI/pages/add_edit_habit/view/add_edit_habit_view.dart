import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../bloc/add_edit_habit/add_edit_habit_cubit.dart';
import '../../../../core/utils.dart';
import '../../../../storage/database.dart';
import '../../../../theme/pallete.dart';
import '../../../../theme/theme.dart';
import '../../../common/add_edit_settings.dart';
import '../controller/add_edit_habit_controller.dart';
import '../widgets/interval_picker.dart';

class AddEditHabitView extends StatefulWidget {
  final bool isAddHabit;
  final AddEditHabitController _addEditHabitController;
  const AddEditHabitView({
    super.key,
    required this.isAddHabit,
    required AddEditHabitController addEditHabitController,
  }) : _addEditHabitController = addEditHabitController;

  @override
  State<AddEditHabitView> createState() => _AddEditHabitViewState();
}

class _AddEditHabitViewState extends State<AddEditHabitView> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init(context, isAddHabit: widget.isAddHabit);
  }

  void init(
    BuildContext context, {
    required bool isAddHabit,
  }) {
    if (isAddHabit) {
      widget._addEditHabitController.reset(context);
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
    } else {
      _nameController = TextEditingController(
          text: context.read<AddEditHabitCubit>().state.name);
      _descriptionController = TextEditingController(
          text: context.read<AddEditHabitCubit>().state.description ?? '');
      final int currentInterval =
          context.read<AddEditHabitCubit>().state.interval;
      for (int i = 0; i < AppUtils.intervals.length; i++) {
        if (currentInterval == AppUtils.intervals[i].keys.first) {
          context.read<IntervalPickerCubit>().setItemIndex(i);
        }
      }
      final int currentItemIndex = context.read<IntervalPickerCubit>().state;
      Future.delayed(
          const Duration(milliseconds: 150),
          () => _scrollController.animateTo(
                (150 * currentItemIndex).toDouble(),
                duration: const Duration(milliseconds: 750),
                curve: Curves.linear,
              ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddEditHabitState addEditHabitState =
        context.watch<AddEditHabitCubit>().state;
    final String theme = Hive.box(DatabaseHelper.settingsBox)
        .get('theme', defaultValue: AppTheme.defaultTheme);
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: theme == AppTheme.darkThemeName
              ? PalleteDark.backgroundColor
              : null,
          gradient: theme == AppTheme.lightThemeName
              ? PalleteLight.backgroundGradient
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isKeyboardVisible)
              IntervalPicker(
                controller: _scrollController,
                intervals: AppUtils.intervals,
              ),
            AddEditSettings(
              nameController: _nameController,
              descriptionController: _descriptionController,
              onSave: () => addEditHabitState.name.isNotEmpty
                  ? widget._addEditHabitController.onSave(
                      context,
                      id: addEditHabitState.id,
                      isAddHabit: widget.isAddHabit,
                      name: addEditHabitState.name,
                      description: addEditHabitState.description,
                      interval: addEditHabitState.interval,
                    )
                  : AppUtils.showSnackBar(context, 'Enter habit name'),
              nameHintText: 'Habit name',
              isAlarm: false,
            ),
          ],
        ),
      ),
    );
  }
}
