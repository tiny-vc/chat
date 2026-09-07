# chat_api_client.api.LivekitWebhookApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**livekitWebhookReceive**](LivekitWebhookApi.md#livekitwebhookreceive) | **POST** /api/v1/webhooks/livekit | 


# **livekitWebhookReceive**
> BuiltMap<String, JsonObject> livekitWebhookReceive()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getLivekitWebhookApi();

try {
    final response = api.livekitWebhookReceive();
    print(response);
} on DioException catch (e) {
    print('Exception when calling LivekitWebhookApi->livekitWebhookReceive: $e\n');
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

