import 'package:get/get.dart';
import 'package:test/test.dart';
// import 'package:flutter_test/flutter_test.dart';

import 'package:get/src/get_container.dart';

void main() {
  GetContainer container = Get;

  group('Silent=true tests', () {
    setUp(() {
      container.clear();
      container.silent = true;
    });

    test('instances should be resolved', () {
      var person = Character('Anakin', 'Skywalker');
      container.registerInstance(5);
      container.registerInstance(6, name: 'named');
      container.registerInstance<num>(7);
      container.registerInstance(person);

      expect(container.resolve<int>(), 5);
      expect(container.resolve<int>('named'), 6);
      expect(container.resolve<num>(), 7);
      expect(container.resolve<num>('named'), null);
      expect(container.resolve<Character>(), person);
    });

    test('instances should be resolveAs', () {
      final sith = Sith('Anakin', 'Skywalker', 'DartVader');
      container.registerSingleton<Character>(() => sith);

      expect(container.resolveAs<Character, Sith>(), sith);
      expect(container.resolveAs<Character, Sith>('named'), null);
    });

    test('container should resolve when called', () {
      var person = Character('Anakin', 'Skywalker');
      container.registerInstance(5);
      container.registerInstance(6, name: 'named');
      container.registerInstance<num>(7);
      container.registerInstance(person);

      expect(container<int>(), 5);
      expect(container<int>('named'), 6);
      expect(container<num>(), 7);
      expect(container<num>('named'), null);
      expect(container<Character>(), person);
    });

    test('instances can be overridden', () {
      container.registerInstance(5);
      expect(container.resolve<int>(), 5);

      container.registerInstance(6);
      expect(container.resolve<int>(), 6);
    });

    test('builders should be resolved', () {
      container.registerSingleton(() => 5);
      container.registerFactory(
          () => const Sith('Anakin', 'Skywalker', 'DartVader'));
      container.registerFactory(() => const Character('Anakin', 'Skywalker'));
      container.registerFactory<Character>(
          () => const Sith('Anakin', 'Skywalker', 'DartVader'),
          name: 'named');

      expect(container.resolve<int>(), 5);
      expect(container.resolve<Sith>(),
          const Sith('Anakin', 'Skywalker', 'DartVader'));
      expect(container.resolve<Character>(),
          const Character('Anakin', 'Skywalker'));
      expect(container.resolve<Character>('named'),
          const Sith('Anakin', 'Skywalker', 'DartVader'));
    });

    test('builders should always be created', () {
      container.registerFactory(() => Character('Anakin', 'Skywalker'));

      expect(container.resolve<Character>(),
          isNot(same(container.resolve<Character>())));
    });

    test('one time builders should be resolved', () {
      container.registerSingleton(() => 5);
      container.registerSingleton(
          () => const Sith('Anakin', 'Skywalker', 'DartVader'));
      container.registerSingleton<Character>(
          () => const Character('Anakin', 'Skywalker'));

      expect(container.resolve<int>(), 5);
      expect(container.resolve<Sith>(),
          const Sith('Anakin', 'Skywalker', 'DartVader'));
      expect(container.resolve<Character>(),
          const Character('Anakin', 'Skywalker'));
    });

    test('one time builders should be created one time only', () {
      container.registerSingleton(() => Character('Anakin', 'Skywalker'));

      expect(container.resolve<Character>(), container.resolve<Character>());
    });

    test('unregister should remove items from container', () {
      container.registerInstance(5);
      container.registerInstance(6, name: 'named');

      expect(container.resolve<int>(), 5);
      expect(container.resolve<int>('named'), 6);

      container.unregister<int>();
      expect(container.resolve<int>(), null);

      container.unregister<int>('named');
      expect(container.resolve<int>('named'), null);
    });
  });

  group('Silent=false tests', () {
    setUp(() {
      container.clear();
      container.silent = false;
    });

    test('instances cannot be overridden', () {
      container.registerInstance(5);
      expect(container.resolve<int>(), 5);

      container.registerInstance(8, name: 'name');
      expect(container.resolve<int>('name'), 8);

      expect(
          () => container.registerInstance(6),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('already'),
          )));

      expect(
          () => container.registerInstance(9, name: 'name'),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('already'),
          )));
    });

    test('values should exist when unregistering', () {
      expect(
          () => container.unregister<int>(),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('not registered'),
          )));

      expect(
          () => container.unregister<int>('name'),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('not registered'),
          )));
    });

    test('values should exist when resolving', () {
      expect(
          () => container.resolve<int>(),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('not registered'),
          )));

      expect(
          () => container.resolve<int>('name'),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('not registered'),
          )));
    });
    test('values should exist when resolving as', () {
      var person = Character('Anakin', 'Skywalker');
      container.registerInstance(person);
      container.registerInstance(person, name: 'named');
      expect(
          () => container.resolveAs<Character, Sith>(),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('not registered'),
          )));

      expect(
          () => container.resolveAs<Character, Sith>('named'),
          throwsA(TypeMatcher<GetException>().having(
            (f) => f.toString(),
            'toString()',
            matches('not registered'),
          )));
    });
  });
}

class Character {
  const Character(
    this.firstName,
    this.lastName,
  );

  final String firstName;
  final String lastName;
}

class Sith extends Character {
  const Sith(
    String firstName,
    String lastName,
    this.id,
  ) : super(firstName, lastName);

  final String id;
}
