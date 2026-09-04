# FilesApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**filesComplete**](#filescomplete) | **POST** /api/v1/files/{fileId}/complete | |
|[**filesCreateUpload**](#filescreateupload) | **POST** /api/v1/files/uploads | |
|[**filesDeleteFile**](#filesdeletefile) | **DELETE** /api/v1/files/{fileId} | |
|[**filesDownload**](#filesdownload) | **GET** /api/v1/files/{fileId}/download | |
|[**filesForward**](#filesforward) | **POST** /api/v1/files/{fileId}/forward | |
|[**filesSetThumbnail**](#filessetthumbnail) | **POST** /api/v1/files/{fileId}/thumbnail | |
|[**filesUsage**](#filesusage) | **GET** /api/v1/files/usage | |

# **filesComplete**
> StoredFileResponse filesComplete()


### Example

```typescript
import {
    FilesApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FilesApi(configuration);

let fileId: string; // (default to undefined)

const { status, data } = await apiInstance.filesComplete(
    fileId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **fileId** | [**string**] |  | defaults to undefined|


### Return type

**StoredFileResponse**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**201** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesCreateUpload**
> FileUploadResponse filesCreateUpload(createUploadDto)


### Example

```typescript
import {
    FilesApi,
    Configuration,
    CreateUploadDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FilesApi(configuration);

let createUploadDto: CreateUploadDto; //

const { status, data } = await apiInstance.filesCreateUpload(
    createUploadDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **createUploadDto** | **CreateUploadDto**|  | |


### Return type

**FileUploadResponse**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**201** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesDeleteFile**
> SuccessResponse filesDeleteFile()


### Example

```typescript
import {
    FilesApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FilesApi(configuration);

let fileId: string; // (default to undefined)

const { status, data } = await apiInstance.filesDeleteFile(
    fileId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **fileId** | [**string**] |  | defaults to undefined|


### Return type

**SuccessResponse**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesDownload**
> FileDownloadResponse filesDownload()


### Example

```typescript
import {
    FilesApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FilesApi(configuration);

let fileId: string; // (default to undefined)

const { status, data } = await apiInstance.filesDownload(
    fileId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **fileId** | [**string**] |  | defaults to undefined|


### Return type

**FileDownloadResponse**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesForward**
> { [key: string]: any; } filesForward(forwardFileDto)


### Example

```typescript
import {
    FilesApi,
    Configuration,
    ForwardFileDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FilesApi(configuration);

let fileId: string; // (default to undefined)
let forwardFileDto: ForwardFileDto; //

const { status, data } = await apiInstance.filesForward(
    fileId,
    forwardFileDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **forwardFileDto** | **ForwardFileDto**|  | |
| **fileId** | [**string**] |  | defaults to undefined|


### Return type

**{ [key: string]: any; }**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**201** |  |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesSetThumbnail**
> StoredFileResponse filesSetThumbnail(setThumbnailDto)


### Example

```typescript
import {
    FilesApi,
    Configuration,
    SetThumbnailDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FilesApi(configuration);

let fileId: string; // (default to undefined)
let setThumbnailDto: SetThumbnailDto; //

const { status, data } = await apiInstance.filesSetThumbnail(
    fileId,
    setThumbnailDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **setThumbnailDto** | **SetThumbnailDto**|  | |
| **fileId** | [**string**] |  | defaults to undefined|


### Return type

**StoredFileResponse**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**201** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **filesUsage**
> FileUsageResponse filesUsage()


### Example

```typescript
import {
    FilesApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FilesApi(configuration);

const { status, data } = await apiInstance.filesUsage();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**FileUsageResponse**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

