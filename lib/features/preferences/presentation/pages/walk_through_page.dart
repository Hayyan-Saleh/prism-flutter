import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/app_text_button.dart';
import 'package:prism/features/preferences/domain/entities/preferences_entity.dart';
import 'package:prism/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';
import 'package:prism/features/preferences/presentation/widgets/walk_through_widget.dart';
import 'package:prism/features/preferences/domain/entities/preferences_enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalkThroughPage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;
  const WalkThroughPage({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  State<WalkThroughPage> createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  Locales _locale = Locales.en;
  Themes _theme = Themes.light;
  int _currentPage = 0;
  double height = 1000;
  final PageController _pageController = PageController();

  _moveNext() {
    _pageController.animateToPage(
      ++_currentPage,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  _moveBack() {
    _pageController.animateToPage(
      --_currentPage,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = getHeight(context);
    return BlocListener<PreferencesBloc, PreferencesState>(
      listener: (context, state) {
        if (state is DoneStorePreferencesState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.authMiddlePoint,
            (_) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: _buildBodyElements(),
      ),
    );
  }

  Widget _buildBodyElements() {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          SizedBox(
            height: 0.6 * height,
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              children: [
                _buildContent1(),
                _buildContent2(),
                _buildContent3(),
                _buildContent4(),
                _buildContent5(),
              ],
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildContent1() {
    return WalkThroughWidget(
      imagePath: Assets.walkThrough1,
      title: AppLocalizations.of(context)!.welcomeToPrism,
      customWidget: AppTextButton(
        onPressed: () {
          _locale = Locales.ar;
          widget.onLocaleChanged(const Locale('ar'));
          _moveNext();
        },
        text: AppLocalizations.of(context)!.iPreferToUseArabic,
      ),
    );
  }

  Widget _buildContent2() {
    return WalkThroughWidget(
      imagePath: Assets.walkThrough2,
      title: AppLocalizations.of(context)!.letsCreatePosts,
    );
  }

  Widget _buildContent3() {
    return WalkThroughWidget(
      imagePath: Assets.walkThrough3,
      title: AppLocalizations.of(context)!.joinGroups,
    );
  }

  Widget _buildContent4() {
    return WalkThroughWidget(
      imagePath: Assets.walkThrough4,
      title: AppLocalizations.of(context)!.linkWithOthers,
    );
  }

  Widget _buildContent5() {
    return WalkThroughWidget(
      title: AppLocalizations.of(context)!.letsStart,
      customWidget: Column(
        children: [
          SizedBox(height: 0.1 * height),
          AppButton(
            bgColor: Theme.of(context).colorScheme.onPrimary,
            fgColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              BlocProvider.of<PreferencesBloc>(context).add(
                StorePreferencesEvent(
                  preferences: PreferencesEntity(
                    appTheme: _theme,
                    appLocal: _locale,
                  ),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.continueToApp,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 0.02 * height),
          AppTextButton(
            text: AppLocalizations.of(context)!.continueWithDarkTheme,
            onPressed: () {
              _theme = Themes.dark;
              widget.onThemeChanged(ThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentPage == 0
              ? SizedBox()
              : AppButton(
                bgColor: Colors.transparent,
                fgColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: _moveBack,
                child: Text(
                  "< ${AppLocalizations.of(context)!.back}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
          _currentPage == 4
              ? SizedBox()
              : AppButton(
                bgColor: Colors.transparent,
                fgColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: _moveNext,
                child: Text(
                  "${AppLocalizations.of(context)!.next} >",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
        ],
      ),
    );
  }
}
