import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:slide_action/slide_action.dart';

import '../../../../core/utils.dart';
import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';
import '../../../../theme/pallete.dart';
import '../../../../theme/theme.dart';
import '../controller/alarm_page_controller.dart';

class AlarmPageViewCubit extends Cubit<double> {
  AlarmPageViewCubit() : super(1.0);

  void setOpacity(double opacity) => emit(opacity);
}

class AlarmPageView extends StatefulWidget {
  final AlarmPageController _alarmPageController;
  const AlarmPageView(
      {super.key, required AlarmPageController alarmPageController})
      : _alarmPageController = alarmPageController;

  @override
  State<AlarmPageView> createState() => _AlarmPageViewState();
}

class _AlarmPageViewState extends State<AlarmPageView> {
  late final AudioPlayer _player;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _player = AudioPlayer()
      ..setAsset('assets/audio/alarm.mp3')
      ..setLoopMode(LoopMode.one)
      ..play();
    _timer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      final double opacity = context.read<AlarmPageViewCubit>().state;
      if (opacity == 0.1) {
        context.read<AlarmPageViewCubit>().setOpacity(1.0);
      } else {
        context.read<AlarmPageViewCubit>().setOpacity(0.1);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String theme = Hive.box(DatabaseHelper.settingsBox)
        .get('theme', defaultValue: AppTheme.defaultTheme);
    final double opacity = context.watch<AlarmPageViewCubit>().state;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme == AppTheme.darkThemeName
              ? PalleteDark.backgroundColor
              : null,
          gradient: theme == AppTheme.lightThemeName
              ? PalleteLight.backgroundGradient
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 750),
                child: Text(
                  AppUtils.getFormatDateTimeNow(),
                  style: AppFonts.timeStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 100,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SlideAction(
                stretchThumb: true,
                trackHeight: 90,
                trackBuilder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Switch off',
                        style: AppFonts.titleStyle.copyWith(
                          color: Pallete.actionColor,
                        ),
                      ),
                    ),
                  );
                },
                thumbBuilder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: widget._alarmPageController.lerpColorList([
                        Colors.red,
                        Pallete.actionColor,
                      ], state.thumbFractionalPosition),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.power_settings_new_rounded,
                      color: Colors.white,
                    ),
                  );
                },
                action: () async => widget._alarmPageController
                    .action(context, _player, _timer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
