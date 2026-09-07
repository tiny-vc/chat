# ServerInfoApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**serverInfoGetInfo**](#serverinfogetinfo) | **GET** /api/v1/server-info | |

# **serverInfoGetInfo**
> ServerInfoGetInfo200Response serverInfoGetInfo()


### Example

```typescript
import {
    ServerInfoApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new ServerInfoApi(configuration);

const { status, data } = await apiInstance.serverInfoGetInfo();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**ServerInfoGetInfo200Response**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** |  |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

