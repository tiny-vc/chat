# chat_api_client.api.ImSyncApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**imSyncMarkRead**](ImSyncApi.md#imsyncmarkread) | **POST** /api/v1/im/conversations/read | 
[**imSyncReceipts**](ImSyncApi.md#imsyncreceipts) | **POST** /api/v1/im/messages/receipts | 
[**imSyncRevokeMessage**](ImSyncApi.md#imsyncrevokemessage) | **POST** /api/v1/im/messages/revoke | 
[**imSyncSyncConversations**](ImSyncApi.md#imsyncsyncconversations) | **POST** /api/v1/im/conversations/sync | 
[**imSyncSyncMessages**](ImSyncApi.md#imsyncsyncmessages) | **POST** /api/v1/im/messages/sync | 


# **imSyncMarkRead**
> BuiltMap<String, JsonObject> imSyncMarkRead(markImReadDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getImSyncApi();
final MarkImReadDto markImReadDto = ; // MarkImReadDto | 

try {
    final response = api.imSyncMarkRead(markImReadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ImSyncApi->imSyncMarkRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **markImReadDto** | [**MarkImReadDto**](MarkImReadDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **imSyncReceipts**
> BuiltMap<String, JsonObject> imSyncReceipts(syncImReceiptsDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getImSyncApi();
final SyncImReceiptsDto syncImReceiptsDto = ; // SyncImReceiptsDto | 

try {
    final response = api.imSyncReceipts(syncImReceiptsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ImSyncApi->imSyncReceipts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **syncImReceiptsDto** | [**SyncImReceiptsDto**](SyncImReceiptsDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **imSyncRevokeMessage**
> BuiltMap<String, JsonObject> imSyncRevokeMessage(revokeImMessageDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getImSyncApi();
final RevokeImMessageDto revokeImMessageDto = ; // RevokeImMessageDto | 

try {
    final response = api.imSyncRevokeMessage(revokeImMessageDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ImSyncApi->imSyncRevokeMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **revokeImMessageDto** | [**RevokeImMessageDto**](RevokeImMessageDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **imSyncSyncConversations**
> BuiltMap<String, JsonObject> imSyncSyncConversations(syncImConversationsDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getImSyncApi();
final SyncImConversationsDto syncImConversationsDto = ; // SyncImConversationsDto | 

try {
    final response = api.imSyncSyncConversations(syncImConversationsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ImSyncApi->imSyncSyncConversations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **syncImConversationsDto** | [**SyncImConversationsDto**](SyncImConversationsDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **imSyncSyncMessages**
> BuiltMap<String, JsonObject> imSyncSyncMessages(syncImChannelMessagesDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getImSyncApi();
final SyncImChannelMessagesDto syncImChannelMessagesDto = ; // SyncImChannelMessagesDto | 

try {
    final response = api.imSyncSyncMessages(syncImChannelMessagesDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ImSyncApi->imSyncSyncMessages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **syncImChannelMessagesDto** | [**SyncImChannelMessagesDto**](SyncImChannelMessagesDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

