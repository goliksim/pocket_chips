import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @tooltip_dealer.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get tooltip_dealer;

  /// No description provided for @tooltip_increase_level.
  ///
  /// In en, this message translates to:
  /// **'Next progression level'**
  String get tooltip_increase_level;

  /// No description provided for @tooltip_theme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get tooltip_theme;

  /// No description provided for @tooltip_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get tooltip_edit;

  /// No description provided for @tooltip_stor.
  ///
  /// In en, this message translates to:
  /// **'Saved players'**
  String get tooltip_stor;

  /// No description provided for @tooltip_rot.
  ///
  /// In en, this message translates to:
  /// **'Rotate players'**
  String get tooltip_rot;

  /// No description provided for @tooltip_add_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get tooltip_add_new;

  /// No description provided for @tooltip_add_stor.
  ///
  /// In en, this message translates to:
  /// **'From List'**
  String get tooltip_add_stor;

  /// No description provided for @tooltip_add_main.
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get tooltip_add_main;

  /// No description provided for @tooltip_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo action'**
  String get tooltip_undo;

  /// No description provided for @conf_canc.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get conf_canc;

  /// No description provided for @conf_new_tittle.
  ///
  /// In en, this message translates to:
  /// **'New Game Confirmation'**
  String get conf_new_tittle;

  /// No description provided for @conf_new_text1.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to start a new game?'**
  String get conf_new_text1;

  /// No description provided for @conf_new_text2.
  ///
  /// In en, this message translates to:
  /// **'Your last lobby will be deleted!'**
  String get conf_new_text2;

  /// No description provided for @conf_new_butt.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get conf_new_butt;

  /// No description provided for @conf_del_tittle.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get conf_del_tittle;

  /// No description provided for @conf_del_text.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this player?'**
  String get conf_del_text;

  /// No description provided for @conf_del_butt.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get conf_del_butt;

  /// No description provided for @conf_rest_tittle.
  ///
  /// In en, this message translates to:
  /// **'Restore Confirmation'**
  String get conf_rest_tittle;

  /// No description provided for @conf_rest_text.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore the game?'**
  String get conf_rest_text;

  /// No description provided for @conf_rest_butt.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get conf_rest_butt;

  /// No description provided for @home_new.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get home_new;

  /// No description provided for @home_cont.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get home_cont;

  /// No description provided for @home_abo.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get home_abo;

  /// No description provided for @home_sup.
  ///
  /// In en, this message translates to:
  /// **'Support me'**
  String get home_sup;

  /// No description provided for @home_win_check.
  ///
  /// In en, this message translates to:
  /// **'Solver'**
  String get home_win_check;

  /// No description provided for @support_tittle.
  ///
  /// In en, this message translates to:
  /// **'You can support me by:'**
  String get support_tittle;

  /// No description provided for @support_tittle_triggered.
  ///
  /// In en, this message translates to:
  /// **'Enjoying the app? Support me!'**
  String get support_tittle_triggered;

  /// No description provided for @support_methods_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Failed to load support methods. Check your internet connection'**
  String get support_methods_unavailable;

  /// No description provided for @support_methods_unavailable_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get support_methods_unavailable_retry;

  /// No description provided for @support_video.
  ///
  /// In en, this message translates to:
  /// **'Video ads'**
  String get support_video;

  /// No description provided for @support_modest.
  ///
  /// In en, this message translates to:
  /// **'Modest donation'**
  String get support_modest;

  /// No description provided for @support_nice.
  ///
  /// In en, this message translates to:
  /// **'Nice donation'**
  String get support_nice;

  /// No description provided for @support_huge.
  ///
  /// In en, this message translates to:
  /// **'Huge donation'**
  String get support_huge;

  /// No description provided for @support_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get support_close;

  /// No description provided for @support_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get support_free;

  /// No description provided for @about_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get about_skip;

  /// No description provided for @about_end.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get about_end;

  /// No description provided for @about_welc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get about_welc;

  /// No description provided for @about_welc_1.
  ///
  /// In en, this message translates to:
  /// **'This application is designed to replace the material chips.'**
  String get about_welc_1;

  /// No description provided for @about_welc_2.
  ///
  /// In en, this message translates to:
  /// **'All you need to play: cards and phone!'**
  String get about_welc_2;

  /// No description provided for @about_welc_3.
  ///
  /// In en, this message translates to:
  /// **'The app:'**
  String get about_welc_3;

  /// No description provided for @about_welc_4.
  ///
  /// In en, this message translates to:
  /// **'stores players\' chips'**
  String get about_welc_4;

  /// No description provided for @about_welc_5.
  ///
  /// In en, this message translates to:
  /// **'allows you to place bets'**
  String get about_welc_5;

  /// No description provided for @about_welc_6.
  ///
  /// In en, this message translates to:
  /// **'divide the final pot between players'**
  String get about_welc_6;

  /// No description provided for @about_welc_7.
  ///
  /// In en, this message translates to:
  /// **'This application based on the rules of unlimited Texas Hold\'em.'**
  String get about_welc_7;

  /// No description provided for @about_hom_1.
  ///
  /// In en, this message translates to:
  /// **'Home screen'**
  String get about_hom_1;

  /// No description provided for @about_hom_2.
  ///
  /// In en, this message translates to:
  /// **'[PRO-feature] On the home screen you can choose a light or dark interface theme'**
  String get about_hom_2;

  /// No description provided for @about_hom_3.
  ///
  /// In en, this message translates to:
  /// **'[PRO-feature] In PRO version the app stores information about your last game. You can exit at any time, everything will be saved.'**
  String get about_hom_3;

  /// No description provided for @about_hom_4.
  ///
  /// In en, this message translates to:
  /// **'The NEW GAME button deletes all information about the last game!'**
  String get about_hom_4;

  /// No description provided for @about_plme_1.
  ///
  /// In en, this message translates to:
  /// **'Player Menu'**
  String get about_plme_1;

  /// No description provided for @about_plme_2.
  ///
  /// In en, this message translates to:
  /// **'The INITIAL STACK button lets you change the initial stack for all players.'**
  String get about_plme_2;

  /// No description provided for @about_plme_3.
  ///
  /// In en, this message translates to:
  /// **'Swipe the player left to remove it.'**
  String get about_plme_3;

  /// No description provided for @about_plme_4.
  ///
  /// In en, this message translates to:
  /// **'[PRO-feature] Swipe the player right to add players to the storage.'**
  String get about_plme_4;

  /// No description provided for @about_plme_5.
  ///
  /// In en, this message translates to:
  /// **'They will be stored there forever.'**
  String get about_plme_5;

  /// No description provided for @about_plme_6.
  ///
  /// In en, this message translates to:
  /// **'Edit player\'s info by tapping it.'**
  String get about_plme_6;

  /// No description provided for @about_plme_7.
  ///
  /// In en, this message translates to:
  /// **'Reorder players by drag-drop.'**
  String get about_plme_7;

  /// No description provided for @about_set_1.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get about_set_1;

  /// No description provided for @about_set_2.
  ///
  /// In en, this message translates to:
  /// **'In the settings tab, you can also configure the initial stack, as well as small blind.'**
  String get about_set_2;

  /// No description provided for @about_set_3.
  ///
  /// In en, this message translates to:
  /// **'Before the start of betting, you can make any changes:'**
  String get about_set_3;

  /// No description provided for @about_set_4.
  ///
  /// In en, this message translates to:
  /// **'add, remove players'**
  String get about_set_4;

  /// No description provided for @about_set_5.
  ///
  /// In en, this message translates to:
  /// **'change player stacks'**
  String get about_set_5;

  /// No description provided for @about_set_6.
  ///
  /// In en, this message translates to:
  /// **'you can change the dealer, etc'**
  String get about_set_6;

  /// No description provided for @about_set_8.
  ///
  /// In en, this message translates to:
  /// **'change the initial smallblind'**
  String get about_set_8;

  /// No description provided for @about_set_9.
  ///
  /// In en, this message translates to:
  /// **'change the description and player\'s avatar'**
  String get about_set_9;

  /// No description provided for @about_tab_1.
  ///
  /// In en, this message translates to:
  /// **'Game table'**
  String get about_tab_1;

  /// No description provided for @about_tab_2.
  ///
  /// In en, this message translates to:
  /// **'At the top of the screen you can change the player\'s position at the game table.'**
  String get about_tab_2;

  /// No description provided for @about_tab_3.
  ///
  /// In en, this message translates to:
  /// **'The amount of your bet or raise can be selected using the slider or by clicking on chips.'**
  String get about_tab_3;

  /// No description provided for @about_tab_4.
  ///
  /// In en, this message translates to:
  /// **'After showdown (end of betting) you need to choose a winner or winners.'**
  String get about_tab_4;

  /// No description provided for @about_tab_5.
  ///
  /// In en, this message translates to:
  /// **'If side pots were created in the game (someone went ALL-in), then first choose the winner of the main pot.'**
  String get about_tab_5;

  /// No description provided for @about_link_1.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get about_link_1;

  /// No description provided for @about_link_2.
  ///
  /// In en, this message translates to:
  /// **'Like my app? Rate it and leave a comment! Don\'t forget share with friends!'**
  String get about_link_2;

  /// No description provided for @about_link_3.
  ///
  /// In en, this message translates to:
  /// **'Rate app'**
  String get about_link_3;

  /// No description provided for @about_link_4.
  ///
  /// In en, this message translates to:
  /// **'You can also support me if you want. See the methods on the home screen.'**
  String get about_link_4;

  /// No description provided for @about_link_5.
  ///
  /// In en, this message translates to:
  /// **'Have a problem with app or want to ask questions? Send feedback and features request:'**
  String get about_link_5;

  /// No description provided for @about_link_6.
  ///
  /// In en, this message translates to:
  /// **'In attachments there is file with app\'s logs...'**
  String get about_link_6;

  /// No description provided for @about_link_7.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get about_link_7;

  /// No description provided for @playp_tittle.
  ///
  /// In en, this message translates to:
  /// **'Lobby Menu'**
  String get playp_tittle;

  /// No description provided for @playp_rest.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get playp_rest;

  /// No description provided for @playp_init.
  ///
  /// In en, this message translates to:
  /// **'Starting Stack:'**
  String get playp_init;

  /// No description provided for @playp_add.
  ///
  /// In en, this message translates to:
  /// **'Add New Player'**
  String get playp_add;

  /// No description provided for @playp_bank_title.
  ///
  /// In en, this message translates to:
  /// **'Enter new starting stacks:'**
  String get playp_bank_title;

  /// No description provided for @playp_sp_title1.
  ///
  /// In en, this message translates to:
  /// **'Saved Players'**
  String get playp_sp_title1;

  /// No description provided for @playp_sp_title2.
  ///
  /// In en, this message translates to:
  /// **'Players list is empty'**
  String get playp_sp_title2;

  /// No description provided for @playp_playr_diss1.
  ///
  /// In en, this message translates to:
  /// **'Add to lobby'**
  String get playp_playr_diss1;

  /// No description provided for @playp_playr_diss2.
  ///
  /// In en, this message translates to:
  /// **'Save Player'**
  String get playp_playr_diss2;

  /// No description provided for @playp_playr_diss3.
  ///
  /// In en, this message translates to:
  /// **'Unsave Player'**
  String get playp_playr_diss3;

  /// No description provided for @playp_playr_diss4.
  ///
  /// In en, this message translates to:
  /// **'Delete Player'**
  String get playp_playr_diss4;

  /// No description provided for @playp_edit_title1.
  ///
  /// In en, this message translates to:
  /// **'New player'**
  String get playp_edit_title1;

  /// No description provided for @playp_edit_title2.
  ///
  /// In en, this message translates to:
  /// **'Player menu'**
  String get playp_edit_title2;

  /// No description provided for @playp_edit_win1.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get playp_edit_win1;

  /// No description provided for @playp_edit_win2.
  ///
  /// In en, this message translates to:
  /// **'Starting stack'**
  String get playp_edit_win2;

  /// No description provided for @playp_edit_win3.
  ///
  /// In en, this message translates to:
  /// **'Make a dealer'**
  String get playp_edit_win3;

  /// No description provided for @playp_bank_conf.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get playp_bank_conf;

  /// No description provided for @playp_edit_conf.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get playp_edit_conf;

  /// No description provided for @playp_edit_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get playp_edit_add;

  /// No description provided for @playp_start.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get playp_start;

  /// No description provided for @playp_set.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get playp_set;

  /// No description provided for @sett_title.
  ///
  /// In en, this message translates to:
  /// **'Game Settings'**
  String get sett_title;

  /// No description provided for @sett_win1.
  ///
  /// In en, this message translates to:
  /// **'Update stacks'**
  String get sett_win1;

  /// No description provided for @sett_custom_bets.
  ///
  /// In en, this message translates to:
  /// **'Allow custom bets/raises'**
  String get sett_custom_bets;

  /// No description provided for @sett_conf.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get sett_conf;

  /// No description provided for @game_welc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to New Game!'**
  String get game_welc;

  /// No description provided for @game_turn.
  ///
  /// In en, this message translates to:
  /// **'Turn'**
  String get game_turn;

  /// No description provided for @game_shdw.
  ///
  /// In en, this message translates to:
  /// **'Showdown'**
  String get game_shdw;

  /// No description provided for @game_break.
  ///
  /// In en, this message translates to:
  /// **'Breaktime'**
  String get game_break;

  /// No description provided for @game_pflop.
  ///
  /// In en, this message translates to:
  /// **'Pre-Flop'**
  String get game_pflop;

  /// No description provided for @game_flop.
  ///
  /// In en, this message translates to:
  /// **'Flop'**
  String get game_flop;

  /// No description provided for @game_river.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get game_river;

  /// No description provided for @game_fold.
  ///
  /// In en, this message translates to:
  /// **'Fold'**
  String get game_fold;

  /// No description provided for @game_check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get game_check;

  /// No description provided for @game_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get game_call;

  /// No description provided for @game_all.
  ///
  /// In en, this message translates to:
  /// **'All in'**
  String get game_all;

  /// No description provided for @game_bet.
  ///
  /// In en, this message translates to:
  /// **'Bet'**
  String get game_bet;

  /// No description provided for @game_bet_to.
  ///
  /// In en, this message translates to:
  /// **'Bet to'**
  String get game_bet_to;

  /// No description provided for @game_raise.
  ///
  /// In en, this message translates to:
  /// **'Raise'**
  String get game_raise;

  /// No description provided for @game_raise_to.
  ///
  /// In en, this message translates to:
  /// **'Raise to'**
  String get game_raise_to;

  /// No description provided for @game_raise_canc.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get game_raise_canc;

  /// No description provided for @game_win1.
  ///
  /// In en, this message translates to:
  /// **'winner'**
  String get game_win1;

  /// No description provided for @game_win2.
  ///
  /// In en, this message translates to:
  /// **'is winner!'**
  String get game_win2;

  /// No description provided for @game_win3.
  ///
  /// In en, this message translates to:
  /// **'Select the winners'**
  String get game_win3;

  /// No description provided for @game_win_conf.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get game_win_conf;

  /// No description provided for @game_win4.
  ///
  /// In en, this message translates to:
  /// **'Select side-pot winner'**
  String get game_win4;

  /// No description provided for @game_progression_setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get game_progression_setup;

  /// No description provided for @game_start.
  ///
  /// In en, this message translates to:
  /// **'Start Betting'**
  String get game_start;

  /// No description provided for @toast_thanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get toast_thanks;

  /// No description provided for @toast_moreplay.
  ///
  /// In en, this message translates to:
  /// **'You need more active players to play'**
  String get toast_moreplay;

  /// No description provided for @toast_winn.
  ///
  /// In en, this message translates to:
  /// **'Сhoose one or more winners'**
  String get toast_winn;

  /// No description provided for @toast_saved.
  ///
  /// In en, this message translates to:
  /// **'saved!'**
  String get toast_saved;

  /// No description provided for @toast_maxpl.
  ///
  /// In en, this message translates to:
  /// **'Max players count'**
  String get toast_maxpl;

  /// No description provided for @toast_alred.
  ///
  /// In en, this message translates to:
  /// **'already in lobby!'**
  String get toast_alred;

  /// No description provided for @toast_alred2.
  ///
  /// In en, this message translates to:
  /// **'Player with same name already exist'**
  String get toast_alred2;

  /// No description provided for @toast_moreplay2.
  ///
  /// In en, this message translates to:
  /// **'You cant play without players'**
  String get toast_moreplay2;

  /// No description provided for @toast_bank3.
  ///
  /// In en, this message translates to:
  /// **'The stack cannot be zero'**
  String get toast_bank3;

  /// No description provided for @toast_bank_warning.
  ///
  /// In en, this message translates to:
  /// **'Attention! Starting stack is lower than the required forced bets'**
  String get toast_bank_warning;

  /// No description provided for @toast_custom_bet_warning.
  ///
  /// In en, this message translates to:
  /// **'This bet is possible, but it violates the min raise rules'**
  String get toast_custom_bet_warning;

  /// No description provided for @toast_ante_zero.
  ///
  /// In en, this message translates to:
  /// **'Ante cannot be zero'**
  String get toast_ante_zero;

  /// No description provided for @toast_levels_zero.
  ///
  /// In en, this message translates to:
  /// **'Levels count cannot be zero'**
  String get toast_levels_zero;

  /// No description provided for @toast_cannot_be_zero.
  ///
  /// In en, this message translates to:
  /// **'Value cannot be zero'**
  String get toast_cannot_be_zero;

  /// No description provided for @toast_exceeds_maximum.
  ///
  /// In en, this message translates to:
  /// **'Value exceeds maximum allowed'**
  String get toast_exceeds_maximum;

  /// No description provided for @sett_ante_type.
  ///
  /// In en, this message translates to:
  /// **'Ante Type'**
  String get sett_ante_type;

  /// No description provided for @sett_ante.
  ///
  /// In en, this message translates to:
  /// **'Ante value'**
  String get sett_ante;

  /// No description provided for @sett_progression.
  ///
  /// In en, this message translates to:
  /// **'Progression'**
  String get sett_progression;

  /// No description provided for @sett_progression_manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get sett_progression_manual;

  /// No description provided for @sett_progression_hands.
  ///
  /// In en, this message translates to:
  /// **'N hands'**
  String get sett_progression_hands;

  /// No description provided for @sett_progression_hands_left.
  ///
  /// In en, this message translates to:
  /// **'Hands left'**
  String get sett_progression_hands_left;

  /// No description provided for @sett_progression_minutes.
  ///
  /// In en, this message translates to:
  /// **'N minutes'**
  String get sett_progression_minutes;

  /// No description provided for @sett_progression_minutes_left.
  ///
  /// In en, this message translates to:
  /// **'Minutes left'**
  String get sett_progression_minutes_left;

  /// No description provided for @sett_progression_hands_interval.
  ///
  /// In en, this message translates to:
  /// **'Hands interval'**
  String get sett_progression_hands_interval;

  /// No description provided for @sett_progression_minutes_interval.
  ///
  /// In en, this message translates to:
  /// **'Minutes interval'**
  String get sett_progression_minutes_interval;

  /// No description provided for @sett_levels_count.
  ///
  /// In en, this message translates to:
  /// **'Levels count'**
  String get sett_levels_count;

  /// No description provided for @sett_level.
  ///
  /// In en, this message translates to:
  /// **'Lvl'**
  String get sett_level;

  /// No description provided for @sett_level_full.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get sett_level_full;

  /// No description provided for @sett_small_blind.
  ///
  /// In en, this message translates to:
  /// **'Small blind'**
  String get sett_small_blind;

  /// No description provided for @sett_big_blind.
  ///
  /// In en, this message translates to:
  /// **'Big blind'**
  String get sett_big_blind;

  /// No description provided for @sett_mode_simple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get sett_mode_simple;

  /// No description provided for @sett_mode_pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get sett_mode_pro;

  /// No description provided for @sett_level_blind.
  ///
  /// In en, this message translates to:
  /// **'Blinds'**
  String get sett_level_blind;

  /// No description provided for @sett_level_ante.
  ///
  /// In en, this message translates to:
  /// **'Ante'**
  String get sett_level_ante;

  /// No description provided for @ante_type_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get ante_type_none;

  /// No description provided for @ante_type_traditional.
  ///
  /// In en, this message translates to:
  /// **'Basic (All)'**
  String get ante_type_traditional;

  /// No description provided for @ante_type_big_blind.
  ///
  /// In en, this message translates to:
  /// **'BBA (Only Bb)'**
  String get ante_type_big_blind;

  /// No description provided for @toast_unav.
  ///
  /// In en, this message translates to:
  /// **'Unavailible now'**
  String get toast_unav;

  /// No description provided for @toast_incorrect_player.
  ///
  /// In en, this message translates to:
  /// **'Check for name and initial stack'**
  String get toast_incorrect_player;

  /// No description provided for @toast_playp_edit_new_dealer.
  ///
  /// In en, this message translates to:
  /// **'New dealer is -'**
  String get toast_playp_edit_new_dealer;

  /// No description provided for @toast_playp_edit_no_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter player name'**
  String get toast_playp_edit_no_name;

  /// No description provided for @toast_playp_edit_no_icon.
  ///
  /// In en, this message translates to:
  /// **'Please select icon for player'**
  String get toast_playp_edit_no_icon;

  /// No description provided for @toast_game_error_state_editing.
  ///
  /// In en, this message translates to:
  /// **'Cannot edit player list on this state'**
  String get toast_game_error_state_editing;

  /// No description provided for @toast_purchases_updating_error.
  ///
  /// In en, this message translates to:
  /// **'Error while updating purchases'**
  String get toast_purchases_updating_error;

  /// No description provided for @toast_purchase_success_named.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your purchase:'**
  String get toast_purchase_success_named;

  /// No description provided for @toast_video_ad_success.
  ///
  /// In en, this message translates to:
  /// **'Thank you for watching video ad!'**
  String get toast_video_ad_success;

  /// No description provided for @toast_purchase_error_named.
  ///
  /// In en, this message translates to:
  /// **'Found error with purchase:'**
  String get toast_purchase_error_named;

  /// No description provided for @toast_purchase_pending_state_named.
  ///
  /// In en, this message translates to:
  /// **'Your purchase is pending:'**
  String get toast_purchase_pending_state_named;

  /// No description provided for @purchases_restore_button.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get purchases_restore_button;

  /// No description provided for @purchase_done_text.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchase_done_text;

  /// No description provided for @check_table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get check_table;

  /// No description provided for @check_player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get check_player;

  /// No description provided for @check_rf.
  ///
  /// In en, this message translates to:
  /// **'Royal Flush'**
  String get check_rf;

  /// No description provided for @check_sf.
  ///
  /// In en, this message translates to:
  /// **'Straight Flush'**
  String get check_sf;

  /// No description provided for @check_fok.
  ///
  /// In en, this message translates to:
  /// **'Four Of A Kind'**
  String get check_fok;

  /// No description provided for @check_fh.
  ///
  /// In en, this message translates to:
  /// **'Full House'**
  String get check_fh;

  /// No description provided for @check_f.
  ///
  /// In en, this message translates to:
  /// **'Flush'**
  String get check_f;

  /// No description provided for @check_s.
  ///
  /// In en, this message translates to:
  /// **'Straight'**
  String get check_s;

  /// No description provided for @check_tok.
  ///
  /// In en, this message translates to:
  /// **'Three Of A Kind'**
  String get check_tok;

  /// No description provided for @check_2p.
  ///
  /// In en, this message translates to:
  /// **'Two Pair'**
  String get check_2p;

  /// No description provided for @check_p.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get check_p;

  /// No description provided for @check_hc.
  ///
  /// In en, this message translates to:
  /// **'High Card'**
  String get check_hc;

  /// No description provided for @check_picker.
  ///
  /// In en, this message translates to:
  /// **'Pick card'**
  String get check_picker;

  /// No description provided for @check_toast.
  ///
  /// In en, this message translates to:
  /// **'Already exist'**
  String get check_toast;

  /// No description provided for @update_title.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in'**
  String get update_title;

  /// No description provided for @update_1.
  ///
  /// In en, this message translates to:
  /// **'Fixed many application issues, improved user experience'**
  String get update_1;

  /// No description provided for @update_2.
  ///
  /// In en, this message translates to:
  /// **'A donation page has been added to support the author, I will be glad of any help'**
  String get update_2;

  /// No description provided for @update_3.
  ///
  /// In en, this message translates to:
  /// **'PRO users can their photos from the gallery to players'**
  String get update_3;

  /// No description provided for @update_4.
  ///
  /// In en, this message translates to:
  /// **'PRO users can undo their last game action'**
  String get update_4;

  /// No description provided for @update_5.
  ///
  /// In en, this message translates to:
  /// **'PRO users can customize the blind structure in the settings'**
  String get update_5;

  /// No description provided for @update_6.
  ///
  /// In en, this message translates to:
  /// **'Added the ability to customize the ante'**
  String get update_6;

  /// No description provided for @pro_version_offer_title.
  ///
  /// In en, this message translates to:
  /// **'Maximum features in the PRO version'**
  String get pro_version_offer_title;

  /// No description provided for @pro_version_offer_options_available.
  ///
  /// In en, this message translates to:
  /// **'You already have:'**
  String get pro_version_offer_options_available;

  /// No description provided for @pro_version_offer_price_duration.
  ///
  /// In en, this message translates to:
  /// **'forever'**
  String get pro_version_offer_price_duration;

  /// No description provided for @pro_version_offer_option_1.
  ///
  /// In en, this message translates to:
  /// **'Сhanging app theme'**
  String get pro_version_offer_option_1;

  /// No description provided for @pro_version_offer_option_2.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get pro_version_offer_option_2;

  /// No description provided for @pro_version_offer_option_3.
  ///
  /// In en, this message translates to:
  /// **'Winner solver'**
  String get pro_version_offer_option_3;

  /// No description provided for @pro_version_offer_option_4.
  ///
  /// In en, this message translates to:
  /// **'Up to 10 players in the lobby'**
  String get pro_version_offer_option_4;

  /// No description provided for @pro_version_offer_option_5.
  ///
  /// In en, this message translates to:
  /// **'Saving players & game progress'**
  String get pro_version_offer_option_5;

  /// No description provided for @pro_version_offer_option_6.
  ///
  /// In en, this message translates to:
  /// **'Custom player avatars'**
  String get pro_version_offer_option_6;

  /// No description provided for @pro_version_offer_option_7.
  ///
  /// In en, this message translates to:
  /// **'Undo last action'**
  String get pro_version_offer_option_7;

  /// No description provided for @pro_version_offer_option_8.
  ///
  /// In en, this message translates to:
  /// **'Blind structure in settings'**
  String get pro_version_offer_option_8;

  /// No description provided for @pro_version_offer_button_purchased.
  ///
  /// In en, this message translates to:
  /// **'PRO active'**
  String get pro_version_offer_button_purchased;

  /// No description provided for @pro_version_offer_button_not_purchased.
  ///
  /// In en, this message translates to:
  /// **'Get PRO'**
  String get pro_version_offer_button_not_purchased;

  /// No description provided for @pro_version_offer_button_not_available.
  ///
  /// In en, this message translates to:
  /// **'Currently unavailable'**
  String get pro_version_offer_button_not_available;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
