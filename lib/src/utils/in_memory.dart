import 'package:rxdart/subjects.dart';

class InMemoryStotr<T> {
  InMemoryStotr(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  final BehaviorSubject<T> _subject;

  Stream<T> get stream => _subject.stream;

  T get value => _subject.value;

  set value(T value) => _subject.add(value);

  void close() => _subject.cast();
}
