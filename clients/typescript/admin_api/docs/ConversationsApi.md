# ConversationsApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**conversationsList**](#conversationslist) | **GET** /api/v1/conversations/settings | |
|[**conversationsRemove**](#conversationsremove) | **DELETE** /api/v1/conversations/settings/{channelType}/{channelId} | |
|[**conversationsUpdate**](#conversationsupdate) | **PATCH** /api/v1/conversations/settings | |

# **conversationsList**
> Array<ConversationSettingResponse> conversationsList()


### Example

```typescript
import {
    ConversationsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ConversationsApi(configuration);

const { status, data } = await apiInstance.conversationsList();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**Array<ConversationSettingResponse>**

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

# **conversationsRemove**
> SuccessResponse conversationsRemove()


### Example

```typescript
import {
    ConversationsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ConversationsApi(configuration);

let channelType: number; // (default to undefined)
let channelId: string; // (default to undefined)

const { status, data } = await apiInstance.conversationsRemove(
    channelType,
    channelId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **channelType** | [**number**] |  | defaults to undefined|
| **channelId** | [**string**] |  | defaults to undefined|


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

# **conversationsUpdate**
> ConversationSettingResponse conversationsUpdate(updateConversationSettingDto)


### Example

```typescript
import {
    ConversationsApi,
    Configuration,
    UpdateConversationSettingDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ConversationsApi(configuration);

let updateConversationSettingDto: UpdateConversationSettingDto; //

const { status, data } = await apiInstance.conversationsUpdate(
    updateConversationSettingDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **updateConversationSettingDto** | **UpdateConversationSettingDto**|  | |


### Return type

**ConversationSettingResponse**

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
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

