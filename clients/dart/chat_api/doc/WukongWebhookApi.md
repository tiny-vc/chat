# chat_api_client.api.WukongWebhookApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**wukongWebhookReceive**](WukongWebhookApi.md#wukongwebhookreceive) | **POST** /api/v1/webhooks/wukongim | 


# **wukongWebhookReceive**
> BuiltMap<String, JsonObject> wukongWebhookReceive(token)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getWukongWebhookApi();
final JsonObject token = ; // JsonObject | 

try {
    final response = api.wukongWebhookReceive(token);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WukongWebhookApi->wukongWebhookReceive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | [**JsonObject**](.md)|  | [optional] 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

