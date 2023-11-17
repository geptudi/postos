import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoModel {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? identify;

  Future<bool> initPlatformState() async {
    try {
      if (kIsWeb) {
        identify = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          identify = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          identify = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          identify = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          identify = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          identify = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      identify = null; //'Failed to get platform version.'
    }
    return true;
  }

  _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.id;
    //build.version.securityPatch;
    //build.version.sdkInt;
    //build.version.release;
    //build.version.previewSdkInt;
    //build.version.incremental;
    //build.version.codename;
    //build.version.baseOS;
    //build.board;
    //build.bootloader;
    //build.brand;
    //build.device;
    //build.display;
    //build.fingerprint;
    //build.hardware;
    //build.host;
    //build.manufacturer;
    //build.model;
    //build.product;
    //build.supported32BitAbis;
    //build.supported64BitAbis;
    //build.supportedAbis;
    //build.tags;
    //build.type;
    //build.isPhysicalDevice;
    //build.androidId;
    //build.systemFeatures;
  }

  _readIosDeviceInfo(IosDeviceInfo data) {
    return data.name;
    //'systemName': data.systemName,
    //'systemVersion': data.systemVersion,
    //'model': data.model,
    //'localizedModel': data.localizedModel,
    //'identifierForVendor': data.identifierForVendor,
    //'isPhysicalDevice': data.isPhysicalDevice,
    //'utsname.sysname:': data.utsname.sysname,
    //'utsname.nodename:': data.utsname.nodename,
    //'utsname.release:': data.utsname.release,
    //'utsname.version:': data.utsname.version,
    //'utsname.machine:': data.utsname.machine,
  }

  _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return data.name;
    //'version': data.version,
    //'id': data.id,
    //'idLike': data.idLike,
    //'versionCodename': data.versionCodename,
    //'versionId': data.versionId,
    //'prettyName': data.prettyName,
    //'buildId': data.buildId,
    //'variant': data.variant,
    //'variantId': data.variantId,
    //'machineId': data.machineId,
  }

  _readWebBrowserInfo(WebBrowserInfo data) {
    return data.appName;
    //'browserName': describeEnum(data.browserName),
    //'appCodeName': data.appCodeName,
    //'appVersion': data.appVersion,
    //'deviceMemory': data.deviceMemory,
    //'language': data.language,
    //'languages': data.languages,
    //'platform': data.platform,
    //'product': data.product,
    //'productSub': data.productSub,
    //'userAgent': data.userAgent,
    //'vendor': data.vendor,
    //'vendorSub': data.vendorSub,
    //'hardwareConcurrency': data.hardwareConcurrency,
    //'maxTouchPoints': data.maxTouchPoints,
  }

  _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return data.computerName;
    //'hostName': data.hostName,
    //'arch': data.arch,
    //'model': data.model,
    //'kernelVersion': data.kernelVersion,
    //'osRelease': data.osRelease,
    //'activeCPUs': data.activeCPUs,
    //'memorySize': data.memorySize,
    //'cpuFrequency': data.cpuFrequency,
    //'systemGUID': data.systemGUID,
  }

  _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return data.computerName;
    //'numberOfCores': data.numberOfCores,
    //'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
  }
}