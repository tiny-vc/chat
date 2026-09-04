# ImSyncApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**imSyncMarkRead**](#imsyncmarkread) | **POST** /api/v1/im/conversations/read | |
|[**imSyncReceipts**](#imsyncreceipts) | **POST** /api/v1/im/messages/receipts | |
|[**imSyncRevokeMessage**](#imsyncrevokemessage) | **POST** /api/v1/im/messages/revoke | |
|[**imSyncSyncConversations**](#imsyncsyncconversations) | **POST** /api/v1/im/conversations/sync | |
|[**imSyncSyncMessages**](#imsyncsyncmessages) | **POST** /api/v1/im/messages/sync | |

# **imSyncMarkRead**
> { [key: string]: any; } imSyncMarkRead(markImReadDto)


### Example

```typescript
import {
    ImSyncApi,
    Configuration,
    MarkImReadDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ImSyncApi(configuration);

let markImReadDto: MarkImReadDto; //

const { status, data } = await apiInstance.imSyncMarkRead(
    markImReadDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **markImReadDto** | **MarkImReadDto**|  | |


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

# **imSyncReceipts**
> { [key: string]: any; } imSyncReceipts(syncImReceiptsDto)


### Example

```typescript
import {
    ImSyncApi,
    Configuration,
    SyncImReceiptsDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ImSyncApi(configuration);

let syncImReceiptsDto: SyncImReceiptsDto; //

const { status, data } = await apiInstance.imSyncReceipts(
    syncImReceiptsDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **syncImReceiptsDto** | **SyncImReceiptsDto**|  | |


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

# **imSyncRevokeMessage**
> { [key: string]: any; } imSyncRevokeMessage(revokeImMessageDto)


### Example

```typescript
import {
    ImSyncApi,
    Configuration,
    RevokeImMessageDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ImSyncApi(configuration);

let revokeImMessageDto: RevokeImMessageDto; //

const { status, data } = await apiInstance.imSyncRevokeMessage(
    revokeImMessageDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **revokeImMessageDto** | **RevokeImMessageDto**|  | |


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

# **imSyncSyncConversations**
> { [key: string]: any; } imSyncSyncConversations(syncImConversationsDto)


### Example

```typescript
import {
    ImSyncApi,
    Configuration,
    SyncImConversationsDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ImSyncApi(configuration);

let syncImConversationsDto: SyncImConversationsDto; //

const { status, data } = await apiInstance.imSyncSyncConversations(
    syncImConversationsDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **syncImConversationsDto** | **SyncImConversationsDto**|  | |


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

# **imSyncSyncMessages**
> { [key: string]: any; } imSyncSyncMessages(syncImChannelMessagesDto)


### Example

```typescript
import {
    ImSyncApi,
    Configuration,
    SyncImChannelMessagesDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ImSyncApi(configuration);

let syncImChannelMessagesDto: SyncImChannelMessagesDto; //

const { status, data } = await apiInstance.imSyncSyncMessages(
    syncImChannelMessagesDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **syncImChannelMessagesDto** | **SyncImChannelMessagesDto**|  | |


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

