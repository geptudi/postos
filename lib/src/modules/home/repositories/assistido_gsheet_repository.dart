import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../interfaces/asssistido_remote_storage_interface.dart';
import '../models/device_info_model.dart';

class AssistidoRemoteStorageRepository
    implements AssistidoRemoteStorageInterface {
  Dio? provider;
  final String baseUrl = 'https://script.google.com';
  final DeviceInfoModel deviceInfoModel = DeviceInfoModel();

  AssistidoRemoteStorageRepository({Dio? provider}) {
    this.provider = provider ?? Modular.get<Dio>();
  }

  @override
  Future<void> init() async {
    await deviceInfoModel.initPlatformState();
  }

  Future<dynamic> sendGet(
      {String table = "BDados",
      required String func,
      required String type,
      dynamic p1,
      dynamic p2,
      dynamic p3}) async {
    var response = await provider?.get(
      '$baseUrl/macros/s/AKfycbwKiHbY2FQ295UrySD3m8pG_JDJO5c8SFxQG4VQ9eo9pzZQMmEfpAZYKdhVJcNtznGV/exec',
      queryParameters: {
        "table": table,
        "func": func,
        "type": type,
        "userName": "",
        "p1": p1,
        "p2": p2,
        "p3": p3,
      },
    );
    if (response?.data != null) {
      if ((response?.data?["status"] ?? "Error") == "SUCCESS") {
        return response?.data!["items"];
      } else {
        debugPrint(
            "AssistidoRemoteStorageRepository - sendUrl - ${response?.data["status"]}");
      }
    }
    return null;
  }

  @override
  Future<int?> addData(List<dynamic>? value, {String table = "BDados"}) async {
    if (value != null) {
      return (sendGet(table: table, func: 'add', type: 'data', p1: value)
          as Future<int?>);
    }
    return null;
  }

  @override
  Future<String?> addFile(
      String targetDir, String fileName, Uint8List data) async {
    return (await sendGet(
        func: 'add',
        type: 'file',
        p1: targetDir,
        p2: fileName,
        p3: data)); //base64.encode(data).toString()));
  }

  @override
  Future<List<dynamic>?> getDatas(
      {String table = "BDados",
      String? planilha,
      String? columnFilter,
      String? valueFilter}) async {
    final panilhaId = switch (planilha!) {
      'Bezerra de Menezes' => '0',
      'Mãe Zeferina' => '2',
      'Simão Pedro' => '3',
      _ => '1',
    };
    List<dynamic>? response = await sendGet(
        table: table,
        func: 'get',
        type: 'datas',
        p1: panilhaId,
        p2: columnFilter ?? "",
        p3: valueFilter ?? "");
    return response;
    /*if (response != null) {
        if ((response as List).isNotEmpty) {
        return response.map((e) => Assistido.fromList(e)).toList();
      }
    }
    return null;*/
  }

  @override
  Future<List<dynamic>?> getChanges({String table = "BDados"}) async {
    List<dynamic>? response =
        await sendGet(table: table, func: 'get', type: 'changes');
    return response;
    /*if (response != null) {
        if ((response as List).isNotEmpty) {
        return response.map((e) => Assistido.fromList(e)).toList();
      }
    }
    return null;*/
  }

  @override
  Future<List<dynamic>?> getRow(String rowId, {String table = "BDados"}) async {
    final List<dynamic> response =
        await sendGet(func: 'get', type: 'datas', p1: rowId);
    return response;
  }

  @override
  Future<String?> getFile(String targetDir, String fileName) async {
    if (fileName.isNotEmpty) {
      final String? response =
          await sendGet(func: 'get', type: 'file', p1: targetDir, p2: fileName);
      return response;
    }
    return null;
  }

  @override
  Future<String?> setData(String rowsId, List<dynamic> data,
      {String table = "BDados"}) async {
    final String? response = await sendGet(
        table: table, func: 'set', type: 'data', p1: rowsId, p2: data);
    return response;
  }

  @override
  Future<String?> setFile(
      String targetDir, String fileName, Uint8List data) async {
    final String? response = await sendGet(
        func: 'set',
        type: 'file',
        p1: targetDir,
        p2: fileName,
        p3: data); //base64.encode(data).toString());
    return response;
  }

  @override
  Future<dynamic> deleteData(String row, {String table = "BDados"}) async {
    final response =
        await sendGet(table: table, func: 'del', type: 'data', p1: row);
    return response;
  }

  @override
  Future<dynamic> deleteFile(String targetDir, String fileName) async {
    final dynamic response =
        await sendGet(func: 'del', type: 'file', p1: targetDir, p2: fileName);
    return response;
  }
}
