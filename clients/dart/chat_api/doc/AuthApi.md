# chat_api_client.api.AuthApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authChangePassword**](AuthApi.md#authchangepassword) | **POST** /api/v1/auth/change-password | 
[**authDeactivateAccount**](AuthApi.md#authdeactivateaccount) | **DELETE** /api/v1/auth/account | 
[**authDevices**](AuthApi.md#authdevices) | **GET** /api/v1/auth/devices | 
[**authLogin**](AuthApi.md#authlogin) | **POST** /api/v1/auth/login | 
[**authLogout**](AuthApi.md#authlogout) | **POST** /api/v1/auth/logout | 
[**authLogoutAll**](AuthApi.md#authlogoutall) | **POST** /api/v1/auth/logout-all | 
[**authRefresh**](AuthApi.md#authrefresh) | **POST** /api/v1/auth/refresh | 
[**authRegister**](AuthApi.md#authregister) | **POST** /api/v1/auth/register | 
[**authRevokeDevice**](AuthApi.md#authrevokedevice) | **DELETE** /api/v1/auth/devices/{sessionId} | 


# **authChangePassword**
> SuccessResponse authChangePassword(changePasswordDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();
final ChangePasswordDto changePasswordDto = ; // ChangePasswordDto | 

try {
    final response = api.authChangePassword(changePasswordDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authChangePassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **changePasswordDto** | [**ChangePasswordDto**](ChangePasswordDto.md)|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authDeactivateAccount**
> BuiltMap<String, JsonObject> authDeactivateAccount(deactivateAccountDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();
final DeactivateAccountDto deactivateAccountDto = ; // DeactivateAccountDto | 

try {
    final response = api.authDeactivateAccount(deactivateAccountDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authDeactivateAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deactivateAccountDto** | [**DeactivateAccountDto**](DeactivateAccountDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authDevices**
> BuiltList<DeviceSessionResponse> authDevices()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();

try {
    final response = api.authDevices();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authDevices: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;DeviceSessionResponse&gt;**](DeviceSessionResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLogin**
> AuthSessionResponse authLogin(loginDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();
final LoginDto loginDto = ; // LoginDto | 

try {
    final response = api.authLogin(loginDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginDto** | [**LoginDto**](LoginDto.md)|  | 

### Return type

[**AuthSessionResponse**](AuthSessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLogout**
> SuccessResponse authLogout()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();

try {
    final response = api.authLogout();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authLogout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLogoutAll**
> SuccessResponse authLogoutAll()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();

try {
    final response = api.authLogoutAll();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authLogoutAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authRefresh**
> AuthSessionResponse authRefresh(refreshTokenDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();
final RefreshTokenDto refreshTokenDto = ; // RefreshTokenDto | 

try {
    final response = api.authRefresh(refreshTokenDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenDto** | [**RefreshTokenDto**](RefreshTokenDto.md)|  | 

### Return type

[**AuthSessionResponse**](AuthSessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authRegister**
> AuthSessionResponse authRegister(registerDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();
final RegisterDto registerDto = ; // RegisterDto | 

try {
    final response = api.authRegister(registerDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDto** | [**RegisterDto**](RegisterDto.md)|  | 

### Return type

[**AuthSessionResponse**](AuthSessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authRevokeDevice**
> SuccessResponse authRevokeDevice(sessionId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAuthApi();
final String sessionId = sessionId_example; // String | 

try {
    final response = api.authRevokeDevice(sessionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authRevokeDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sessionId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

