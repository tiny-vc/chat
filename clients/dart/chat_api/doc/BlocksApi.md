# chat_api_client.api.BlocksApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**blocksBlock**](BlocksApi.md#blocksblock) | **POST** /api/v1/blocks/{userId} | 
[**blocksList**](BlocksApi.md#blockslist) | **GET** /api/v1/blocks | 
[**blocksUnblock**](BlocksApi.md#blocksunblock) | **DELETE** /api/v1/blocks/{userId} | 


# **blocksBlock**
> JsonObject blocksBlock(userId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getBlocksApi();
final String userId = userId_example; // String | 

try {
    final response = api.blocksBlock(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BlocksApi->blocksBlock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **blocksList**
> BuiltMap<String, JsonObject> blocksList()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getBlocksApi();

try {
    final response = api.blocksList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BlocksApi->blocksList: $e\n');
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

# **blocksUnblock**
> SuccessResponse blocksUnblock(userId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getBlocksApi();
final String userId = userId_example; // String | 

try {
    final response = api.blocksUnblock(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BlocksApi->blocksUnblock: $e\n');
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

