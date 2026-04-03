import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yetbota_mobile/app/app.dart';
import 'package:yetbota_mobile/app/config/app_config.dart';
import 'package:yetbota_mobile/app/theme/theme_cubit.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source_fake.dart';
import 'package:yetbota_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/get_session.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/sign_in.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/sign_out.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';

Future<Widget> bootstrap({AppConfig config = AppConfig.dev}) async {
  final secureStorage = const FlutterSecureStorage();
  final local = AuthLocalDataSource(secureStorage);

  AuthRemoteDataSource remote = FakeAuthRemoteDataSource();
  config;

  final prefs = await SharedPreferences.getInstance();
  final themeCubit = ThemeCubit(prefs);

  final AuthRepository authRepository = AuthRepositoryImpl(local, remote);

  final getSession = GetSession(authRepository);
  final signIn = SignIn(authRepository);
  final signOut = SignOut(authRepository);

  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: authRepository),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(
          create: (_) => AuthBloc(
            getSession: getSession,
            signIn: signIn,
            signOut: signOut,
          ),
        ),
      ],
      child: const YetBotaApp(),
    ),
  );
}

