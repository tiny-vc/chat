# chat_api_client.api.ServerInfoApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**serverInfoGetInfo**](ServerInfoApi.md#serverinfogetinfo) | **GET** /api/v1/server-info | 


# **serverInfoGetInfo**
> ServerInfoGetInfo200Response serverInfoGetInfo()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getServerInfoApi();

try {
    final response = api.serverInfoGetInfo();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ServerInfoApi->serverInfoGetInfo: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ServerInfoGetInfo200Response**](ServerInfoGetInfo200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

