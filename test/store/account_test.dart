import 'package:flutter_test/flutter_test.dart';

import 'package:stream_state/store/account.dart';

void main() {
  test("AccountStore doUpdateSubbed should update store.account.subscribed",
      () async {
    final account = Account();
    final store = AccountStore(account: account);
    final expected = true;

    store.subscribedStream.listen(
      expectAsync1((actual) {
        expect(actual, expected);
      }),
    );
    await doUpdateSubbed(store, expected);
    expect(store.account.subscribed, expected);
  });
  test(
      "AccountStore doToggleSubscribed should update store.account.subscribed to the opposite of previously set",
      () async {
    final account = Account(subscribed: true);
    final store = AccountStore(account: account);
    final expected = false;

    store.subscribedStream.listen(
      expectAsync1((actual) {
        expect(actual, expected);
      }),
    );
    await doToggleSubscribed(store);
    expect(store.account.subscribed, expected);
  });
}
