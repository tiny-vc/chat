# chat_api_client.api.CallsApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**callsAccept**](CallsApi.md#callsaccept) | **POST** /api/v1/calls/{callId}/accept | 
[**callsBusy**](CallsApi.md#callsbusy) | **POST** /api/v1/calls/{callId}/busy | 
[**callsCancel**](CallsApi.md#callscancel) | **POST** /api/v1/calls/{callId}/cancel | 
[**callsCreate**](CallsApi.md#callscreate) | **POST** /api/v1/calls | 
[**callsCreateToken**](CallsApi.md#callscreatetoken) | **POST** /api/v1/calls/{callId}/token | 
[**callsEnd**](CallsApi.md#callsend) | **POST** /api/v1/calls/{callId}/end | 
[**callsList**](CallsApi.md#callslist) | **GET** /api/v1/calls | 
[**callsMiss**](CallsApi.md#callsmiss) | **POST** /api/v1/calls/{callId}/miss | 
[**callsReject**](CallsApi.md#callsreject) | **POST** /api/v1/calls/{callId}/reject | 


# **callsAccept**
> CallSessionResponse callsAccept(callId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final String callId = callId_example; // String | 

try {
    final response = api.callsAccept(callId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsAccept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **callId** | **String**|  | 

### Return type

[**CallSessionResponse**](CallSessionResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsBusy**
> BuiltMap<String, JsonObject> callsBusy(callId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final String callId = callId_example; // String | 

try {
    final response = api.callsBusy(callId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsBusy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **callId** | **String**|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsCancel**
> CallSessionResponse callsCancel(callId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final String callId = callId_example; // String | 

try {
    final response = api.callsCancel(callId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **callId** | **String**|  | 

### Return type

[**CallSessionResponse**](CallSessionResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsCreate**
> CallSessionResponse callsCreate(createCallDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final CreateCallDto createCallDto = ; // CreateCallDto | 

try {
    final response = api.callsCreate(createCallDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createCallDto** | [**CreateCallDto**](CreateCallDto.md)|  | 

### Return type

[**CallSessionResponse**](CallSessionResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsCreateToken**
> LiveKitTokenResponse callsCreateToken(callId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final String callId = callId_example; // String | 

try {
    final response = api.callsCreateToken(callId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsCreateToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **callId** | **String**|  | 

### Return type

[**LiveKitTokenResponse**](LiveKitTokenResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsEnd**
> CallSessionResponse callsEnd(callId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final String callId = callId_example; // String | 

try {
    final response = api.callsEnd(callId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsEnd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **callId** | **String**|  | 

### Return type

[**CallSessionResponse**](CallSessionResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsList**
> BuiltMap<String, JsonObject> callsList()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();

try {
    final response = api.callsList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsList: $e\n');
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

# **callsMiss**
> BuiltMap<String, JsonObject> callsMiss(callId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final String callId = callId_example; // String | 

try {
    final response = api.callsMiss(callId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsMiss: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **callId** | **String**|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsReject**
> CallSessionResponse callsReject(callId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getCallsApi();
final String callId = callId_example; // String | 

try {
    final response = api.callsReject(callId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CallsApi->callsReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **callId** | **String**|  | 

### Return type

[**CallSessionResponse**](CallSessionResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

