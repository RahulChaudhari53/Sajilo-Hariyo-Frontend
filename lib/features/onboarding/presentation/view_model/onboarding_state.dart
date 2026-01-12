import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int index;

  const OnboardingState({required this.index});

  factory OnboardingState.initial() => const OnboardingState(index: 0);

  OnboardingState copyWith({int? index}) {
    return OnboardingState(index: index ?? this.index);
  }

  @override
  List<Object?> get props => [index];
}
