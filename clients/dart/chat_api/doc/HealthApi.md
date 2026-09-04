# chat_api_client.api.HealthApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthGetHealth**](HealthApi.md#healthgethealth) | **GET** /api/v1/health | 
[**healthGetReadiness**](HealthApi.md#healthgetreadiness) | **GET** /api/v1/ready | 


# **healthGetHealth**
> BuiltMap<String, JsonObject> healthGetHealth()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getHealthApi();

try {
    final response = api.healthGetHealth();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->healthGetHealth: $e\n');
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

# **healthGetReadiness**
> BuiltMap<String, JsonObject> healthGetReadiness()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getHealthApi();

try {
    final response = api.healthGetReadiness();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->healthGetReadiness: $e\n');
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

