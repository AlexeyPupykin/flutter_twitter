import 'package:flutter_twitter/models/user.dart';
import 'package:flutter_twitter/services/user_api_provider.dart';

class UsersRepository {
  UserProvider _usersProvider = UserProvider();
  Future<List<User>> getAllUsers() => _usersProvider.getUser();
}
