# LivekitWebhookApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**livekitWebhookReceive**](#livekitwebhookreceive) | **POST** /api/v1/webhooks/livekit | |

# **livekitWebhookReceive**
> { [key: string]: any; } livekitWebhookReceive()


### Example

```typescript
import {
    LivekitWebhookApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new LivekitWebhookApi(configuration);

const { status, data } = await apiInstance.livekitWebhookReceive();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**{ [key: string]: any; }**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
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

