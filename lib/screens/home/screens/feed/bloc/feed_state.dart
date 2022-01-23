part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, loaded, paginating, failure }

class FeedState extends Equatable {
  final List<PostModel?> posts;
  final FeedStatus status;
  final Failure failure;
  final bool hasReachedMax;
  final String? guestLastPostId;

  const FeedState({
    required this.status,
    required this.posts,
    required this.failure,
    required this.hasReachedMax,
    required this.guestLastPostId,
  });

  factory FeedState.initial() {
    return FeedState(
        posts: [],
        status: FeedStatus.initial,
        failure: Failure(),
        hasReachedMax: false,
        guestLastPostId: null);
  }

  FeedState copyWith(
      {FeedStatus? status,
      List<PostModel?>? posts,
      Failure? failure,
      bool? hasReachedMax,
      String? guestLastPostId}) {
    return FeedState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        failure: failure ?? this.failure,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        guestLastPostId: guestLastPostId ?? this.guestLastPostId);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object?> get props =>
      [status, posts, failure, hasReachedMax, guestLastPostId];
}
