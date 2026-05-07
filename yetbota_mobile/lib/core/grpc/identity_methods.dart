/// gRPC method paths on the identity-service that DO NOT require an authorization token
const Set<String> kIdentityPublicMethods = {
  '/identity.v1.AuthService/Login',
  '/identity.v1.AuthService/Refresh',
  '/identity.v1.AuthService/GenerateMobileOTP',
  '/identity.v1.AuthService/ValidateOTP',
  '/identity.v1.AuthService/NewPassword',
  '/identity.v1.UserService/Register',
  '/identity.v1.UserService/CheckMobile',
  '/identity.v1.UserService/ReadPublic',
};
