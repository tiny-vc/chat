# UsersApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**usersGetById**](#usersgetbyid) | **GET** /api/v1/users/{userId} | |
|[**usersGetMe**](#usersgetme) | **GET** /api/v1/users/me | |
|[**usersRemoveAvatar**](#usersremoveavatar) | **DELETE** /api/v1/users/me/avatar | |
|[**usersReport**](#usersreport) | **POST** /api/v1/users/{userId}/report | |
|[**usersSearch**](#userssearch) | **GET** /api/v1/users/search | |
|[**usersSetAvatar**](#userssetavatar) | **PUT** /api/v1/users/me/avatar | |
|[**usersUpdateMe**](#usersupdateme) | **PATCH** /api/v1/users/me | |

# **usersGetById**
> UserResponse usersGetById()


### Example

```typescript
import {
    UsersApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new UsersApi(configuration);

let userId: string; // (default to undefined)

const { status, data } = await apiInstance.usersGetById(
    userId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **userId** | [**string**] |  | defaults to undefined|


### Return type

**UserResponse**

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

# **usersGetMe**
> UserResponse usersGetMe()


### Example

```typescript
import {
    UsersApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new UsersApi(configuration);

const { status, data } = await apiInstance.usersGetMe();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**UserResponse**

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

# **usersRemoveAvatar**
> UserResponse usersRemoveAvatar()


### Example

```typescript
import {
    UsersApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new UsersApi(configuration);

const { status, data } = await apiInstance.usersRemoveAvatar();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**UserResponse**

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

# **usersReport**
> { [key: string]: any; } usersReport(reportUserDto)


### Example

```typescript
import {
    UsersApi,
    Configuration,
    ReportUserDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new UsersApi(configuration);

let userId: string; // (default to undefined)
let reportUserDto: ReportUserDto; //

const { status, data } = await apiInstance.usersReport(
    userId,
    reportUserDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **reportUserDto** | **ReportUserDto**|  | |
| **userId** | [**string**] |  | defaults to undefined|


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

# **usersSearch**
> Array<UserResponse> usersSearch()


### Example

```typescript
import {
    UsersApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new UsersApi(configuration);

let q: any; // (optional) (default to undefined)

const { status, data } = await apiInstance.usersSearch(
    q
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **q** | **any** |  | (optional) defaults to undefined|


### Return type

**Array<UserResponse>**

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

# **usersSetAvatar**
> UserResponse usersSetAvatar(setAvatarDto)


### Example

```typescript
import {
    UsersApi,
    Configuration,
    SetAvatarDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new UsersApi(configuration);

let setAvatarDto: SetAvatarDto; //

const { status, data } = await apiInstance.usersSetAvatar(
    setAvatarDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **setAvatarDto** | **SetAvatarDto**|  | |


### Return type

**UserResponse**

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

# **usersUpdateMe**
> UserResponse usersUpdateMe(updateProfileDto)


### Example

```typescript
import {
    UsersApi,
    Configuration,
    UpdateProfileDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new UsersApi(configuration);

let updateProfileDto: UpdateProfileDto; //

const { status, data } = await apiInstance.usersUpdateMe(
    updateProfileDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **updateProfileDto** | **UpdateProfileDto**|  | |


### Return type

**UserResponse**

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

