import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:stream_state/services/account_service.dart';

/// Model
class Account {
  const Account({
    this.accountId,
    this.subscribed = false,
  });
  final String accountId;
  final bool subscribed;

  Account copyWith({
    String accountId,
    bool subscribed,
  }) =>
      Account(
        accountId: accountId ?? this.accountId,
        subscribed: subscribed ?? this.subscribed,
      );
}

enum Status { Idle, Busy }

/// Data Store (sometimes called Repo)
class AccountStore {
  AccountStore({
    this.account = const Account(subscribed: false),
  }) {
    subbedStreamCtrl.sink.add(account?.subscribed ?? false);
    errorStreamCtrl.sink.add(error);
  }

  StreamController<bool> subbedStreamCtrl = StreamController<bool>.broadcast();
  Stream<bool> get subscribedStream => subbedStreamCtrl.stream;

  StreamController<String> errorStreamCtrl =
      StreamController<String>.broadcast();
  Stream<String> get errorStream => errorStreamCtrl.stream;

  StreamController<Status> statusStreamCtrl =
      StreamController<Status>.broadcast();
  Stream<Status> get statusStream => statusStreamCtrl.stream;

  Account account;
  String error;

  /// Actions
  void subscribe() => doUpdateSubbed(this, true);
  void ubsubscribe() => doUpdateSubbed(this, false);
  void toggleSubscribed() => doToggleSubscribed(this);

  /// Store selector gets the full store object if found in the widget tree.
  /// Very much like `Provider.of(context)`
  /// Store streams can be listened to with [StreamBuilder] or [Observer]
  /// /// ```dart
  /// final store = AccountStore.of(context);
  /// ```
  static AccountStore of(BuildContext context) {
    final account =
        context.dependOnInheritedWidgetOfExactType<InheritedAccount>()?.data;
    if (account == null)
      throw Exception('Could not find InheritedAccount in widget tree');
    return account;
  }

  /// State selector is used as a snapshot. It won't be updated once rendered.
  /// To get updates, use a [StreamBuilder]/[Observer]
  /// ```dart
  /// final account = AccountStore.state(context);
  /// ```
  static Account state(BuildContext context) {
    final account = context
        .dependOnInheritedWidgetOfExactType<InheritedAccount>()
        ?.data
        ?.account;
    if (account == null)
      throw Exception('Could not find InheritedAccount in widget tree');
    return account;
  }

  void dispose() async {
    await subbedStreamCtrl.close();
    await errorStreamCtrl.close();
  }
}

/// Testable function reducers
Future<void> doToggleSubscribed(AccountStore store) async {
  await doUpdateSubbed(store, !store.account.subscribed);
}

Future<void> doUpdateSubbed(AccountStore store, bool _subbed) async {
  final AccountService accountService = AccountService();

  store.error = null;
  store.errorStreamCtrl.add(null);
  store.statusStreamCtrl.add(Status.Busy);
  CallResponse resp;

  if (_subbed) {
    resp = await accountService.subscribe(store.account);
  } else {
    resp = await accountService.unSubscribe(store.account);
  }
  if (resp.hasError) {
    final error = "Error updating subscription";
    store.error = error;
    return store.errorStreamCtrl.add(error);
  }

  store.account = store.account.copyWith(subscribed: _subbed);
  store.subbedStreamCtrl.sink.add(_subbed);
  store.statusStreamCtrl.add(Status.Idle);
}

/// Provider analogue
class InheritedAccount extends InheritedWidget {
  InheritedAccount({this.data, this.child});
  final AccountStore data;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedAccount old) => true;
}
