import 'package:flutter/material.dart';

import '../../../common/domain/entity/ost_user_entity.dart';
import '../widget/search_field.dart';

/// @author : im_navi

class UsersList extends StatefulWidget {
  final ValueNotifier<List<OSTUserEntity>> allUsers;

  const UsersList({Key? key, required this.allUsers}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final ValueNotifier<String> _query = ValueNotifier("");

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.allUsers,
        builder: (_, users, __) {
          return Column(
            children: [
              SearchField(
                  query: _query,
                  hintText: "Search with name, email or product id"),
              ValueListenableBuilder(
                  valueListenable: _query,
                  builder: (_, query, __) {
                    List<OSTUserEntity> searchedUsers = List.from(users);

                    if (query.isNotEmpty) {
                      searchedUsers = users
                          .where(
                            (element) =>
                                (element.name
                                    .toLowerCase()
                                    .contains(query.toLowerCase())) ||
                                (element.email
                                    .toLowerCase()
                                    .contains(query.toLowerCase())) ||
                                (element.products
                                    .map((e) => e.toLowerCase())
                                    .toList()
                                    .any(
                                      (element) => element.startsWith(
                                        query.toLowerCase(),
                                      ),
                                    )),
                          )
                          .toList();
                    }

                    if (searchedUsers.isEmpty) {
                      return Center(
                        child: Text(
                          'No result found for \'$query\'',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: searchedUsers.length,
                        itemBuilder: (ctx, index) {
                          return ExpansionTile(
                            leading: Text("${index + 1}"),
                            title: Text(
                              searchedUsers[index].name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(searchedUsers[index].email),
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            backgroundColor: Colors.blueAccent.withOpacity(.1),
                            children: List.generate(
                              searchedUsers[index].products.length,
                              (i) => ListTile(
                                leading: Text("${i + 1}"),
                                title: Text(searchedUsers[index].products[i]),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  })
            ],
          );
        });
  }
}
