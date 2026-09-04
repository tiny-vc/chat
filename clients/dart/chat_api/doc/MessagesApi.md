# chat_api_client.api.MessagesApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**messagesDescribe**](MessagesApi.md#messagesdescribe) | **GET** /api/v1/messages/protocol | 
[**messagesValidate**](MessagesApi.md#messagesvalidate) | **POST** /api/v1/messages/protocol/validate | 


# **messagesDescribe**
> BuiltMap<String, JsonObject> messagesDescribe()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getMessagesApi();

try {
    final response = api.messagesDescribe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagesApi->messagesDescribe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **messagesValidate**
> BuiltMap<String, JsonObject> messagesValidate()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getMessagesApi();

try {
    final response = api.messagesValidate();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagesApi->messagesValidate: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

