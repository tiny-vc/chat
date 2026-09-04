# GroupsApi

All URIs are relative to *http://localhost:3000*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**groupsAddMembers**](#groupsaddmembers) | **POST** /api/v1/groups/{groupId}/members | |
|[**groupsApplyToJoin**](#groupsapplytojoin) | **POST** /api/v1/groups/{groupId}/join-requests | |
|[**groupsApproveJoinRequest**](#groupsapprovejoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/approve | |
|[**groupsCancelJoinRequest**](#groupscanceljoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/cancel | |
|[**groupsCreate**](#groupscreate) | **POST** /api/v1/groups | |
|[**groupsDisband**](#groupsdisband) | **DELETE** /api/v1/groups/{groupId} | |
|[**groupsGet**](#groupsget) | **GET** /api/v1/groups/{groupId} | |
|[**groupsInviteMember**](#groupsinvitemember) | **POST** /api/v1/groups/{groupId}/invitations | |
|[**groupsLeave**](#groupsleave) | **POST** /api/v1/groups/{groupId}/leave | |
|[**groupsList**](#groupslist) | **GET** /api/v1/groups | |
|[**groupsListActionableJoinRequests**](#groupslistactionablejoinrequests) | **GET** /api/v1/groups/join-requests/actionable | |
|[**groupsListMyJoinRequests**](#groupslistmyjoinrequests) | **GET** /api/v1/groups/join-requests/me | |
|[**groupsListPendingJoinRequests**](#groupslistpendingjoinrequests) | **GET** /api/v1/groups/{groupId}/join-requests | |
|[**groupsMuteMember**](#groupsmutemember) | **PATCH** /api/v1/groups/{groupId}/members/{memberId}/mute | |
|[**groupsPendingJoinRequestCount**](#groupspendingjoinrequestcount) | **GET** /api/v1/groups/join-requests/pending-count | |
|[**groupsRejectJoinRequest**](#groupsrejectjoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/reject | |
|[**groupsRemoveAvatar**](#groupsremoveavatar) | **DELETE** /api/v1/groups/{groupId}/avatar | |
|[**groupsRemoveMember**](#groupsremovemember) | **DELETE** /api/v1/groups/{groupId}/members/{memberId} | |
|[**groupsSetAvatar**](#groupssetavatar) | **PUT** /api/v1/groups/{groupId}/avatar | |
|[**groupsSetMemberRole**](#groupssetmemberrole) | **PATCH** /api/v1/groups/{groupId}/members/{memberId}/role | |
|[**groupsTransferOwner**](#groupstransferowner) | **POST** /api/v1/groups/{groupId}/transfer-owner | |
|[**groupsUpdate**](#groupsupdate) | **PATCH** /api/v1/groups/{groupId} | |

# **groupsAddMembers**
> GroupResponse groupsAddMembers(addGroupMembersDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    AddGroupMembersDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let addGroupMembersDto: AddGroupMembersDto; //

const { status, data } = await apiInstance.groupsAddMembers(
    groupId,
    addGroupMembersDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **addGroupMembersDto** | **AddGroupMembersDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupResponse**

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

# **groupsApplyToJoin**
> GroupJoinRequestResponse groupsApplyToJoin(groupJoinMessageDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    GroupJoinMessageDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let groupJoinMessageDto: GroupJoinMessageDto; //

const { status, data } = await apiInstance.groupsApplyToJoin(
    groupId,
    groupJoinMessageDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupJoinMessageDto** | **GroupJoinMessageDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupJoinRequestResponse**

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

# **groupsApproveJoinRequest**
> GroupJoinRequestResponse groupsApproveJoinRequest()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let requestId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsApproveJoinRequest(
    requestId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **requestId** | [**string**] |  | defaults to undefined|


### Return type

**GroupJoinRequestResponse**

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

# **groupsCancelJoinRequest**
> GroupJoinRequestResponse groupsCancelJoinRequest()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let requestId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsCancelJoinRequest(
    requestId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **requestId** | [**string**] |  | defaults to undefined|


### Return type

**GroupJoinRequestResponse**

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

# **groupsCreate**
> GroupResponse groupsCreate(createGroupDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    CreateGroupDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let createGroupDto: CreateGroupDto; //

const { status, data } = await apiInstance.groupsCreate(
    createGroupDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **createGroupDto** | **CreateGroupDto**|  | |


### Return type

**GroupResponse**

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

# **groupsDisband**
> SuccessResponse groupsDisband()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsDisband(
    groupId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|


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

# **groupsGet**
> GroupResponse groupsGet()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsGet(
    groupId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupResponse**

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

# **groupsInviteMember**
> GroupJoinRequestResponse groupsInviteMember(inviteGroupMemberDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    InviteGroupMemberDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let inviteGroupMemberDto: InviteGroupMemberDto; //

const { status, data } = await apiInstance.groupsInviteMember(
    groupId,
    inviteGroupMemberDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **inviteGroupMemberDto** | **InviteGroupMemberDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupJoinRequestResponse**

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

# **groupsLeave**
> SuccessResponse groupsLeave()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsLeave(
    groupId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|


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
|**201** | Successful response |  -  |
|**400** | Request rejected |  -  |
|**401** | Request rejected |  -  |
|**403** | Request rejected |  -  |
|**500** | Internal server error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsList**
> Array<GroupResponse> groupsList()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

const { status, data } = await apiInstance.groupsList();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**Array<GroupResponse>**

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

# **groupsListActionableJoinRequests**
> Array<GroupJoinRequestResponse> groupsListActionableJoinRequests()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let before: string; // (optional) (default to undefined)
let beforeId: string; // (optional) (default to undefined)

const { status, data } = await apiInstance.groupsListActionableJoinRequests(
    before,
    beforeId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **before** | [**string**] |  | (optional) defaults to undefined|
| **beforeId** | [**string**] |  | (optional) defaults to undefined|


### Return type

**Array<GroupJoinRequestResponse>**

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

# **groupsListMyJoinRequests**
> Array<GroupJoinRequestResponse> groupsListMyJoinRequests()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let before: string; // (optional) (default to undefined)
let beforeId: string; // (optional) (default to undefined)

const { status, data } = await apiInstance.groupsListMyJoinRequests(
    before,
    beforeId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **before** | [**string**] |  | (optional) defaults to undefined|
| **beforeId** | [**string**] |  | (optional) defaults to undefined|


### Return type

**Array<GroupJoinRequestResponse>**

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

# **groupsListPendingJoinRequests**
> Array<GroupJoinRequestResponse> groupsListPendingJoinRequests()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsListPendingJoinRequests(
    groupId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**Array<GroupJoinRequestResponse>**

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

# **groupsMuteMember**
> GroupMemberResponse groupsMuteMember(muteMemberDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    MuteMemberDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let memberId: string; // (default to undefined)
let muteMemberDto: MuteMemberDto; //

const { status, data } = await apiInstance.groupsMuteMember(
    groupId,
    memberId,
    muteMemberDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **muteMemberDto** | **MuteMemberDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|
| **memberId** | [**string**] |  | defaults to undefined|


### Return type

**GroupMemberResponse**

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

# **groupsPendingJoinRequestCount**
> CountResponse groupsPendingJoinRequestCount()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

const { status, data } = await apiInstance.groupsPendingJoinRequestCount();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**CountResponse**

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

# **groupsRejectJoinRequest**
> GroupJoinRequestResponse groupsRejectJoinRequest(groupJoinMessageDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    GroupJoinMessageDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let requestId: string; // (default to undefined)
let groupJoinMessageDto: GroupJoinMessageDto; //

const { status, data } = await apiInstance.groupsRejectJoinRequest(
    requestId,
    groupJoinMessageDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupJoinMessageDto** | **GroupJoinMessageDto**|  | |
| **requestId** | [**string**] |  | defaults to undefined|


### Return type

**GroupJoinRequestResponse**

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

# **groupsRemoveAvatar**
> GroupResponse groupsRemoveAvatar()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsRemoveAvatar(
    groupId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupResponse**

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

# **groupsRemoveMember**
> SuccessResponse groupsRemoveMember()


### Example

```typescript
import {
    GroupsApi,
    Configuration
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let memberId: string; // (default to undefined)

const { status, data } = await apiInstance.groupsRemoveMember(
    groupId,
    memberId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **groupId** | [**string**] |  | defaults to undefined|
| **memberId** | [**string**] |  | defaults to undefined|


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

# **groupsSetAvatar**
> GroupResponse groupsSetAvatar(setGroupAvatarDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    SetGroupAvatarDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let setGroupAvatarDto: SetGroupAvatarDto; //

const { status, data } = await apiInstance.groupsSetAvatar(
    groupId,
    setGroupAvatarDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **setGroupAvatarDto** | **SetGroupAvatarDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupResponse**

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

# **groupsSetMemberRole**
> GroupMemberResponse groupsSetMemberRole(setMemberRoleDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    SetMemberRoleDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let memberId: string; // (default to undefined)
let setMemberRoleDto: SetMemberRoleDto; //

const { status, data } = await apiInstance.groupsSetMemberRole(
    groupId,
    memberId,
    setMemberRoleDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **setMemberRoleDto** | **SetMemberRoleDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|
| **memberId** | [**string**] |  | defaults to undefined|


### Return type

**GroupMemberResponse**

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

# **groupsTransferOwner**
> GroupResponse groupsTransferOwner(transferOwnerDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    TransferOwnerDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let transferOwnerDto: TransferOwnerDto; //

const { status, data } = await apiInstance.groupsTransferOwner(
    groupId,
    transferOwnerDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **transferOwnerDto** | **TransferOwnerDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupResponse**

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

# **groupsUpdate**
> GroupResponse groupsUpdate(updateGroupDto)


### Example

```typescript
import {
    GroupsApi,
    Configuration,
    UpdateGroupDto
} from '@chat/admin-api-client';

const configuration = new Configuration();
const apiInstance = new GroupsApi(configuration);

let groupId: string; // (default to undefined)
let updateGroupDto: UpdateGroupDto; //

const { status, data } = await apiInstance.groupsUpdate(
    groupId,
    updateGroupDto
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **updateGroupDto** | **UpdateGroupDto**|  | |
| **groupId** | [**string**] |  | defaults to undefined|


### Return type

**GroupResponse**

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

