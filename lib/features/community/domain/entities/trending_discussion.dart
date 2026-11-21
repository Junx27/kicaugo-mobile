import 'package:equatable/equatable.dart';

/// Diskusi paling ramai minggu ini.
class TrendingDiscussion extends Equatable {
  const TrendingDiscussion({
    required this.title,
    required this.author,
    required this.quote,
    required this.replies,
    required this.views,
    required this.likes,
  });

  final String title;
  final String author;
  final String quote;
  final int replies;
  final int views;
  final int likes;

  @override
  List<Object?> get props => [title, author, quote, replies, views, likes];
}
