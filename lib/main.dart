import 'package:flutter/material.dart';

import 'observer.dart';
import 'store/account.dart';
import 'store/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: InheritedAccount(
          data: AccountStore(),
          child: InheritedUser(
            data: UserStore(user: User(name: 'Unknown')),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NonStreamValue(),
                Divider(),
                UserNameStream(),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Builder(
                  builder: (context) {
                    final store = UserStore.of(context);
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () => store.changeName(),
                          child: Text("Silly name"),
                        ),
                        TextButton(
                          onPressed: () => store.updateUserName('Max Power'),
                          child: Text('Rename to "Max Power"'),
                        ),
                      ],
                    );
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                Divider(),
                AccountWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NonStreamValue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = UserStore.state(context);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text('Name is ${user.name}', key: Key('nonStreamName')),
    );
  }
}

class UserNameStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = UserStore.of(context);
    return Observer(
      initialData: store.user.name,
      stream: store.nameStream,
      builder: (context, data) {
        return Text(data);
      },
    );
  }
}

class AccountStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = AccountStore.of(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Account status: '),
        Observer(
          initialData: store.account.subscribed,
          stream: store.subscribedStream,
          builder: (context, data) {
            return data == true ? Icon(Icons.check) : Icon(Icons.close);
          },
        ),
      ],
    );
  }
}

class StreamedAccountAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = AccountStore.of(context);
    return Observer<bool>(
      initialData: store.account.subscribed,
      stream: store.subscribedStream,
      builder: (context, data) {
        if (data) {
          return TextButton(
            onPressed: () => store.ubsubscribe(),
            child: Text("Unubscribe"),
          );
        }
        return TextButton(
          onPressed: () => store.subscribe(),
          child: Text("Subscribe"),
        );
      },
    );
  }
}

class AccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = AccountStore.of(context);
    return Observer<Status>(
      initialData: Status.Idle,
      stream: store.statusStream,
      builder: (builder, status) {
        return Stack(
          children: [
            Column(
              children: [
                AccountStatus(),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                StreamedAccountAction(),
              ],
            ),
            if (status == Status.Busy)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }
}
