import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../core/values/api_url.dart';
import '../category_model.dart';
import '../enums/auth_type.dart';
import '../manga_model.dart';
import '../services/local_storage_service.dart';

class MangaProvider extends GetConnect {
  final LocalStorageService _localStorageService =
      Get.find<LocalStorageService>();

  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is List) {
        return map.map<Manga>((item) => Manga.fromMap(item)).toList();
      }
      if (map is Map<String, dynamic>) return Manga.fromMap(map);
    };
    httpClient.baseUrl = _localStorageService.baseURL + mangaUrl;
    httpClient.timeout = Duration(minutes: 5);
    httpClient.addRequestModifier((Request request) async {
      final token = _localStorageService.basicAuth;
      // Set the header
      if (_localStorageService.baseAuthType == AuthType.basic) {
        request.headers['Authorization'] = token;
      }
      return request;
    });
  }

  Future<Manga?> getManga(int id, {bool fetchFreshData = true}) async {
    final response = await get('/$id/?onlineFetch=$fetchFreshData');
    if (response.hasError) return Manga();
    return response.body;
  }

  Future<List<Category>?> getMangaCategoryList(int id) async {
    final response = await get(
      '/$id/category',
      decoder: (map) {
        if (map is List) {
          return map.map<Category>((item) => Category.fromMap(item)).toList();
        }
      },
    );
    if (response.hasError) return <Category>[];
    return response.body;
  }

  Future<Response> patchMangaMeta(
          int mangaId, MapEntry<String, String> formdata) async =>
      await patch(
        '/$mangaId/meta',
        FormData(
          {
            "key": formdata.key,
            "value": formdata.value,
          },
        ),
      );

  Future<Response> addMangaToLibrary(int id) async {
    final response = await get('/$id/library');
    return response;
  }

  Future<Response> removeMangaFromLibrary(int id) async {
    final response = await delete('/$id/library');
    return response;
  }

  Future<Response> addMangaToCategory(int mangaId, int categoryId) async {
    final response = await get('/$mangaId/category/$categoryId');
    return response;
  }

  Future<Response> removeMangaFromCategory(int mangaId, int categoryId) async {
    final response = await delete('/$mangaId/category/$categoryId');
    return response;
  }
}
