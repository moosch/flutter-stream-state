import 'dart:async';

import 'package:flutter/widgets.dart';

/// Model
class User {
  const User({
    this.id,
    this.name,
  });
  final String id;
  final String name;

  User copyWith({
    String id,
    String name,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}

/// Data Store (sometimes called Repo)
class UserStore {
  UserStore({
    this.user = const User(),
  });

  StreamController<String> nameStreamCtrl =
      StreamController<String>.broadcast();
  Stream<String> get nameStream => nameStreamCtrl.stream;

  User user;

  /// Actions
  void updateUserName(String name) => doUpdateUserName(this, name);
  void changeName() => doChangeName(this);

  /// Store selector gets the full store object if found in the widget tree.
  /// Very much like `Provider.of(context)`
  /// Store streams can be listened to with [StreamBuilder] or [Observer]
  /// /// ```dart
  /// final store = UserStore.of(context);
  /// ```
  static UserStore of(BuildContext context) {
    final user =
        context.dependOnInheritedWidgetOfExactType<InheritedUser>()?.data;
    if (user == null)
      throw Exception('Could not find InheritedUser in widget tree');
    return user;
  }

  /// State selector is used as a snapshot. It won't be updated once rendered.
  /// To get updates, use a [StreamBuilder]/[Observer]
  /// ```dart
  /// final user = UserStore.state(context);
  /// ```
  static User state(BuildContext context) {
    final user =
        context.dependOnInheritedWidgetOfExactType<InheritedUser>()?.data?.user;
    if (user == null)
      throw Exception('Could not find InheritedAccount in widget tree');
    return user;
  }

  void dispose() async {
    await nameStreamCtrl.close();
  }
}

/// Testable function reducers
void doUpdateUserName(UserStore store, String name) {
  store.user = store.user.copyWith(name: name);
  store.nameStreamCtrl.sink.add(name);
}

void doChangeName(UserStore store) {
  final name = robotName;
  store.user = store.user.copyWith(name: name);
  store.nameStreamCtrl.sink.add(name);
}

/// Provider analogue
class InheritedUser extends InheritedWidget {
  InheritedUser({this.data, this.child});
  final UserStore data;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedUser old) => false;
}

const robotName = "Beep boop";
