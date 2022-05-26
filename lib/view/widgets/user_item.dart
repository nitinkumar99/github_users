import 'package:flutter/material.dart';
import 'package:github_users/model/user_model.dart';

class UserItem extends StatefulWidget {
  final UserModel user;
  final VoidCallback addRemoveUserCallback;

  const UserItem(this.user, this.addRemoveUserCallback, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserItemState();
  }
}

class UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.user.login ?? ''),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.avatarUrl ?? ''),
      ),
      trailing: Checkbox(
        value: widget.user.isSelected,
        onChanged: (value) {
          setState(() {
            widget.user.isSelected = value ?? false;
          });
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            widget.addRemoveUserCallback();
          });
        },
      ),
    );
  }
}
