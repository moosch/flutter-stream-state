import 'package:flutter_test/flutter_test.dart';

import 'package:stream_state/store/user.dart';

void main() {
  test("UserStore doUpdateUserName should update store.user", () async {
    final user = User(id: "123", name: "Jimbo Jones");
    final store = UserStore(user: user);
    final expected = "Max Power";

    store.nameStream.listen(
      expectAsync1((actual) {
        expect(actual, expected);
      }),
    );
    doUpdateUserName(store, expected);
    expect(store.user.name, expected);
  });

  test("UserStore doChangeName should update store.user to $robotName",
      () async {
    final user = User(id: "123", name: "Jimbo Jones");
    final store = UserStore(user: user);
    final expected = robotName;

    store.nameStream.listen(
      expectAsync1((actual) {
        expect(actual, expected);
      }),
    );
    doChangeName(store);
    expect(store.user.name, expected);
  });
}
