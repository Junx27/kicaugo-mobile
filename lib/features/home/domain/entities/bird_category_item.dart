import 'package:equatable/equatable.dart';

/// Kategori burung dari endpoint `/api/v1/home/bird-categories`.
class BirdCategoryItem extends Equatable {
  /// Direktori aset ikon yang dibundling bersama aplikasi.
  static const String iconDirectory = 'assets/bird_categories/';

  const BirdCategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });

  /// Identitas kategori dari backend.
  final int id;

  /// Nama yang ditampilkan pada chip.
  final String name;

  /// Penanda kategori dari backend (filter Beranda memakai [name]).
  final String slug;

  /// Path aset SVG ikon yang sudah resolutif terhadap [iconDirectory].
  final String icon;

  @override
  List<Object?> get props => [id, name, slug, icon];
}
