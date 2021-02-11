import 'package:flutter_test/flutter_test.dart';

class Foo {
  final int name;
  const Foo(this.name);

  @override
  operator ==(o) => o is Foo && name == o.name;

  @override
  int get hashCode => name;
}

void main() {
  var a1 = const Foo(1);
  var b1 = const Foo(1);

  var a2 = Foo(2);
  var b2 = Foo(2);

  test('same', () {
    expect(a1, same(b1));
    expect(a2, isNot(same(b2)));
  });

  test('equals', () {
    expect(a1, equals(b1));
    expect(a2, equals(b2));
    expect(a1, isNot(equals(a2)));
  });
}
