# chat_api_client.api.ConversationsApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**conversationsList**](ConversationsApi.md#conversationslist) | **GET** /api/v1/conversations/settings | 
[**conversationsRemove**](ConversationsApi.md#conversationsremove) | **DELETE** /api/v1/conversations/settings/{channelType}/{channelId} | 
[**conversationsUpdate**](ConversationsApi.md#conversationsupdate) | **PATCH** /api/v1/conversations/settings | 


# **conversationsList**
> BuiltList<ConversationSettingResponse> conversationsList()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getConversationsApi();

try {
    final response = api.conversationsList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConversationsApi->conversationsList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ConversationSettingResponse&gt;**](ConversationSettingResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **conversationsRemove**
> SuccessResponse conversationsRemove(channelType, channelId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getConversationsApi();
final num channelType = 8.14; // num | 
final String channelId = channelId_example; // String | 

try {
    final response = api.conversationsRemove(channelType, channelId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConversationsApi->conversationsRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **channelType** | **num**|  | 
 **channelId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **conversationsUpdate**
> ConversationSettingResponse conversationsUpdate(updateConversationSettingDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getConversationsApi();
final UpdateConversationSettingDto updateConversationSettingDto = ; // UpdateConversationSettingDto | 

try {
    final response = api.conversationsUpdate(updateConversationSettingDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConversationsApi->conversationsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateConversationSettingDto** | [**UpdateConversationSettingDto**](UpdateConversationSettingDto.md)|  | 

### Return type

[**ConversationSettingResponse**](ConversationSettingResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

