# AdminApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**adminActivateUser**](#adminactivateuser) | **PATCH** /api/v1/admin/users/{userId}/activate | |
|[**adminGetGroup**](#admingetgroup) | **GET** /api/v1/admin/groups/{groupId} | |
|[**adminGetUser**](#admingetuser) | **GET** /api/v1/admin/users/{userId} | |
|[**adminListAuditLogs**](#adminlistauditlogs) | **GET** /api/v1/admin/audit-logs | |
|[**adminListGroupMembers**](#adminlistgroupmembers) | **GET** /api/v1/admin/groups/{groupId}/members | |
|[**adminListGroups**](#adminlistgroups) | **GET** /api/v1/admin/groups | |
|[**adminListJobRuns**](#adminlistjobruns) | **GET** /api/v1/admin/jobs/runs | |
|[**adminListUsers**](#adminlistusers) | **GET** /api/v1/admin/users | |
|[**adminOverview**](#adminoverview) | **GET** /api/v1/admin/overview | |
|[**adminRevokeUserDevice**](#adminrevokeuserdevice) | **DELETE** /api/v1/admin/users/{userId}/devices/{sessionId} | |
|[**adminRunCleanup**](#adminruncleanup) | **POST** /api/v1/admin/jobs/cleanup/run | |
|[**adminSetGroupPolicy**](#adminsetgrouppolicy) | **PATCH** /api/v1/admin/groups/{groupId}/policy | |
|[**adminSuspendUser**](#adminsuspenduser) | **PATCH** /api/v1/admin/users/{userId}/suspend | |

# **adminActivateUser**
> AdminUserResponse adminActivateUser()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let userId: string; // (default to undefined)

const { status, data } = await apiInstance.adminActivateUser(
    userId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **userId** | [**string**] |  | defaults to undefined|


### Return type

**AdminUserResponse**

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

# **adminGetGroup**
> AdminGroupResponse adminGetGroup()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let groupId: string; // (default to undefined)

const { status, data } = await apiInstance.adminGetGroup(
    groupId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**AdminGroupResponse**

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

# **adminGetUser**
> AdminUserResponse adminGetUser()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let userId: string; // (default to undefined)

const { status, data } = await apiInstance.adminGetUser(
    userId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **userId** | [**string**] |  | defaults to undefined|


### Return type

**AdminUserResponse**

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

# **adminListAuditLogs**
> AuditLogPageResponse adminListAuditLogs()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let limit: number; // (optional) (default to 50)
let cursor: string; // (optional) (default to undefined)
let action: string; // (optional) (default to undefined)
let targetType: string; // (optional) (default to undefined)
let actorUserId: string; // (optional) (default to undefined)
let targetId: string; // (optional) (default to undefined)
let from: string; // (optional) (default to undefined)
let to: string; // (optional) (default to undefined)

const { status, data } = await apiInstance.adminListAuditLogs(
    limit,
    cursor,
    action,
    targetType,
    actorUserId,
    targetId,
    from,
    to
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **limit** | [**number**] |  | (optional) defaults to 50|
| **cursor** | [**string**] |  | (optional) defaults to undefined|
| **action** | [**string**] |  | (optional) defaults to undefined|
| **targetType** | [**string**] |  | (optional) defaults to undefined|
| **actorUserId** | [**string**] |  | (optional) defaults to undefined|
| **targetId** | [**string**] |  | (optional) defaults to undefined|
| **from** | [**string**] |  | (optional) defaults to undefined|
| **to** | [**string**] |  | (optional) defaults to undefined|


### Return type

**AuditLogPageResponse**

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

# **adminListGroupMembers**
> AdminGroupMemberPageResponse adminListGroupMembers()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let groupId: string; // (default to undefined)
let limit: number; // (optional) (default to 30)
let cursor: string; // (optional) (default to undefined)
let search: string; // (optional) (default to undefined)

const { status, data } = await apiInstance.adminListGroupMembers(
    groupId,
    limit,
    cursor,
    search
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|
| **limit** | [**number**] |  | (optional) defaults to 30|
| **cursor** | [**string**] |  | (optional) defaults to undefined|
| **search** | [**string**] |  | (optional) defaults to undefined|


### Return type

**AdminGroupMemberPageResponse**

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

# **adminListGroups**
> AdminGroupPageResponse adminListGroups()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let limit: number; // (optional) (default to 30)
let status: 'ACTIVE' | 'SUSPENDED' | 'DISBANDED'; // (optional) (default to undefined)
let cursor: string; // (optional) (default to undefined)
let search: string; // (optional) (default to undefined)

const { status, data } = await apiInstance.adminListGroups(
    limit,
    status,
    cursor,
    search
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **limit** | [**number**] |  | (optional) defaults to 30|
| **status** | [**&#39;ACTIVE&#39; | &#39;SUSPENDED&#39; | &#39;DISBANDED&#39;**]**Array<&#39;ACTIVE&#39; &#124; &#39;SUSPENDED&#39; &#124; &#39;DISBANDED&#39;>** |  | (optional) defaults to undefined|
| **cursor** | [**string**] |  | (optional) defaults to undefined|
| **search** | [**string**] |  | (optional) defaults to undefined|


### Return type

**AdminGroupPageResponse**

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

# **adminListJobRuns**
> JobRunPageResponse adminListJobRuns()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let limit: number; // (optional) (default to 30)
let cursor: string; // (optional) (default to undefined)
let status: 'FAILED' | 'RUNNING' | 'SUCCESS' | 'SKIPPED'; // (optional) (default to undefined)

const { status, data } = await apiInstance.adminListJobRuns(
    limit,
    cursor,
    status
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **limit** | [**number**] |  | (optional) defaults to 30|
| **cursor** | [**string**] |  | (optional) defaults to undefined|
| **status** | [**&#39;FAILED&#39; | &#39;RUNNING&#39; | &#39;SUCCESS&#39; | &#39;SKIPPED&#39;**]**Array<&#39;FAILED&#39; &#124; &#39;RUNNING&#39; &#124; &#39;SUCCESS&#39; &#124; &#39;SKIPPED&#39;>** |  | (optional) defaults to undefined|


### Return type

**JobRunPageResponse**

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

# **adminListUsers**
> AdminUserPageResponse adminListUsers()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let limit: number; // (optional) (default to 30)
let status: 'DELETED' | 'ACTIVE' | 'SUSPENDED'; // (optional) (default to undefined)
let role: 'USER' | 'ADMIN'; // (optional) (default to undefined)
let cursor: string; // (optional) (default to undefined)
let search: string; // (optional) (default to undefined)

const { status, data } = await apiInstance.adminListUsers(
    limit,
    status,
    role,
    cursor,
    search
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **limit** | [**number**] |  | (optional) defaults to 30|
| **status** | [**&#39;DELETED&#39; | &#39;ACTIVE&#39; | &#39;SUSPENDED&#39;**]**Array<&#39;DELETED&#39; &#124; &#39;ACTIVE&#39; &#124; &#39;SUSPENDED&#39;>** |  | (optional) defaults to undefined|
| **role** | [**&#39;USER&#39; | &#39;ADMIN&#39;**]**Array<&#39;USER&#39; &#124; &#39;ADMIN&#39;>** |  | (optional) defaults to undefined|
| **cursor** | [**string**] |  | (optional) defaults to undefined|
| **search** | [**string**] |  | (optional) defaults to undefined|


### Return type

**AdminUserPageResponse**

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

# **adminOverview**
> AdminOverviewResponse adminOverview()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

const { status, data } = await apiInstance.adminOverview();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**AdminOverviewResponse**

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

# **adminRevokeUserDevice**
> SuccessResponse adminRevokeUserDevice()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let userId: string; // (default to undefined)
let sessionId: string; // (default to undefined)

const { status, data } = await apiInstance.adminRevokeUserDevice(
    userId,
    sessionId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **userId** | [**string**] |  | defaults to undefined|
| **sessionId** | [**string**] |  | defaults to undefined|


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

# **adminRunCleanup**
> JobRunResponse adminRunCleanup()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

const { status, data } = await apiInstance.adminRunCleanup();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**JobRunResponse**

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

# **adminSetGroupPolicy**
> AdminGroupResponse adminSetGroupPolicy(setGroupPolicyDto)


### Example

```typescript
import {
    AdminApi,
    Configuration,
    SetGroupPolicyDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let groupId: string; // (default to undefined)
let setGroupPolicyDto: SetGroupPolicyDto; //

const { status, data } = await apiInstance.adminSetGroupPolicy(
    groupId,
    setGroupPolicyDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **setGroupPolicyDto** | **SetGroupPolicyDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**AdminGroupResponse**

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

# **adminSuspendUser**
> AdminUserResponse adminSuspendUser()


### Example

```typescript
import {
    AdminApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new AdminApi(configuration);

let userId: string; // (default to undefined)

const { status, data } = await apiInstance.adminSuspendUser(
    userId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **userId** | [**string**] |  | defaults to undefined|


### Return type

**AdminUserResponse**

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

