# chat_api_client.api.WukongWebhookApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**wukongWebhookReceive**](WukongWebhookApi.md#wukongwebhookreceive) | **POST** /api/v1/webhooks/wukongim | 
[**wukongWebhookReceiveWithPathToken**](WukongWebhookApi.md#wukongwebhookreceivewithpathtoken) | **POST** /api/v1/webhooks/wukongim/{token} | 


# **wukongWebhookReceive**
> wukongWebhookReceive(event, token)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getWukongWebhookApi();
final JsonObject event = ; // JsonObject | 
final JsonObject token = ; // JsonObject | 

try {
    api.wukongWebhookReceive(event, token);
} on DioException catch (e) {
    print('Exception when calling WukongWebhookApi->wukongWebhookReceive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **event** | [**JsonObject**](.md)|  | [optional] 
 **token** | [**JsonObject**](.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **wukongWebhookReceiveWithPathToken**
> wukongWebhookReceiveWithPathToken(token, event)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getWukongWebhookApi();
final String token = token_example; // String | 
final JsonObject event = ; // JsonObject | 

try {
    api.wukongWebhookReceiveWithPathToken(token, event);
} on DioException catch (e) {
    print('Exception when calling WukongWebhookApi->wukongWebhookReceiveWithPathToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | 
 **event** | [**JsonObject**](.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

