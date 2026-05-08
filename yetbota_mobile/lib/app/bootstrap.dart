import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yetbota_mobile/app/app.dart';
import 'package:yetbota_mobile/app/config/app_config.dart';
import 'package:yetbota_mobile/app/theme/theme_cubit.dart';
import 'package:yetbota_mobile/core/auth/token_store.dart';
import 'package:yetbota_mobile/core/grpc/grpc_client_factory.dart';
import 'package:yetbota_mobile/core/grpc/grpc_invoker.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source_grpc.dart';
import 'package:yetbota_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/check_mobile.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/generate_mobile_otp.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/get_session.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/register.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/sign_in.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/sign_out.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/validate_mobile_otp.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/register_bloc.dart';
import 'package:yetbota_mobile/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:yetbota_mobile/features/profile/data/datasources/profile_remote_data_source_grpc.dart';
import 'package:yetbota_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:yetbota_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:yetbota_mobile/features/profile/domain/usecases/read_self_profile.dart';
import 'package:yetbota_mobile/features/profile/presentation/cubit/profile_cubit.dart';

Future<Widget> bootstrap({AppConfig? config}) async {
  final appConfig = config ?? AppConfig.dev();

  final tokenStore = TokenStore(storage: const FlutterSecureStorage());
  await tokenStore.hydrate();

  final grpcFactory = GrpcClientFactory(
    config: appConfig,
    tokenStore: tokenStore,
  );

  final AuthRemoteDataSource remote = GrpcAuthRemoteDataSource(
    authClient: grpcFactory.authClient,
    userClient: grpcFactory.userClient,
  );

  final AuthRepository authRepository = AuthRepositoryImpl(
    tokenStore: tokenStore,
    remote: remote,
  );

  final getSession = GetSession(authRepository);
  final signIn = SignIn(authRepository);
  final signOut = SignOut(authRepository);
  final generateOtp = GenerateMobileOtp(authRepository);
  final validateOtp = ValidateMobileOtp(authRepository);
  final register = Register(authRepository);
  final checkMobile = CheckMobile(authRepository);
  final resetPassword = ResetPassword(authRepository);

  final ProfileRemoteDataSource profileRemote = GrpcProfileRemoteDataSource(
    userClient: grpcFactory.userClient,
    invoker: GrpcInvoker(tokenStore),
  );
  final ProfileRepository profileRepository = ProfileRepositoryImpl(
    remote: profileRemote,
  );
  final readSelfProfile = ReadSelfProfile(profileRepository);

  final prefs = await SharedPreferences.getInstance();
  final themeCubit = ThemeCubit(prefs);

  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: authRepository),
      RepositoryProvider<ProfileRepository>.value(value: profileRepository),
      RepositoryProvider<TokenStore>.value(value: tokenStore),
      RepositoryProvider<GrpcClientFactory>.value(value: grpcFactory),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(
          create: (_) => AuthBloc(
            getSession: getSession,
            signIn: signIn,
            signOut: signOut,
            tokenStore: tokenStore,
          ),
        ),
        BlocProvider(
          create: (_) => RegisterBloc(
            checkMobile: checkMobile,
            generateOtp: generateOtp,
            validateOtp: validateOtp,
            register: register,
          ),
        ),
        BlocProvider(
          create: (_) => ForgotPasswordBloc(
            checkMobile: checkMobile,
            generateOtp: generateOtp,
            validateOtp: validateOtp,
            resetPassword: resetPassword,
          ),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(
            readSelfProfile: readSelfProfile,
            tokenStore: tokenStore,
          ),
        ),
      ],
      child: const YetBotaApp(),
    ),
  );
}
