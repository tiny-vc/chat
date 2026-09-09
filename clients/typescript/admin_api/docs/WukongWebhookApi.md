# WukongWebhookApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**wukongWebhookReceive**](#wukongwebhookreceive) | **POST** /api/v1/webhooks/wukongim | |
|[**wukongWebhookReceiveWithPathToken**](#wukongwebhookreceivewithpathtoken) | **POST** /api/v1/webhooks/wukongim/{token} | |

# **wukongWebhookReceive**
> wukongWebhookReceive()


### Example

```typescript
import {
    WukongWebhookApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new WukongWebhookApi(configuration);

let event: any; // (optional) (default to undefined)
let token: any; // (optional) (default to undefined)

const { status, data } = await apiInstance.wukongWebhookReceive(
    event,
    token
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **event** | **any** |  | (optional) defaults to undefined|
| **token** | **any** |  | (optional) defaults to undefined|


### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** |  |  -  |
|**201** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **wukongWebhookReceiveWithPathToken**
> wukongWebhookReceiveWithPathToken()


### Example

```typescript
import {
    WukongWebhookApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new WukongWebhookApi(configuration);

let token: string; // (default to undefined)
let event: any; // (optional) (default to undefined)

const { status, data } = await apiInstance.wukongWebhookReceiveWithPathToken(
    token,
    event
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **token** | [**string**] |  | defaults to undefined|
| **event** | **any** |  | (optional) defaults to undefined|


### Return type

void (empty response body)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** |  |  -  |
|**201** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

