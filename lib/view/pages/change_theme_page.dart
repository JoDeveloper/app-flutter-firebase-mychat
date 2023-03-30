import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_util.dart';
import '../../viewmodel/theme_view_model.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';

class ChangeThemePage extends StatelessWidget {
  ChangeThemePage({super.key});

  final _themeViewModel = Get.find<ThemeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Theme Mode",
        ),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          child: Text(
            "Please choose theme mode",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _themeViewModel.setDarkMode(false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppThemes.lightTheme.scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.shadowColor.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 20,
                          ),
                          ThemeModeItem(title: "ABC"),
                          ThemeModeItem(title: "ABC"),
                        ],
                      ),
                    ),
                    Radio(
                      activeColor: AppColor.primary,
                      value: false,
                      groupValue: _themeViewModel.isDarkMode,
                      onChanged: (value) {
                        AppUtil.debugPrint(value);
                        _themeViewModel.setDarkMode(false);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Light mode",
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _themeViewModel.setDarkMode(true);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppThemes.darkTheme.scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 20,
                          ),
                          ThemeModeItem(title: "ABC", mode: ThemeMode.dark),
                          ThemeModeItem(title: "ABC", mode: ThemeMode.dark),
                        ],
                      ),
                    ),
                    Radio(
                      activeColor: AppColor.primary,
                      value: true,
                      groupValue: _themeViewModel.isDarkMode,
                      onChanged: (value) {
                        AppUtil.debugPrint(value);
                        _themeViewModel.setDarkMode(true);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Dark mode",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Default system",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Obx(
                () => Switch(
                  value: _themeViewModel.isDarkModeDefaultSystem,
                  activeColor: AppColor.primary,
                  onChanged: (isDefault) {
                    AppUtil.debugPrint("isDefault $isDefault");
                    _themeViewModel.setDarkModeDefaultSystem(isDefault);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ThemeModeItem extends StatelessWidget {
  final Color serviceColor;
  final ThemeMode mode;
  final String title;
  const ThemeModeItem(
      {super.key,
      required this.title,
      this.serviceColor = AppColor.primary,
      this.mode = ThemeMode.light});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4, left: 3, right: 3),
      height: 40,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: mode == ThemeMode.dark
            ? AppThemes.darkTheme.cardColor
            : AppThemes.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(.1),
            spreadRadius: .5,
            blurRadius: .5,
            offset: const Offset(0, .5),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 6,
          color: mode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
