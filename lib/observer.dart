import 'package:flutter/material.dart';

class Observer<T> extends StatelessWidget {
  final T initialData;
  final Stream<T> stream;
  final Widget Function(BuildContext, T) builder;
  final Widget onLoading;
  final Widget onError;

  Observer({
    this.initialData,
    @required this.stream,
    @required this.builder,
    this.onLoading,
    this.onError,
  });

  Widget _defaultOnError(String error) {
    return Center(child: Text("Error: $error"));
  }

  Widget _defaultOnLoading() {
    return Center(
      child: Container(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError)
          return onError ?? _defaultOnError(snapshot.error as String);
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.done)
          return builder(context, snapshot.data);

        return onLoading ?? _defaultOnLoading();
      },
    );
  }
}
