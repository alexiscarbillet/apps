import 'dart:math';

const int exercisesPerSession = 5;

List<T> selectFiveRandom<T>(Iterable<T> bank, {Random? random}) {
  final candidates = bank.toList();
  if (candidates.length < exercisesPerSession) {
    throw ArgumentError.value(
      candidates.length,
      'bank.length',
      'An exercise bank must contain at least $exercisesPerSession items.',
    );
  }

  candidates.shuffle(random);
  return candidates.take(exercisesPerSession).toList(growable: false);
}
