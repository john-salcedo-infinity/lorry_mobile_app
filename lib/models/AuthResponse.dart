import 'dart:convert';

import 'package:app_lorry/models/models.dart';

class AuthResponse {
    bool? success;
    List<String>? messages;
    Data? data;

    AuthResponse({
        this.success,
        this.messages,
        this.data,
    });

    factory AuthResponse.fromRawJson(String str) => AuthResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        success: json["success"],
        messages: json["messages"] == null ? [] : List<String>.from(json["messages"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x)),
        "data": data?.toJson(),
    };
}

class Data {
    User? user;
    List<MenuAcce>? menuAcces;
    String? token;
    String? refreshToken;
    String? accessTokenLifetime;
    String? refreshTokenLifetime;

    Data({
        this.user,
        this.menuAcces,
        this.token,
        this.refreshToken,
        this.accessTokenLifetime,
        this.refreshTokenLifetime,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        menuAcces: json["menu_acces"] == null ? [] : List<MenuAcce>.from(json["menu_acces"]!.map((x) => MenuAcce.fromJson(x))),
        token: json["token"],
        refreshToken: json["refresh-token"],
        accessTokenLifetime: json["access_token_lifetime"],
        refreshTokenLifetime: json["refresh_token_lifetime"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "menu_acces": menuAcces == null ? [] : List<dynamic>.from(menuAcces!.map((x) => x.toJson())),
        "token": token,
        "refresh-token": refreshToken,
        "access_token_lifetime": accessTokenLifetime,
        "refresh_token_lifetime": refreshTokenLifetime,
    };
}

class MenuAcce {
    int? optionOrder;
    Option? option;

    MenuAcce({
        this.optionOrder,
        this.option,
    });

    factory MenuAcce.fromRawJson(String str) => MenuAcce.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MenuAcce.fromJson(Map<String, dynamic> json) => MenuAcce(
        optionOrder: json["option_order"],
        option: json["option"] == null ? null : Option.fromJson(json["option"]),
    );

    Map<String, dynamic> toJson() => {
        "option_order": optionOrder,
        "option": option?.toJson(),
    };
}

class Option {
    int? id;
    bool? collapsible;
    String? path;
    String? href;
    String? name;
    String? mobileName;
    String? description;
    String? icon;
    int? iconSize;
    int? fontSize;
    List<Option>? children;

    Option({
        this.id,
        this.collapsible,
        this.path,
        this.href,
        this.name,
        this.mobileName,
        this.description,
        this.icon,
        this.iconSize,
        this.fontSize,
        this.children,
    });

    factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        collapsible: json["collapsible"],
        path: json["path"],
        href: json["href"],
        name: json["name"],
        mobileName: json["mobile_name"],
        description: json["description"],
        icon: json["icon"],
        iconSize: json["icon_size"],
        fontSize: json["font_size"],
        children: json["children"] == null ? [] : List<Option>.from(json["children"]!.map((x) => Option.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collapsible": collapsible,
        "path": path,
        "href": href,
        "name": name,
        "mobile_name": mobileName,
        "description": description,
        "icon": icon,
        "icon_size": iconSize,
        "font_size": fontSize,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
    };
}
