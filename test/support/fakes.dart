import 'dart:async';

import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/session_storage.dart';
import 'package:rumahkicau_mobile/features/auth/domain/entities/user.dart';
import 'package:rumahkicau_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/fake_home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_content.dart';
import 'package:rumahkicau_mobile/features/home/domain/repositories/home_repository.dart';

/// Akun demo yang sama dengan sumber data palsu aplikasi.
const String demoIdentifier = FakeAuthRemoteDataSource.demoIdentifier;
const String demoPassword = FakeAuthRemoteDataSource.demoPassword;
const String demoName = FakeAuthRemoteDataSource.demoName;

/// Data Beranda yang dipakai test widget dan bloc (sama dengan data demo).
const HomeContent sampleHomeContent = FakeHomeDataSource.content;

/// Repository auth palsu yang dapat dikonfigurasi per test.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.delay = Duration.zero,
    this.failuresRemaining = 0,
    this.logoutFailure = false,
  });

  final Duration delay;
  int failuresRemaining;
  bool logoutFailure;
  int loginCalls = 0;
  int registerCalls = 0;
  int logoutCalls = 0;

  @override
  Future<User> login({
    required String identifier,
    required String password,
  }) async {
    loginCalls++;
    await _simulate(AppConstants.loginFailure);
    return User(name: demoName, identifier: identifier);
  }

  @override
  Future<User> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    registerCalls++;
    await _simulate(AppConstants.registerFailure);
    return User(name: name, identifier: identifier);
  }

  /// Menunggu [delay] lalu gagal selama [failuresRemaining] masih ada.
  Future<void> _simulate(String failureMessage) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw AuthFailure(failureMessage);
    }
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    if (logoutFailure) {
      throw const DataFailure('Gagal keluar');
    }
  }
}

/// Repository Beranda palsu dengan kegagalan yang bisa diatur.
class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({
    this.content = sampleHomeContent,
    this.delay = Duration.zero,
    this.failuresRemaining = 0,
  });

  final HomeContent content;
  final Duration delay;
  int failuresRemaining;
  int fetchCalls = 0;

  @override
  Future<HomeContent> fetchHomeContent() async {
    fetchCalls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure('Gagal memuat beranda');
    }
    return content;
  }
}

/// Repository Beranda yang menunggu [Completer] untuk menguji state loading.
class CompleterHomeRepository implements HomeRepository {
  CompleterHomeRepository(this.completer);

  final Completer<HomeContent> completer;

  @override
  Future<HomeContent> fetchHomeContent() => completer.future;
}

/// Penyimpanan sesi di memori untuk keperluan test.
class InMemorySessionStorage implements SessionStorage {
  User? _user;

  @override
  Future<User?> readSession() async => _user;

  @override
  Future<void> saveSession(User user) async {
    _user = user;
  }

  @override
  Future<void> clearSession() async {
    _user = null;
  }
}
