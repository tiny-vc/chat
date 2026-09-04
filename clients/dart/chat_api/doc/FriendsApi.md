# chat_api_client.api.FriendsApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**friendsAccept**](FriendsApi.md#friendsaccept) | **POST** /api/v1/friends/requests/{requestId}/accept | 
[**friendsList**](FriendsApi.md#friendslist) | **GET** /api/v1/friends | 
[**friendsListRequests**](FriendsApi.md#friendslistrequests) | **GET** /api/v1/friends/requests | 
[**friendsReject**](FriendsApi.md#friendsreject) | **POST** /api/v1/friends/requests/{requestId}/reject | 
[**friendsRemove**](FriendsApi.md#friendsremove) | **DELETE** /api/v1/friends/{userId} | 
[**friendsRequest**](FriendsApi.md#friendsrequest) | **POST** /api/v1/friends/requests | 


# **friendsAccept**
> FriendshipResponse friendsAccept(requestId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFriendsApi();
final String requestId = requestId_example; // String | 

try {
    final response = api.friendsAccept(requestId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FriendsApi->friendsAccept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **String**|  | 

### Return type

[**FriendshipResponse**](FriendshipResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **friendsList**
> BuiltList<FriendResponse> friendsList()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFriendsApi();

try {
    final response = api.friendsList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling FriendsApi->friendsList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;FriendResponse&gt;**](FriendResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **friendsListRequests**
> BuiltList<FriendshipResponse> friendsListRequests()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFriendsApi();

try {
    final response = api.friendsListRequests();
    print(response);
} on DioException catch (e) {
    print('Exception when calling FriendsApi->friendsListRequests: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;FriendshipResponse&gt;**](FriendshipResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **friendsReject**
> FriendshipResponse friendsReject(requestId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFriendsApi();
final String requestId = requestId_example; // String | 

try {
    final response = api.friendsReject(requestId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FriendsApi->friendsReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **String**|  | 

### Return type

[**FriendshipResponse**](FriendshipResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **friendsRemove**
> SuccessResponse friendsRemove(userId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFriendsApi();
final String userId = userId_example; // String | 

try {
    final response = api.friendsRemove(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FriendsApi->friendsRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **friendsRequest**
> FriendshipResponse friendsRequest(createFriendRequestDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFriendsApi();
final CreateFriendRequestDto createFriendRequestDto = ; // CreateFriendRequestDto | 

try {
    final response = api.friendsRequest(createFriendRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FriendsApi->friendsRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createFriendRequestDto** | [**CreateFriendRequestDto**](CreateFriendRequestDto.md)|  | 

### Return type

[**FriendshipResponse**](FriendshipResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

