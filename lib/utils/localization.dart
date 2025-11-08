import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings =
      {}; // Không dùng late nữa

  AppLocalizations(this.locale);

  static AppLocalizations? of(
    BuildContext context,
  ) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
  }

  Future<bool> load() async {
    try {
      // Thử load file từ assets/lang/
      String
      jsonString = await rootBundle.loadString(
        'assets/lang/${locale.languageCode}.json',
      );
      Map<String, dynamic> jsonMap = json.decode(
        jsonString,
      );

      _localizedStrings = jsonMap.map(
        (key, value) =>
            MapEntry(key, value.toString()),
      );

      return true;
    } catch (e) {
      print(
        'Error loading localization for ${locale.languageCode}: $e',
      );

      // Fallback: thử load từ lib/assets/lang/ nếu không tìm thấy
      try {
        String
        jsonString = await rootBundle.loadString(
          'lib/assets/lang/${locale.languageCode}.json',
        );
        Map<String, dynamic> jsonMap = json
            .decode(jsonString);

        _localizedStrings = jsonMap.map(
          (key, value) =>
              MapEntry(key, value.toString()),
        );

        return true;
      } catch (e2) {
        print(
          'Error loading fallback localization: $e2',
        );
        // Khởi tạo với map rỗng để tránh lỗi
        _localizedStrings = {};
        return false;
      }
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? '**$key**';
  }

  static const LocalizationsDelegate<
    AppLocalizations
  >
  delegate = _AppLocalizationsDelegate();

  // Getter methods cho tất cả các key trong JSON
  String get appTitle => translate('app_title');
  String get noTasksTitle =>
      translate('no_tasks_title');
  String get noTasksSubtitle =>
      translate('no_tasks_subtitle');
  String get taskHint => translate('task_hint');
  String get statusCompleted =>
      translate('status_completed');
  String get statusPending =>
      translate('status_pending');
  String get addSuccess =>
      translate('add_success');
  String get deleteSuccess =>
      translate('delete_success');
  String get updateSuccess =>
      translate('update_success');
  String get deleteConfirmTitle =>
      translate('delete_confirm_title');
  String get deleteConfirmMessage =>
      translate('delete_confirm_message');
  String get deleteCancel =>
      translate('delete_cancel');
  String get deleteConfirm =>
      translate('delete_confirm');
  String get editTaskTitle =>
      translate('edit_task_title');
  String get editTaskHint =>
      translate('edit_task_hint');
  String get editCancel =>
      translate('edit_cancel');
  String get editSave => translate('edit_save');
  String get taskOptionsEdit =>
      translate('task_options_edit');
  String get taskOptionsMarkComplete =>
      translate('task_options_mark_complete');
  String get taskOptionsMarkIncomplete =>
      translate('task_options_mark_incomplete');
  String get taskOptionsDelete =>
      translate('task_options_delete');
  String get welcomeTitleLogin =>
      translate('welcome_title_login');
  String get welcomeSubtitleLogin =>
      translate('welcome_subtitle_login');
  String get loginEmailLabel =>
      translate('login_email_label');
  String get loginPasswordLabel =>
      translate('login_password_label');
  String get loginButtonText =>
      translate('login_button_text');
  String get fillInfoWarning =>
      translate('fill_info_warning');
  String get loginSuccess =>
      translate('login_success');
  String get loginFailed =>
      translate('login_failed');
  String get loginOrText =>
      translate('login_or_text');
  String get createAccountText =>
      translate('create_account_text');
  String get footerTextHome =>
      translate('footer_text_home');
  String get calendarTitle =>
      translate('calendar_title');
  String get tasksForDay =>
      translate('tasks_for_day');
  String get meetingTeam =>
      translate('meeting_team');
  String get reviewCode =>
      translate('review_code');
  String get deployProd =>
      translate('deploy_prod');
  String get profileEditLabel =>
      translate('profile_edit_label');
  String get profileNameLabel =>
      translate('profile_name_label');
  String get profileEmailLabel =>
      translate('profile_email_label');
  String get profilePhoneLabel =>
      translate('profile_phone_label');
  String get profileAddressLabel =>
      translate('profile_address_label');
  String get profileSaveChanges =>
      translate('profile_save_changes');
  String get profileLoadingError =>
      translate('profile_loading_error');
  String get profileSaveSuccess =>
      translate('profile_save_success');
  String get profileSaveError =>
      translate('profile_save_error');
  String get profileBackButton =>
      translate('profile_back_button');
  String get notificationPageTitle =>
      translate('notification_page_title');
  String get notificationTaskCompletedTitle =>
      translate(
        'notification_task_completed_title',
      );
  String get notificationTaskCompletedSubtitle =>
      translate(
        'notification_task_completed_subtitle',
      );
  String get notificationTaskCompletedTime =>
      translate(
        'notification_task_completed_time',
      );
  String get notificationProfileUpdatedTitle =>
      translate(
        'notification_profile_updated_title',
      );
  String get notificationProfileUpdatedSubtitle =>
      translate(
        'notification_profile_updated_subtitle',
      );
  String get notificationProfileUpdatedTime =>
      translate(
        'notification_profile_updated_time',
      );
  String get notificationProjectUpdatedTitle =>
      translate(
        'notification_project_updated_title',
      );
  String get notificationProjectUpdatedSubtitle =>
      translate(
        'notification_project_updated_subtitle',
      );
  String get notificationProjectUpdatedTime =>
      translate(
        'notification_project_updated_time',
      );
  String get notificationSecurityAlertTitle =>
      translate(
        'notification_security_alert_title',
      );
  String get notificationSecurityAlertSubtitle =>
      translate(
        'notification_security_alert_subtitle',
      );
  String get notificationSecurityAlertTime =>
      translate(
        'notification_security_alert_time',
      );
  String get profilePageTitle =>
      translate('profile_page_title');
  String get profileDefaultUserName =>
      translate('profile_default_user_name');
  String get profileTasksLabel =>
      translate('profile_tasks_label');
  String get profileProjectsLabel =>
      translate('profile_projects_label');
  String get profileDaysLabel =>
      translate('profile_days_label');
  String get profileEditMenu =>
      translate('profile_edit_menu');
  String get profileNotificationMenu =>
      translate('profile_notification_menu');
  String get profileSecurityMenu =>
      translate('profile_security_menu');
  String get profileHelpMenu =>
      translate('profile_help_menu');
  String get profileLogoutMenu =>
      translate('profile_logout_menu');
  String get registerHeaderTitle =>
      translate('register_header_title');
  String get registerHeaderSubtitle =>
      translate('register_header_subtitle');
  String get registerEmailLabel =>
      translate('register_email_label');
  String get registerPasswordLabel =>
      translate('register_password_label');
  String get registerConfirmPasswordLabel =>
      translate(
        'register_confirm_password_label',
      );
  String get registerPasswordRequirement =>
      translate('register_password_requirement');
  String get registerButtonText =>
      translate('register_button_text');
  String get registerOrDivider =>
      translate('register_or_divider');
  String get registerLoginButton =>
      translate('register_login_button');
  String get registerTermsText =>
      translate('register_terms_text');
  String get registerTermsLink =>
      translate('register_terms_link');
  String get registerSnackbarEmptyFields =>
      translate('register_snackbar_empty_fields');
  String get registerSnackbarPasswordMismatch =>
      translate(
        'register_snackbar_password_mismatch',
      );
  String get registerSnackbarPasswordShort =>
      translate(
        'register_snackbar_password_short',
      );
  String get registerSnackbarSuccess =>
      translate('register_snackbar_success');
  String get registerSnackbarFail =>
      translate('register_snackbar_fail');
  String get securityPageTitle =>
      translate('security_page_title');
  String get securityChangePassword =>
      translate('security_change_password');
  String get securityTwoFactorAuth =>
      translate('security_two_factor_auth');
  String get securityTwoFactorSnackbar =>
      translate('security_two_factor_snackbar');
  String get securityLoggedDevices =>
      translate('security_logged_devices');
  String get securityLoggedDevicesSnackbar =>
      translate(
        'security_logged_devices_snackbar',
      );
  String get securityDeleteAccount =>
      translate('security_delete_account');
  String get securityDeleteAccountSnackbar =>
      translate(
        'security_delete_account_snackbar',
      );
  String get statisticsPageTitle =>
      translate('statistics_page_title');
  String get statisticsSummaryCompleted =>
      translate('statistics_summary_completed');
  String get statisticsSummaryInProgress =>
      translate('statistics_summary_in_progress');
  String get statisticsSummaryOverdue =>
      translate('statistics_summary_overdue');
  String get statisticsWeeklyProgress =>
      translate('statistics_weekly_progress');
  String get statisticsTaskDistribution =>
      translate('statistics_task_distribution');
  String get statisticsProductivityTrends =>
      translate('statistics_productivity_trends');
  String get statisticsDaysMon =>
      translate('statistics_days_mon');
  String get statisticsDaysTue =>
      translate('statistics_days_tue');
  String get statisticsDaysWed =>
      translate('statistics_days_wed');
  String get statisticsDaysThu =>
      translate('statistics_days_thu');
  String get statisticsDaysFri =>
      translate('statistics_days_fri');
  String get statisticsDaysSat =>
      translate('statistics_days_sat');
  String get statisticsDaysSun =>
      translate('statistics_days_sun');
  String get bottomNavHome =>
      translate('bottom_nav_home');
  String get bottomNavCalendar =>
      translate('bottom_nav_calendar');
  String get bottomNavStatistics =>
      translate('bottom_nav_statistics');
  String get bottomNavProfile =>
      translate('bottom_nav_profile');
  String get loadingText =>
      translate('loading_text');
  String get teamTitle => translate('team_title');
  String get teamIntro => translate('team_intro');
  String get roleLeaderBackend =>
      translate('role_leader_backend');
  String get roleFrontend =>
      translate('role_frontend');
  String get labelSchool =>
      translate('label_school');
  String get labelFaculty =>
      translate('label_faculty');
  String get labelMajor =>
      translate('label_major');
  String get labelClass =>
      translate('label_class');
  String get labelStudentId =>
      translate('label_student_id');
  String get labelDob => translate('label_dob');
  String get labelEmail =>
      translate('label_email');
  String get languageEnglish =>
      translate('language_english');
  String get languageVietnamese =>
      translate('language_vietnamese');

  // Helper method cho list
  List<String> getMonthNames() {
    String monthNamesString = translate(
      'month_names',
    );
    // Xử lý chuỗi JSON array thành List
    if (monthNamesString.startsWith('[') &&
        monthNamesString.endsWith(']')) {
      try {
        List<dynamic> monthList = json.decode(
          monthNamesString,
        );
        return monthList
            .map((e) => e.toString())
            .toList();
      } catch (e) {
        return monthNamesString
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',');
      }
    }
    return monthNamesString.split(',');
  }
}

class _AppLocalizationsDelegate
    extends
        LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['vi', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(
    Locale locale,
  ) async {
    AppLocalizations localizations =
        AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(
    _AppLocalizationsDelegate old,
  ) => false;
}
