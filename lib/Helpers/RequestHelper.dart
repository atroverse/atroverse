import 'dart:convert';

import 'package:http/http.dart' as http;

import 'PrefHelpers.dart';

enum WebControllers {
  accounts,
  atro,
  favorite,
  wills,
  profiles,
  activity,
  ticket,
  config,
}

enum WebMethods {
  register,
  login,
  list,
  create,
  archive_create,
  mark_create,
  user_archive,
  user_mark,
  notif_list,
  create_request,
  request_list,
  admin_notif_list,
  firend_list,
  detail,
  logout,
  password_change,
  firend_ship_delete,
  rule,
  reset_email,
  chage_email_verify,
  fcm_update,
  email_verify,
  email_verify_send,
  delete_account,
  report_create,
  friend_create,
  publish_will_notif,
  friend_code_create,
  user_atro,
  update_info
}

class RequestHelper {
  static const String BaseUrl = 'http://162.254.32.119';

  static Future<ApiResult> _makeRequestGet({
    WebControllers? webController,
    WebMethods? webMethod,
    Map<String, String> header = const {},
    Map body = const {},
    Map<String, dynamic> queryParameters = const {},
  }) async {
    String url = RequestHelper._makePath3(webController);
    print(
        "Request url: $url\nRequest body: ${jsonEncode(body)}\n ${jsonEncode(header)}\n");
    http.Response response = await http.get(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: header);
    print(Uri.parse(url).replace(queryParameters: queryParameters));
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'].toString();
        print(data['message']);
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'];
        apiResult.requestedMethod = webMethod.toString().split('.').last;
        apiResult.data = response.body;
      }
    } else {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      apiResult.message = data['message'];
      apiResult.isDone = false;
    }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> _makeRequestGet2({
    WebControllers? webController,
    WebMethods? webMethod,
    Map<String, String> header = const {},
    Map body = const {},
    Map<String, dynamic> queryParameters = const {},
  }) async {
    String url = RequestHelper._makePath(webController, webMethod);
    print(
        "Request url: $url\nRequest body: ${jsonEncode(body)}\n ${jsonEncode(header)}\n");
    http.Response response = await http.get(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: header);
    print(Uri.parse(url).replace(queryParameters: queryParameters));
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      try {
        Map data = jsonDecode(utf8.decode(response.bodyBytes));

        apiResult.message = data['message'].toString();
        print(data['message']);
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'];
        apiResult.requestedMethod = webMethod.toString().split('.').last;
        apiResult.data = response.body;
      }
    } else {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      apiResult.message = data['message'];
      apiResult.isDone = false;
    }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> _makeRequestGet3({
    WebControllers? webController,
    WebMethods? webMethod,
    Map<String, String> header = const {},
    Map body = const {},
    Map<String, dynamic> queryParameters = const {},
  }) async {
    String url = RequestHelper._makePath2(webMethod);
    print(
        "Request url: $url\nRequest body: ${jsonEncode(body)}\n ${jsonEncode(header)}\n");
    http.Response response = await http.get(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: header);
    print(Uri.parse(url).replace(queryParameters: queryParameters));
    print(queryParameters);
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'].toString();
        print(data['message']);
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'];
        apiResult.requestedMethod = webMethod.toString().split('.').last;
        apiResult.data = response.body;
      }
    } else {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      apiResult.message = data['message'];
      apiResult.isDone = false;
    }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> _makeRequestPost({
    WebControllers? webController,
    WebMethods? webMethod,
    Map<String, String> header = const {},
    Map<String, dynamic> queryParameters = const {},
    Map body = const {},
  }) async {
    String url = RequestHelper._makePath(webController, webMethod);
    print(
        "Request url: $url\nRequest body: ${jsonEncode(body)}\n ${jsonEncode(header)}\n");
    http.Response response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: header,
        body: body);
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    // apiResult.data2 = jsonDecode(response.body);
    Map data2 = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 201) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'].toString();
        print(data['message']);
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
        apiResult.data2 = data2;

        apiResult.data2 = data;
      } catch (e) {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        apiResult.requestedMethod = webMethod.toString().split('.').last;
        apiResult.data = response.body;
      }
    } else {
      apiResult.message = data2["message"];
      apiResult.isDone = false;
    }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data2}"
        "}");
    print(await PrefHelpers.getToken());
    return apiResult;
  }

  static Future<ApiResult> _makeRequestPost2({
    WebMethods? webMethod,
    Map<String, String> header = const {},
    Map<String, dynamic> queryParameters = const {},
    Map body = const {},
  }) async {
    String url = RequestHelper._makePath2(webMethod);
    print(
        "Request url: $url\nRequest body: ${jsonEncode(body)}\n ${jsonEncode(header)}\n");
    http.Response response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: header,
        body: body);
    print(Uri.parse(url).replace(queryParameters: queryParameters));
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    print(body);
    // apiResult.data2 = jsonDecode(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 400 ||
        response.statusCode == 201) {
      try {
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'].toString();
        print(data['message']);
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'];
        apiResult.requestedMethod = webMethod.toString().split('.').last;
        apiResult.data = response.body;
      }
    } else {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      apiResult.message = data['message'];
      apiResult.isDone = false;
    }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data2}"
        "}");
    print(await PrefHelpers.getToken());
    return apiResult;
  }

  static Future<ApiResult> _makeRequestPut({
    WebControllers? webController,
    WebMethods? webMethod,
    Map<String, String> header = const {},
    Map<String, dynamic> queryParameters = const {},
    Map body = const {},
  }) async {
    String url = RequestHelper._makePath3(webController);
    print(
        "Request url: $url\nRequest body: ${jsonEncode(body)}\n ${jsonEncode(header)}\n");
    http.Response response = await http.put(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: header,
        body: body);
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    apiResult.data2 = jsonDecode(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 201) {
      try {
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data['message'].toString();
        print(data['message']);
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        apiResult.message = data["message"];
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        apiResult.requestedMethod = webMethod.toString().split('.').last;
        apiResult.data = response.body;
      }
    } else {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      apiResult.message = data['message'];
      apiResult.isDone = false;
    }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data2}"
        "}");
    print(await PrefHelpers.getToken());
    return apiResult;
  }

  static String _makePath(
      WebControllers? webController, WebMethods? webMethod) {
    return "${RequestHelper.BaseUrl}/${webController?.toString().split('.').last}/api/${webMethod.toString().split('.').last}/";
  }

  static String _makePath2(WebMethods? webMethod) {
    return "${RequestHelper.BaseUrl}/api/${webMethod.toString().split('.').last}/";
  }

  static String _makePath3(WebControllers? webController) {
    return "${RequestHelper.BaseUrl}/${webController.toString().split('.').last}/api/";
  }

  // static Future<ApiResult> LoginOtp({String? mobile, String? code}) async {
  //   return await RequestHelper._makeRequestPost(
  //     webController: WebControllers.auth,
  //     webMethod: WebMethods.verify_code,
  //     body: {'phone_number': mobile, 'code': code},
  //   ).timeout(
  //     Duration(seconds: 50),
  //   );
  // }
  //

  static Future<ApiResult> getUpdateInfo() async {
    return await RequestHelper._makeRequestGet2(
        webController: WebControllers.config,
        webMethod: WebMethods.update_info,).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> login({String? email, String? password}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.accounts,
        webMethod: WebMethods.login,
        body: {
          "email": email,
          "password": password,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getWillList() async {
    return await RequestHelper._makeRequestGet2(
      webController: WebControllers.wills,
      webMethod: WebMethods.list,
    ).timeout(
      const Duration(seconds: 50),
    );
  }


  static Future<ApiResult> getUserAtroList() async {
    return await RequestHelper._makeRequestGet2(
        webController: WebControllers.atro,
        webMethod: WebMethods.user_atro,
        header: {"Authorization": "Token ${await PrefHelpers.getToken()}"}
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getFavoriteList() async {
    return await RequestHelper._makeRequestGet(
        webController: WebControllers.favorite,
        header: {"Authorization": "Token ${await PrefHelpers.getToken()}"})
        .timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getProfile() async {
    return await RequestHelper._makeRequestGet(
        webController: WebControllers.profiles,
        header: {"Authorization": "Token ${await PrefHelpers.getToken()}"})
        .timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> updateProfile(
      {String? bio,
        String? bDate,
        String? user_name,
        String? first_name,
        String? city,
        String? state,
        String? country,
        String? last_name}) async {
    return await RequestHelper._makeRequestPut(
        webController: WebControllers.profiles,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "county": country,
          "city": city,
          "state": state,
          "user_name": user_name,
          "bio": bio,
          "first_name": first_name,
          "last_name": last_name,
          "birthdate": bDate
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> createFavorite(
      {String? caption, String? cover}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.accounts,
        webMethod: WebMethods.login,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "caption": caption,
          "cover": cover,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> createArchive({String? model, String? id}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.activity,
        webMethod: WebMethods.archive_create,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "model": model,
          "id": id,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> report({String? model, String? id}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.activity,
        webMethod: WebMethods.report_create,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "model": model,
          "id": id,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> generateCode() async {
    return await RequestHelper._makeRequestPost(
      webController: WebControllers.accounts,
      webMethod: WebMethods.friend_code_create,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> ticketCreate(
      {String? title, String? body, String? type}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.ticket,
        webMethod: WebMethods.create,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "title": title,
          "body": body,
          "type": type,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> sendFcm({String? fcm}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.accounts,
        webMethod: WebMethods.fcm_update,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "fcm_token": fcm,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> createMark({String? model, String? id}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.activity,
        webMethod: WebMethods.mark_create,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "model": model,
          "id": id,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> createWill(
      {String? caption, String? sound, var list}) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.wills,
        webMethod: WebMethods.create,
        header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
        body: {"caption": caption, "sound": sound, "medias": list}).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> createRequest({
    String? id,
  }) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.wills,
        webMethod: WebMethods.create_request,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "owner": id,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> changePassWord({
    String? oldPass,
    String? newPass,
  }) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.accounts,
        webMethod: WebMethods.password_change,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "old_password": oldPass,
          "new_password": newPass,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> changeEmailVerify({
    String? email,
    String? code,
  }) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.accounts,
        webMethod: WebMethods.chage_email_verify,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "email": email,
          "code": code,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> changeEmail({String? email}) async {
    return await RequestHelper._makeRequestPost(
      webController: WebControllers.accounts,
      webMethod: WebMethods.reset_email,
      body: {"email": email},
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> emailVerifySend() async {
    return await RequestHelper._makeRequestPost(
      webController: WebControllers.accounts,
      webMethod: WebMethods.email_verify_send,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> deleteFriend({
    String? toUser,
  }) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.profiles,
        webMethod: WebMethods.firend_ship_delete,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "to_user": toUser,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> verifyEmail({
    String? code,
  }) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.accounts,
        webMethod: WebMethods.email_verify,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "code": code,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> addFriend({
    String? code,
  }) async {
    return await RequestHelper._makeRequestPost(
        webController: WebControllers.accounts,
        webMethod: WebMethods.friend_create,
        header: {
          "Authorization": "Token ${await PrefHelpers.getToken()}"
        },
        body: {
          "code": code,
        }).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getArchiveList() async {
    return await RequestHelper._makeRequestGet2(
      webController: WebControllers.activity,
      webMethod: WebMethods.user_archive,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getMarkList() async {
    return await RequestHelper._makeRequestGet2(
      webController: WebControllers.activity,
      webMethod: WebMethods.user_mark,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getRequestList() async {
    return await RequestHelper._makeRequestGet2(
      webController: WebControllers.wills,
      webMethod: WebMethods.publish_will_notif,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getAdminNotifList() async {
    return await RequestHelper._makeRequestGet2(
      webController: WebControllers.wills,
      webMethod: WebMethods.publish_will_notif,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getNotifList() async {
    return await RequestHelper._makeRequestGet2(
      webController: WebControllers.activity,
      webMethod: WebMethods.notif_list,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

  static Future<ApiResult> getFriendList() async {
    return await RequestHelper._makeRequestGet2(
      webController: WebControllers.profiles,
      webMethod: WebMethods.firend_list,
      header: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    ).timeout(
      const Duration(seconds: 50),
    );
  }

//  **************************************************************************
//  **************************************************************************
//  **************************************************************************

  static Future<ApiResult> createComment(
      {String? comment,
        String? model_name,
        String? model_id,
        String? app_name,
        String? parent_id}) async {
    String url =
        "http://162.254.32.119/api/comments/create/?model_name=$model_name&model_id=$model_id&app_name=$app_name&parent_id=${parent_id == null || parent_id == "null" ? "" : parent_id}";
    print(url);
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"},
        body: {"content": comment});
    ApiResult apiResult = new ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> deleteWill({String? id}) async {
    String url = "http://162.254.32.119/wills/api/delete/$id/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getUserWill() async {
    String url = "http://162.254.32.119/wills/api/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> deleteArchive({String? id}) async {
    String url =
        "http://162.254.32.119/activity/api/archive_delete/$id/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> deleteMark({String? id}) async {
    String url = "http://162.254.32.119/activity/api/mark_delete/$id/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> block({String? id}) async {
    String url =
        "http://162.254.32.119/profiles/api/create_block/$id/";
    print(url);
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 201) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> blocklist() async {
    String url = "http://162.254.32.119/profiles/api/block_list/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> unBlock(id) async {
    String url =
        "http://162.254.32.119/profiles/api/remove_block/$id/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> deleteCm({String? id}) async {
    String url = "http://162.254.32.119/api/comments/delete/$id/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 204) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> editAtro(
      {String? id, String? question, String? answer}) async {
    String url = "http://162.254.32.119/atro/api/update/$id/";
    print(url);
    http.Response response = await http.patch(Uri.parse(url), body: {
      "question": question,
      "answer": answer,
    }, headers: {
      "Authorization": "Token ${await PrefHelpers.getToken()}"
    });
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> editAtro2(
      {String? id, String? status}) async {
    String url = "http://162.254.32.119/atro/api/update/$id/";
    print(url);
    http.Response response = await http.patch(Uri.parse(url), body: {
      "status": status,
    }, headers: {
      "Authorization": "Token ${await PrefHelpers.getToken()}"
    });
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> editWill({String? id, String? caption}) async {
    String url = "http://162.254.32.119/wills/api/update/$id/";
    print(url);
    http.Response response = await http.patch(Uri.parse(url), body: {
      "caption": caption,
    }, headers: {
      "Authorization": "Token ${await PrefHelpers.getToken()}"
    });
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> deleteAtro({String? id}) async {
    String url = "http://162.254.32.119/atro/api/delete/$id/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> deleteAccount() async {
    String url = "$BaseUrl/accounts/api/delete_account/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> delete_account_verify({String? code}) async {
    String url = "$BaseUrl/accounts/api/delete_account_verify/";
    print(url);
    http.Response response = await http.post(Uri.parse(url),
        body: {"code": code},
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> cancelFriend({String? id}) async {
    String url =
        "http://162.254.32.119/profiles/api/firend_ship_delete/$id/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> forgetPassword({String? email}) async {
    String url = "http://162.254.32.119/auth/users/reset_password/";
    print(url);
    http.Response response = await http.post(Uri.parse(url), body: {
      "email": email,
    });
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    Map data2 = jsonDecode(utf8.decode(response.bodyBytes));
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        apiResult.message = data2["message"];
        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.message = data2["message"];
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> register(
      {String? url, String? email, String? password, String? code}) async {
    String register = "http://162.254.32.119/accounts/api/register/";
    String friendShip =
        "http://162.254.32.119/accounts/api/friend_ship/";
    print((url!.startsWith("r") == true) ? register : friendShip);
    http.Response response = await http.post(
      Uri.parse(
          (url.toLowerCase().startsWith("r") == true) ? register : friendShip),
      body: url.startsWith("r") == true
          ? {"email": email, "password": password, "code": url}
          : {"email": email, "password": password, "code": url},
    );
    print({"email": email, "password": password, "code": url});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    Map data2 = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.message = data["message"];
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data;
        apiResult.data2 = data2;
      } catch (e) {
        apiResult.message = data2["message"];
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.message = data2["message"];
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getWills({String? email}) async {
    String url = "http://162.254.32.119/wills/api/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getRule() async {
    String url = "http://162.254.32.119/config/api/rule/";
    print(url);
    http.Response response = await http.get(Uri.parse(url));
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getAtroDetail({String? id}) async {
    String url = "http://162.254.32.119/atro/api/detail/$id/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getTicketList() async {
    String url = "http://162.254.32.119/ticket/api/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getTicketDetail({String? id}) async {
    String url = "http://162.254.32.119/ticket/api/$id/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> sendAnswer({String? id, String? body}) async {
    String url = "http://162.254.32.119/ticket/api/answer/$id/";
    print(url);
    http.Response response = await http.post(Uri.parse(url),
        body: {"body": body},
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getComments(
      {String? appName, String? modelName, String? modelId}) async {
    String url =
        "http://162.254.32.119/api/comments/?app_name=$appName&model_name=$modelName&model_id=$modelId";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getReplyComments({String? id, String? page}) async {
    String url = "http://162.254.32.119/api/comments/$id/?p=$page";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getExploreList({String? uri}) async {
    String url = "";
    if (uri.toString() == "null") {
      url =
      "http://162.254.32.119/atro/api/explorer/?p=1&page_size=25";
    } else {
      url = uri.toString();
    }
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getAtroList({String? uri}) async {
    String url = "";
    if (uri == "null") {
      url = "http://162.254.32.119/atro/api/list/?p=1";
    } else {
      url = uri.toString();
    }
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getAtroListForUser({String? uri}) async {
    String url = "http://162.254.32.119/atro/api/list/?page_size=1000";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getFriendProfile({String? id}) async {
    String url = "http://162.254.32.119/profiles/api/detail/$id/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> getDailyNotif() async {
    String url = "http://162.254.32.119/activity/api/admin_dairly/";
    print(url);
    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> adminUpdate({String? confirm, String? id}) async {
    String url =
        "http://162.254.32.119/wills/api/publish_will_notif_update/$id/";
    print(url);
    http.Response response = await http.post(Uri.parse(url), body: {
      "confirm": confirm.toString(),
    }, headers: {
      "Authorization": "Token ${await PrefHelpers.getToken()}"
    });
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  static Future<ApiResult> logOut() async {
    String url = BaseUrl + "/accounts/api/logout/";
    print(url);
    http.Response response = await http.delete(Uri.parse(url),
        headers: {"Authorization": "Token ${await PrefHelpers.getToken()}"});
    ApiResult apiResult = ApiResult();
    apiResult.statusCode = response.statusCode;
    print(response.body);
    if (response.statusCode == 200) {
      try {
        apiResult.data2 = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body);
        Map data = jsonDecode(utf8.decode(response.bodyBytes));
        apiResult.isDone = data['is_Done'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);
        print(response.body);

        apiResult.requestedMethod = 'api';
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = true;
    }
    print("\nRequest url: $url\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }
}

class ApiResult {
  bool? isDone;
  String? requestedMethod;
  dynamic data;
  dynamic data2;
  String? message;
  var statusCode;

  ApiResult({
    this.isDone,
    this.requestedMethod,
    this.data,
    this.data2,
    this.message,
    this.statusCode,
  });
}

class ListModel {
  ListModel({
    this.zone,
  });

  String? zone;

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
    zone: json["zone"],
  );

  Map<String, dynamic> toJson() => {
    "zone": zone,
  };
}
