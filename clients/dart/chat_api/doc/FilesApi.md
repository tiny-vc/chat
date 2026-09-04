# chat_api_client.api.FilesApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**filesComplete**](FilesApi.md#filescomplete) | **POST** /api/v1/files/{fileId}/complete | 
[**filesCreateUpload**](FilesApi.md#filescreateupload) | **POST** /api/v1/files/uploads | 
[**filesDeleteFile**](FilesApi.md#filesdeletefile) | **DELETE** /api/v1/files/{fileId} | 
[**filesDownload**](FilesApi.md#filesdownload) | **GET** /api/v1/files/{fileId}/download | 
[**filesForward**](FilesApi.md#filesforward) | **POST** /api/v1/files/{fileId}/forward | 
[**filesSetThumbnail**](FilesApi.md#filessetthumbnail) | **POST** /api/v1/files/{fileId}/thumbnail | 
[**filesUsage**](FilesApi.md#filesusage) | **GET** /api/v1/files/usage | 


# **filesComplete**
> StoredFileResponse filesComplete(fileId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFilesApi();
final String fileId = fileId_example; // String | 

try {
    final response = api.filesComplete(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FilesApi->filesComplete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  | 

### Return type

[**StoredFileResponse**](StoredFileResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesCreateUpload**
> FileUploadResponse filesCreateUpload(createUploadDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFilesApi();
final CreateUploadDto createUploadDto = ; // CreateUploadDto | 

try {
    final response = api.filesCreateUpload(createUploadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FilesApi->filesCreateUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createUploadDto** | [**CreateUploadDto**](CreateUploadDto.md)|  | 

### Return type

[**FileUploadResponse**](FileUploadResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesDeleteFile**
> SuccessResponse filesDeleteFile(fileId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFilesApi();
final String fileId = fileId_example; // String | 

try {
    final response = api.filesDeleteFile(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FilesApi->filesDeleteFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesDownload**
> FileDownloadResponse filesDownload(fileId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFilesApi();
final String fileId = fileId_example; // String | 

try {
    final response = api.filesDownload(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FilesApi->filesDownload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  | 

### Return type

[**FileDownloadResponse**](FileDownloadResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesForward**
> BuiltMap<String, JsonObject> filesForward(fileId, forwardFileDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFilesApi();
final String fileId = fileId_example; // String | 
final ForwardFileDto forwardFileDto = ; // ForwardFileDto | 

try {
    final response = api.filesForward(fileId, forwardFileDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FilesApi->filesForward: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  | 
 **forwardFileDto** | [**ForwardFileDto**](ForwardFileDto.md)|  | 

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesSetThumbnail**
> StoredFileResponse filesSetThumbnail(fileId, setThumbnailDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFilesApi();
final String fileId = fileId_example; // String | 
final SetThumbnailDto setThumbnailDto = ; // SetThumbnailDto | 

try {
    final response = api.filesSetThumbnail(fileId, setThumbnailDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FilesApi->filesSetThumbnail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  | 
 **setThumbnailDto** | [**SetThumbnailDto**](SetThumbnailDto.md)|  | 

### Return type

[**StoredFileResponse**](StoredFileResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesUsage**
> FileUsageResponse filesUsage()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getFilesApi();

try {
    final response = api.filesUsage();
    print(response);
} on DioException catch (e) {
    print('Exception when calling FilesApi->filesUsage: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FileUsageResponse**](FileUsageResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

