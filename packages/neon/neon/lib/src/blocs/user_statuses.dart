import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon/src/bloc/bloc.dart';
import 'package:neon/src/bloc/result.dart';
import 'package:neon/src/blocs/timer.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/platform/platform.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:rxdart/rxdart.dart';
import 'package:window_manager/window_manager.dart';

abstract class UserStatusesBlocEvents {
  void load(final String username, {final bool force = false});
}

abstract class UserStatusesBlocStates {
  BehaviorSubject<Map<String, Result<UserStatusPublic?>>> get statuses;
}

@internal
class UserStatusesBloc extends InteractiveBloc implements UserStatusesBlocEvents, UserStatusesBlocStates {
  UserStatusesBloc(
    this._platform,
    this._account,
  ) {
    unawaited(refresh());
    _timer = TimerBloc().registerTimer(const Duration(minutes: 5), refresh);
  }

  final NeonPlatform _platform;
  final Account _account;
  late final NeonTimer _timer;

  @override
  void dispose() {
    _timer.cancel();
    unawaited(statuses.close());
    super.dispose();
  }

  @override
  BehaviorSubject<Map<String, Result<UserStatusPublic?>>> statuses =
      BehaviorSubject<Map<String, Result<UserStatusPublic?>>>();

  @override
  Future refresh() async {
    for (final username in _statuses.keys) {
      await load(username, force: true);
    }
  }

  @override
  Future load(final String username, {final bool force = false}) async {
    if (!force && _statuses.containsKey(username)) {
      return;
    }

    try {
      _updateStatus(username, Result.loading());

      UserStatusPublic? data;

      if (_account.username == username) {
        final isAway =
            _platform.canUseWindowManager && (!(await windowManager.isFocused()) || !(await windowManager.isVisible()));
        try {
          final response = await _account.client.userStatus.heartbeat.heartbeat(
            status: isAway ? 'away' : 'online',
          );
          data = response.ocs.data.public;
        } catch (e) {
          // 204 is returned if the heartbeat failed because the current status is different. Ignore this and fetch the normal status
          if (e is! DynamiteApiException || e.statusCode != 204) {
            rethrow;
          }
        }
      }

      if (data == null) {
        final response = await _account.client.userStatus.statuses.find(userId: username);
        data = response.ocs.data;
      }

      _updateStatus(username, Result.success(data));
    } catch (e, s) {
      if (e is DynamiteApiException && e.statusCode == 404) {
        _updateStatus(username, Result.success(null));
        return;
      }
      debugPrint(e.toString());
      debugPrint(s.toString());
      _updateStatus(username, Result.error(e));
    }
  }

  Map<String, Result<UserStatusPublic?>> get _statuses => statuses.valueOrNull ?? <String, Result<UserStatusPublic?>>{};

  void _updateStatus(final String username, final Result<UserStatusPublic?> result) {
    statuses.add({
      ..._statuses,
      username: result,
    });
  }
}
