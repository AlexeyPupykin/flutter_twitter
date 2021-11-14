import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/bloc/user_event.dart';
import 'package:flutter_twitter/bloc/user_state.dart';
import 'package:flutter_twitter/models/user.dart';
import 'package:flutter_twitter/services/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UsersRepository? usersRepository;
  UserBloc({this.usersRepository})
      : assert(usersRepository != null),
        super(UserEmptyState());

  @override
  UserState get initialState => UserEmptyState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoadEvent) {
      yield UserLoadingState();
      try {
        final List<User> _loadedUserList = await usersRepository!.getAllUsers();
        yield UserLoadedState(loadedUser: _loadedUserList);
      } catch (_) {
        yield UserErrorState();
      }
    } else if (event is UserClearEvent) {
      yield UserEmptyState();
    }
  }
}
