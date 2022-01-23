import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/blocs/blocs.dart';
import 'package:flutter_twitter/cubit/cubits.dart';
import 'package:flutter_twitter/models/models.dart';
import 'package:flutter_twitter/repositories/post/post_repository.dart';

part 'comment_event.dart';

part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostRepo _postRepo;
  final AuthBloc _authBloc;
  final CommentPostCubit _commentPostCubit;
  final LikePostCubit _likePostCubit;
  StreamSubscription<List<Future<CommentModel?>>>? _commentSubscription;

  CommentBloc({
    required PostRepo postRepo,
    required AuthBloc authBloc,
    required CommentPostCubit commentPostCubit,
    required LikePostCubit likePostCubit,
  })  : _postRepo = postRepo,
        _authBloc = authBloc,
        _commentPostCubit = commentPostCubit,
        _likePostCubit = likePostCubit,
        super(
          CommentState.initial(),
        ) {
    on<FetchCommentEvent>(_onFetchComment);
    on<UpdateCommentsEvent>(_onUpdateComments);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<OnLikeEvent>(onLikeEvent);
  }

  @override
  Future<void> close() {
    _commentSubscription?.cancel();
    return super.close();
  }

  void onLikeEvent(
    OnLikeEvent event,
    Emitter<CommentState> emit,
  ) {
    if (state.isLiked) {
      _likePostCubit.unLikePost(post: state.post!);
      emit(state.copyWith(isLiked: false, likes: state.likes - 1));
    } else {
      _likePostCubit.likePost(post: state.post!);
      emit(state.copyWith(isLiked: true, likes: state.likes + 1));
    }
  }

  void _onFetchComment(
    FetchCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: CommentStatus.loading));
    try {
      _commentSubscription?.cancel();
      _commentSubscription =
          await _postRepo.getPostCommentsStream(postId: event.post.id!).listen(
        (comments) async {
          final allComments = await Future.wait(comments);
          add(UpdateCommentsEvent(commentList: allComments));
        },
      );

      emit(state.copyWith(
        postModel: event.post,
        status: CommentStatus.loaded,
        isLiked: event.isLiked,
        onLike: event.onLike,
        postAuthor: event.postAuthor,
        onPostDelete: event.onPostDelete,
        likes: event.likes,
        comments: event.comments,
      ));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure:
            Failure(message: e.message ?? 'cannot update comments! try again'),
      ));
      print("Firebase Error: ${e.message}");
    } catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(
            message: "We were unable to load this post's comments"),
      ));
      print("Something Unknown Error: $e");
    }
  }

  void _onUpdateComments(
    UpdateCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: CommentStatus.loading));
    try {
      emit(state.copyWith(
          commentList: event.commentList, status: CommentStatus.loaded));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure:
            Failure(message: e.message ?? 'cannot update comments! try again'),
      ));
      print("Firebase Error: ${e.message}");
    } catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(message: 'cannot update comments! try again'),
      ));
      print("Something Unknown Error: $e");
    }
  }

  void _onAddComment(
    AddCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: CommentStatus.submitting));
    try {
      if (state.post == null) {
        emit(state.copyWith(
          status: CommentStatus.error,
          failure: const Failure(message: 'cannot post comment! try again'),
        ));
        return;
      }

      final author = _authBloc.state.user;
      final comment = CommentModel(
        postId: state.post!.id!,
        content: event.content,
        author: author,
        dateTime: DateTime.now(),
      );

      _postRepo.createComment(post: state.post!, comment: comment);
      _commentPostCubit.createComment(post: state.post!, comment: comment);

      emit(state.copyWith(
        status: CommentStatus.loaded,
      ));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure:
            Failure(message: e.message ?? 'cannot post comment! try again'),
      ));
      print("Firebase Error: ${e.message}");
    } catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(message: 'cannot post comment! try again'),
      ));
      print("Something Unknown Error: $e");
    }
  }

  void _onDeleteComment(
    DeleteCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: CommentStatus.submitting));
    try {
      if (state.post == null) {
        emit(state.copyWith(
          status: CommentStatus.error,
          failure: const Failure(message: 'cannot delete comment! try again'),
        ));
        return;
      }

      _postRepo.deleteComment(post: state.post!, comment: event.comment);
      final commentsLength = state.commentList.length;

      var previousComment = null;
      if (commentsLength == 1) {
        previousComment = null;
      } else if (state.commentList.indexOf(event.comment) ==
          commentsLength - 1) {
        previousComment = state.commentList[commentsLength - 2];
      } else {
        previousComment = state.commentList[commentsLength - 1];
      }

      _commentPostCubit.deleteComment(
          post: state.post!,
          comment: event.comment,
          previousComment: previousComment);

      emit(state.copyWith(
        status: CommentStatus.loaded,
      ));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure:
            Failure(message: e.message ?? 'cannot delete comment! try again'),
      ));
      print("Firebase Error: ${e.message}");
    } catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(message: 'cannot detele comment! try again'),
      ));
      print("Something Unknown Error: $e");
    }
  }
}
