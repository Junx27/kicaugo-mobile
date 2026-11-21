import '../entities/help_center_content.dart';
import '../repositories/help_center_repository.dart';

/// Usecase memuat konten Pusat Bantuan.
class GetHelpCenterContent {
  const GetHelpCenterContent(this._repository);

  final HelpCenterRepository _repository;

  Future<HelpCenterContent> call() => _repository.fetchHelpCenterContent();
}
