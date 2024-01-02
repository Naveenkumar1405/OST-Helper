import 'package:flutter/material.dart';

import '../../../common/domain/entity/ost_user_entity.dart';
import '../../../../core/config/injection_container.dart' as di;
import '../../data/home_fb_data_source.dart';
import '../widget/drawer.dart';
import 'users_list.dart';

/// @author : Jibin K John
/// @date   : 02/01/2024
/// @time   : 11:58:54

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<bool> _loading = ValueNotifier(true);
  final ValueNotifier<String> _error = ValueNotifier("");
  final ValueNotifier<List<OSTUserEntity>> _allUsers = ValueNotifier([]);
  final HomeFbDataSource _homeFbDataSource = di.sl<HomeFbDataSource>();

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  void dispose() {
    _loading.dispose();
    _allUsers.dispose();
    _error.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Active Users",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
              valueListenable: _loading,
              builder: (_, loading, __) {
                if (loading) return const SizedBox.shrink();
                return IconButton(
                  onPressed: _loadUsers,
                  icon: const Icon(Icons.refresh_rounded),
                );
              }),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: _loading,
          builder: (_, loading, __) {
            return ValueListenableBuilder(
                valueListenable: _error,
                builder: (_, error, __) {
                  if (loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!loading && error.isNotEmpty) {
                    return SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_rounded,
                              color: Colors.red, size: 50.0),
                          Text(error),
                          ElevatedButton(
                            onPressed: _loadUsers,
                            child: const Text("Retry"),
                          )
                        ],
                      ),
                    );
                  }

                  return UsersList(allUsers: _allUsers);
                });
          }),
      drawer: const CustomDrawer(),
    );
  }

  Future<void> _loadUsers() async {
    _loading.value = true;
    final response = await _homeFbDataSource.getAllUsers();
    if (response.isRight) {
      _allUsers.value = response.right;
    } else {
      _error.value = response.left.message;
    }
    _loading.value = false;
  }
}
