// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../state/user_provider.dart';
// import '../widgets/user_card.dart';

// class UserListScreen extends StatelessWidget {
//   const UserListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User List'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: userProvider.fetchUsers,
//         child: userProvider.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : userProvider.error != null
//                 ? Center(child: Text(userProvider.error!))
//                 : ListView.builder(
//                     itemCount: userProvider.users.length,
//                     itemBuilder: (context, index) {
//                       return UserCard(user: userProvider.users[index]);
//                     },
//                   ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_provider.dart';
import '../widgets/user_card.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final filteredUsers = userProvider.users
        .where((user) => user.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: userProvider.fetchUsers,
        child: userProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : userProvider.error != null
                ? Center(child: Text(userProvider.error!))
                : filteredUsers.isEmpty
                    ? const Center(child: Text('No users found'))
                    : ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          return UserCard(user: filteredUsers[index]);
                        },
                      ),
      ),
    );
  }
}
