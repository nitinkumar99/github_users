import 'dart:convert';

import 'package:flutter/material.dart';

class UserModel {
  String? login;
  int? id;
  String? avatarUrl;

  /// used locally for storing selected users
  bool isSelected = false;

  UserModel({
    this.login,
    this.id,
    this.avatarUrl,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    avatarUrl = json['avatar_url'];
    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['id'] = id;
    data['avatar_url'] = avatarUrl;
    data['isSelected'] = isSelected;
    return data;
  }

  static String encode(List<UserModel> musics) => json.encode(
        musics.map<Map<String, dynamic>>((music) => music.toJson()).toList(),
      );

  static List<UserModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<UserModel>((item) => UserModel.fromJson(item))
          .toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          login == other.login;

  @override
  int get hashCode => hashValues(id, login);
}
