import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/core/errors/failure.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/user.pbgrpc.dart';
import 'package:yetbota_mobile/core/grpc/grpc_invoker.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';

class GrpcProfileRemoteDataSource implements ProfileRemoteDataSource {
  GrpcProfileRemoteDataSource({
    required UserServiceClient userClient,
    required GrpcInvoker invoker,
  })  : _userClient = userClient,
        _invoker = invoker;

  final UserServiceClient _userClient;
  final GrpcInvoker _invoker;

  static const _successCode = '00';

  @override
  Future<Result<UserProfile>> readSelf() async {
    try {
      final resp = await _invoker.run(
        () => _userClient.read(
          ReadRequest(resolution: PhotoResolution.PHOTO_RESOLUTION_MOBILE),
        ),
      );
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      final data = resp.data;
      final user = data.user;
      final profileUrl = data.hasProfileUrl()
          ? data.profileUrl
          : (user.hasProfileUrl() ? user.profileUrl : '');
      return Ok(
        UserProfile(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          username: user.username,
          mobile: user.mobile,
          rating: user.rating,
          contributions: user.contributions,
          followers: user.followers,
          following: user.following,
          status: user.status,
          role: user.role.name,
          profileUrl: profileUrl,
          createdAt: user.hasCreatedAt() ? user.createdAt.toDateTime() : null,
          updatedAt: user.hasUpdatedAt() ? user.updatedAt.toDateTime() : null,
        ),
      );
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Failed to load profile: $e'));
    }
  }

  Failure _envelopeFailure(String code, String message) {
    final msg = message.isEmpty ? 'Request failed (code $code)' : message;
    return ServerFailure(msg, code: code);
  }

  Failure _grpcToFailure(GrpcError e) {
    final msg = (e.message == null || e.message!.isEmpty)
        ? 'Request failed (${e.codeName})'
        : e.message!;
    switch (e.code) {
      case StatusCode.unauthenticated:
      case StatusCode.permissionDenied:
        return AuthFailure(msg);
      case StatusCode.invalidArgument:
      case StatusCode.failedPrecondition:
      case StatusCode.outOfRange:
        return ValidationFailure(msg);
      case StatusCode.unavailable:
      case StatusCode.deadlineExceeded:
        return NetworkFailure(msg);
      default:
        return ServerFailure(msg, code: e.codeName);
    }
  }
}
