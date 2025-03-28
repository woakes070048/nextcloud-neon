import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/settings/utils/settings_export_helper.dart';
import 'package:neon_framework/src/settings/widgets/account_settings_tile.dart';
import 'package:neon_framework/src/settings/widgets/custom_settings_tile.dart';
import 'package:neon_framework/src/settings/widgets/option_settings_tile.dart';
import 'package:neon_framework/src/settings/widgets/settings_category.dart';
import 'package:neon_framework/src/settings/widgets/settings_list.dart';
import 'package:neon_framework/src/settings/widgets/settings_tile.dart';
import 'package:neon_framework/src/theme/branding.dart';
import 'package:neon_framework/src/theme/dialog.dart';
import 'package:neon_framework/src/theme/icons.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/widgets/dialog.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/timezone.dart' as tz;

final _log = Logger('SettingsPage');

/// Categories of the [SettingsPage].
///
/// Used with [SettingsPage.initialCategory] to scroll to a specific section.
/// Values are in order of appearance but are not guaranteed to be included on
/// the settings page.
@internal
enum SettingsCategories {
  /// `AppImplementationOptions` category.
  ///
  /// Each activated `AppImplementation` has an entry if it has any options specified.
  apps,

  /// Theming category.
  theme,

  /// Device navigation category.
  navigation,

  /// Push notifications category.
  pushNotifications,

  /// Startup category.
  startup,

  /// Account management category.
  ///
  /// Also includes the `AccountOptions`.
  accounts,

  /// Other category.
  ///
  /// Contains legal information and various links.
  other,
}

/// Settings page.
///
/// Settings are specified as `Option`s.
@internal
class SettingsPage extends StatelessWidget {
  /// Creates a new settings page.
  const SettingsPage({
    this.initialCategory,
    super.key,
  });

  /// The optional initial category to show.
  final SettingsCategories? initialCategory;

  @override
  Widget build(BuildContext context) {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final appImplementations = NeonProvider.of<BuiltSet<AppImplementation>>(context);
    final branding = Branding.of(context);

    final appBar = AppBar(
      title: Text(NeonLocalizations.of(context).settings),
      actions: [
        IconButton(
          onPressed: () async {
            final content =
                '${NeonLocalizations.of(context).settingsResetAllConfirmation} ${NeonLocalizations.of(context).settingsResetAllExplanation}';
            final decision = await showAdaptiveDialog<bool>(
              context: context,
              builder: (context) => NeonConfirmationDialog(
                icon: const Icon(Icons.restart_alt),
                title: NeonLocalizations.of(context).settingsReset,
                content: Text(content),
              ),
            );

            if (decision ?? false) {
              globalOptions.reset();

              for (final appImplementation in appImplementations) {
                appImplementation.options.reset();
              }

              for (final account in accountsBloc.accounts.value) {
                accountsBloc.getOptionsFor(account).reset();
              }
            }
          },
          tooltip: NeonLocalizations.of(context).settingsResetAll,
          icon: const Icon(MdiIcons.cogRefresh),
        ),
      ],
    );
    final body = SettingsList(
      initialCategoryKey: initialCategory?.name,
      categories: [
        SettingsCategory(
          hasLeading: true,
          title: Text(NeonLocalizations.of(context).settingsApps),
          key: ValueKey(SettingsCategories.apps.name),
          tiles: <SettingsTile>[
            for (final appImplementation in appImplementations)
              if (appImplementation.options.options.isNotEmpty)
                CustomSettingsTile(
                  leading: appImplementation.buildIcon(),
                  title: Text(appImplementation.name(context)),
                  onTap: () {
                    AppImplementationSettingsRoute(appid: appImplementation.id).go(context);
                  },
                ),
          ],
        ),
        SettingsCategory(
          title: Text(NeonLocalizations.of(context).optionsCategoryTheme),
          key: ValueKey(SettingsCategories.theme.name),
          tiles: [
            SelectSettingsTile(
              option: globalOptions.themeMode,
            ),
            ToggleSettingsTile(
              option: globalOptions.themeOLEDAsDark,
            ),
            ToggleSettingsTile(
              option: globalOptions.themeUseNextcloudTheme,
            ),
            ToggleSettingsTile(
              option: globalOptions.themeCustomBackground,
            ),
          ],
        ),
        SettingsCategory(
          title: Text(NeonLocalizations.of(context).optionsCategoryNavigation),
          key: ValueKey(SettingsCategories.navigation.name),
          tiles: [
            SelectSettingsTile(
              option: globalOptions.navigationMode,
            ),
          ],
        ),
        if (NeonPlatform.instance.canUsePushNotifications) buildNotificationsCategory(context),
        if (NeonPlatform.instance.canUseWindowManager)
          SettingsCategory(
            title: Text(NeonLocalizations.of(context).optionsCategoryStartup),
            key: ValueKey(SettingsCategories.startup.name),
            tiles: [
              ToggleSettingsTile(
                option: globalOptions.startupMinimized,
              ),
              ToggleSettingsTile(
                option: globalOptions.startupMinimizeInsteadOfExit,
              ),
            ],
          ),
        ...buildAccountCategory(context),
        SettingsCategory(
          hasLeading: true,
          title: Text(NeonLocalizations.of(context).optionsCategoryOther),
          key: ValueKey(SettingsCategories.other.name),
          tiles: [
            if (branding.sourceCodeURL != null)
              CustomSettingsTile(
                leading: Icon(
                  Icons.code,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(NeonLocalizations.of(context).sourceCode),
                onTap: () async {
                  await launchUrl(NeonProvider.of<Account>(context), branding.sourceCodeURL!);
                },
              ),
            if (branding.issueTrackerURL != null)
              CustomSettingsTile(
                leading: Icon(
                  MdiIcons.textBoxEditOutline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(NeonLocalizations.of(context).issueTracker),
                onTap: () async {
                  await launchUrl(NeonProvider.of<Account>(context), branding.issueTrackerURL!);
                },
              ),
            CustomSettingsTile(
              leading: Icon(
                MdiIcons.scriptText,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(NeonLocalizations.of(context).licenses),
              onTap: () async {
                showLicensePage(
                  context: context,
                  applicationName: branding.name,
                  applicationIcon: branding.logo,
                  applicationLegalese: branding.legalese,
                  applicationVersion: NeonProvider.of<PackageInfo>(context).version,
                );
              },
            ),
            CustomSettingsTile(
              leading: Icon(
                MdiIcons.export,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(NeonLocalizations.of(context).settingsExport),
              onTap: () async {
                final settingsExportHelper = _buildSettingsExportHelper(context);

                try {
                  final fileName = 'nextcloud-neon-settings-${tz.TZDateTime.now(tz.UTC).secondsSinceEpoch}.json';

                  final data = settingsExportHelper.exportToFile();
                  await NeonPlatform.instance.saveFileWithPickDialog(fileName, 'application/json', data);
                } on Exception catch (error, stackTrace) {
                  _log.info(
                    'Error selecting an export destination.',
                    error,
                    stackTrace,
                  );

                  if (context.mounted) {
                    NeonError.showSnackbar(context, error);
                  }
                }
              },
            ),
            CustomSettingsTile(
              leading: Icon(
                MdiIcons.import,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(NeonLocalizations.of(context).settingsImport),
              onTap: () async {
                final settingsExportHelper = _buildSettingsExportHelper(context);

                try {
                  final result = await FilePicker.platform.pickFiles(
                    withReadStream: true,
                  );

                  if (result == null) {
                    return;
                  }

                  if (!result.files.single.path!.endsWith('.json')) {
                    if (context.mounted) {
                      NeonError.showSnackbar(
                        context,
                        NeonLocalizations.of(context).settingsImportWrongFileExtension,
                      );
                    }
                    return;
                  }

                  await settingsExportHelper.applyFromFile(result.files.single.readStream);
                } on Exception catch (error, stackTrace) {
                  _log.info(
                    'Error importing settings.',
                    error,
                    stackTrace,
                  );

                  if (context.mounted) {
                    NeonError.showSnackbar(context, error);
                  }
                }
              },
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: NeonDialogTheme.of(context).constraints,
            child: body,
          ),
        ),
      ),
    );
  }

  Widget buildNotificationsCategory(BuildContext context) {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);

    return SettingsCategory(
      title: Text(NeonLocalizations.of(context).optionsCategoryPushNotifications),
      key: ValueKey(SettingsCategories.pushNotifications.name),
      tiles: [
        SelectSettingsTile(
          option: globalOptions.pushNotificationsDistributor,
        ),
      ],
    );
  }

  Iterable<Widget> buildAccountCategory(BuildContext context) sync* {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final accounts = accountsBloc.accounts.value;
    final hasMultipleAccounts = accounts.length > 1;

    final title = Text(NeonLocalizations.of(context).optionsCategoryAccounts);
    final key = ValueKey(SettingsCategories.accounts.name);
    final accountTiles = accounts.map(
      (account) => AccountSettingsTile(
        account: account,
        userDetailsBloc: accountsBloc.getUserDetailsBlocFor(account),
        userStatusBloc: accountsBloc.getUserStatusBlocFor(account),
        onTap: () => AccountSettingsRoute(accountID: account.id).go(context),
      ),
    );
    final rememberLastUsedAccountTile = ToggleSettingsTile(
      option: globalOptions.rememberLastUsedAccount,
    );
    final initialAccountTile = SelectSettingsTile(
      option: globalOptions.initialAccount,
    );

    if (isCupertino(context)) {
      if (hasMultipleAccounts) {
        yield SettingsCategory(
          title: title,
          key: key,
          tiles: [
            rememberLastUsedAccountTile,
            initialAccountTile,
          ],
        );
      }
      final addAccountTile = CustomSettingsTile(
        leading: const Icon(
          CupertinoIcons.add,
        ),
        title: Text(NeonLocalizations.of(context).globalOptionsAccountsAdd),
        onTap: () async => const LoginRoute().push(context),
      );

      yield CupertinoListSection.insetGrouped(
        header: !hasMultipleAccounts ? title : null,
        key: !hasMultipleAccounts ? key : null,
        children: [
          ...accountTiles,
          addAccountTile,
        ],
      );
    } else {
      final addAccountTile = CustomSettingsTile(
        title: ElevatedButton.icon(
          onPressed: () async => const LoginRoute().push(context),
          icon: Icon(AdaptiveIcons.add_account),
          label: Text(NeonLocalizations.of(context).globalOptionsAccountsAdd),
        ),
      );

      yield SettingsCategory(
        title: title,
        key: key,
        tiles: [
          if (hasMultipleAccounts) rememberLastUsedAccountTile,
          if (hasMultipleAccounts) initialAccountTile,
          ...accountTiles,
          addAccountTile,
        ],
      );
    }
  }

  SettingsExportHelper _buildSettingsExportHelper(BuildContext context) {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final appImplementations = NeonProvider.of<BuiltSet<AppImplementation>>(context);

    return SettingsExportHelper(
      exportables: {
        globalOptions,
        AccountsBlocExporter(accountsBloc),
        AppImplementationsExporter(appImplementations),
      },
    );
  }
}
