import 'package:flutter_bloc/flutter_bloc.dart';

/// Menyimpan indeks slide onboarding yang sedang aktif.
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit({required this.slideCount}) : super(0);

  final int slideCount;

  /// Apakah slide aktif adalah slide terakhir.
  bool get isLast => state == slideCount - 1;

  /// Pindah ke slide [index] (dari tab atau swipe).
  void select(int index) => emit(index);

  /// Maju satu slide; tidak berbuat apa-apa di slide terakhir.
  void next() {
    if (!isLast) {
      emit(state + 1);
    }
  }
}
