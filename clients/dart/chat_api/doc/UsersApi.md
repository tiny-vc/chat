# chat_api_client.api.UsersApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersGetById**](UsersApi.md#usersgetbyid) | **GET** /api/v1/users/{userId} | 
[**usersGetMe**](UsersApi.md#usersgetme) | **GET** /api/v1/users/me | 
[**usersRemoveAvatar**](UsersApi.md#usersremoveavatar) | **DELETE** /api/v1/users/me/avatar | 
[**usersReport**](UsersApi.md#usersreport) | **POST** /api/v1/users/{userId}/report | 
[**usersSearch**](UsersApi.md#userssearch) | **GET** /api/v1/users/search | 
[**usersSetAvatar**](UsersApi.md#userssetavatar) | **PUT** /api/v1/users/me/avatar | 
[**usersUpdateMe**](UsersApi.md#usersupdateme) | **PATCH** /api/v1/users/me | 


# **usersGetById**
> UserResponse usersGetById(userId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getUsersApi();
final String userId = userId_example; // String | 

try {
    final response = api.usersGetById(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersGetById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersGetMe**
> UserResponse usersGetMe()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getUsersApi();

try {
    final response = api.usersGetMe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersGetMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersRemoveAvatar**
> UserResponse usersRemoveAvatar()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getUsersApi();

try {
    final response = api.usersRemoveAvatar();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersRemoveAvatar: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersReport**
> BuiltMap<String, JsonObject> usersReport(userId, reportUserDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getUsersApi();
final String userId = userId_example; // String | 
final ReportUserDto reportUserDto = ; // ReportUserDto | 

try {
    final response = api.usersReport(userId, reportUserDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **reportUserDto** | [**ReportUserDto**](ReportUserDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersSearch**
> BuiltList<UserResponse> usersSearch(q)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getUsersApi();
final JsonObject q = ; // JsonObject | 

try {
    final response = api.usersSearch(q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersSearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | [**JsonObject**](.md)|  | [optional] 

### Return type

[**BuiltList&lt;UserResponse&gt;**](UserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersSetAvatar**
> UserResponse usersSetAvatar(setAvatarDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getUsersApi();
final SetAvatarDto setAvatarDto = ; // SetAvatarDto | 

try {
    final response = api.usersSetAvatar(setAvatarDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersSetAvatar: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setAvatarDto** | [**SetAvatarDto**](SetAvatarDto.md)|  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersUpdateMe**
> UserResponse usersUpdateMe(updateProfileDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getUsersApi();
final UpdateProfileDto updateProfileDto = ; // UpdateProfileDto | 

try {
    final response = api.usersUpdateMe(updateProfileDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersUpdateMe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateProfileDto** | [**UpdateProfileDto**](UpdateProfileDto.md)|  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

