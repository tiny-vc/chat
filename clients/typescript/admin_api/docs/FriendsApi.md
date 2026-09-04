# FriendsApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**friendsAccept**](#friendsaccept) | **POST** /api/v1/friends/requests/{requestId}/accept | |
|[**friendsList**](#friendslist) | **GET** /api/v1/friends | |
|[**friendsListRequests**](#friendslistrequests) | **GET** /api/v1/friends/requests | |
|[**friendsReject**](#friendsreject) | **POST** /api/v1/friends/requests/{requestId}/reject | |
|[**friendsRemove**](#friendsremove) | **DELETE** /api/v1/friends/{userId} | |
|[**friendsRequest**](#friendsrequest) | **POST** /api/v1/friends/requests | |

# **friendsAccept**
> FriendshipResponse friendsAccept()


### Example

```typescript
import {
    FriendsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FriendsApi(configuration);

let requestId: string; // (default to undefined)

const { status, data } = await apiInstance.friendsAccept(
    requestId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **requestId** | [**string**] |  | defaults to undefined|


### Return type

**FriendshipResponse**

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

# **friendsList**
> Array<FriendResponse> friendsList()


### Example

```typescript
import {
    FriendsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FriendsApi(configuration);

const { status, data } = await apiInstance.friendsList();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**Array<FriendResponse>**

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

# **friendsListRequests**
> Array<FriendshipResponse> friendsListRequests()


### Example

```typescript
import {
    FriendsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FriendsApi(configuration);

const { status, data } = await apiInstance.friendsListRequests();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**Array<FriendshipResponse>**

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

# **friendsReject**
> FriendshipResponse friendsReject()


### Example

```typescript
import {
    FriendsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FriendsApi(configuration);

let requestId: string; // (default to undefined)

const { status, data } = await apiInstance.friendsReject(
    requestId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **requestId** | [**string**] |  | defaults to undefined|


### Return type

**FriendshipResponse**

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

# **friendsRemove**
> SuccessResponse friendsRemove()


### Example

```typescript
import {
    FriendsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FriendsApi(configuration);

let userId: string; // (default to undefined)

const { status, data } = await apiInstance.friendsRemove(
    userId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **userId** | [**string**] |  | defaults to undefined|


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

# **friendsRequest**
> FriendshipResponse friendsRequest(createFriendRequestDto)


### Example

```typescript
import {
    FriendsApi,
    Configuration,
    CreateFriendRequestDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new FriendsApi(configuration);

let createFriendRequestDto: CreateFriendRequestDto; //

const { status, data } = await apiInstance.friendsRequest(
    createFriendRequestDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **createFriendRequestDto** | **CreateFriendRequestDto**|  | |


### Return type

**FriendshipResponse**

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

