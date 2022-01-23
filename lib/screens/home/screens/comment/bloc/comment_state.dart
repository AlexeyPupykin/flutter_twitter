part of 'comment_bloc.dart';

enum CommentStatus { initial, loading, submitting, loaded, error }

class CommentState extends Equatable {
  final PostModel? post;
  final List<CommentModel?> commentList;
  final CommentStatus status;
  final Failure failure;
  final bool isLiked;
  final VoidCallback onLike;
  final bool postAuthor;
  final VoidCallback onPostDelete;
  final int likes;
  final int comments;

  factory CommentState.initial() {
    return CommentState(
      post: null,
      commentList: [],
      status: CommentStatus.initial,
      failure: const Failure(),
      isLiked: false,
      onLike: () {},
      postAuthor: false,
      onPostDelete: () {},
      likes: 0,
      comments: 0,
    );
  }

  CommentState copyWith({
    PostModel? postModel,
    List<CommentModel?>? commentList,
    CommentStatus? status,
    Failure? failure,
    bool? isLiked,
    VoidCallback? onLike,
    bool? postAuthor,
    VoidCallback? onPostDelete,
    int? likes,
    int? comments,
  }) {
    return CommentState(
      post: postModel ?? this.post,
      commentList: commentList ?? this.commentList,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isLiked: isLiked ?? this.isLiked,
      onLike: onLike ?? this.onLike,
      postAuthor: postAuthor ?? this.postAuthor,
      onPostDelete: onPostDelete ?? this.onPostDelete,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  const CommentState({
    required this.post,
    required this.commentList,
    required this.status,
    required this.failure,
    required this.isLiked,
    required this.onLike,
    required this.postAuthor,
    required this.onPostDelete,
    required this.likes,
    required this.comments,
  });

  @override
  List<Object?> get props => [
        post,
        commentList,
        status,
        failure,
        isLiked,
        onLike,
        postAuthor,
        onPostDelete,
        likes,
        comments,
      ];
}
