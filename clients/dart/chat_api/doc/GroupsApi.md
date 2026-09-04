# chat_api_client.api.GroupsApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**groupsAddMembers**](GroupsApi.md#groupsaddmembers) | **POST** /api/v1/groups/{groupId}/members | 
[**groupsApplyToJoin**](GroupsApi.md#groupsapplytojoin) | **POST** /api/v1/groups/{groupId}/join-requests | 
[**groupsApproveJoinRequest**](GroupsApi.md#groupsapprovejoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/approve | 
[**groupsCancelJoinRequest**](GroupsApi.md#groupscanceljoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/cancel | 
[**groupsCreate**](GroupsApi.md#groupscreate) | **POST** /api/v1/groups | 
[**groupsDisband**](GroupsApi.md#groupsdisband) | **DELETE** /api/v1/groups/{groupId} | 
[**groupsGet**](GroupsApi.md#groupsget) | **GET** /api/v1/groups/{groupId} | 
[**groupsInviteMember**](GroupsApi.md#groupsinvitemember) | **POST** /api/v1/groups/{groupId}/invitations | 
[**groupsLeave**](GroupsApi.md#groupsleave) | **POST** /api/v1/groups/{groupId}/leave | 
[**groupsList**](GroupsApi.md#groupslist) | **GET** /api/v1/groups | 
[**groupsListActionableJoinRequests**](GroupsApi.md#groupslistactionablejoinrequests) | **GET** /api/v1/groups/join-requests/actionable | 
[**groupsListMyJoinRequests**](GroupsApi.md#groupslistmyjoinrequests) | **GET** /api/v1/groups/join-requests/me | 
[**groupsListPendingJoinRequests**](GroupsApi.md#groupslistpendingjoinrequests) | **GET** /api/v1/groups/{groupId}/join-requests | 
[**groupsMuteMember**](GroupsApi.md#groupsmutemember) | **PATCH** /api/v1/groups/{groupId}/members/{memberId}/mute | 
[**groupsPendingJoinRequestCount**](GroupsApi.md#groupspendingjoinrequestcount) | **GET** /api/v1/groups/join-requests/pending-count | 
[**groupsRejectJoinRequest**](GroupsApi.md#groupsrejectjoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/reject | 
[**groupsRemoveAvatar**](GroupsApi.md#groupsremoveavatar) | **DELETE** /api/v1/groups/{groupId}/avatar | 
[**groupsRemoveMember**](GroupsApi.md#groupsremovemember) | **DELETE** /api/v1/groups/{groupId}/members/{memberId} | 
[**groupsSetAvatar**](GroupsApi.md#groupssetavatar) | **PUT** /api/v1/groups/{groupId}/avatar | 
[**groupsSetMemberRole**](GroupsApi.md#groupssetmemberrole) | **PATCH** /api/v1/groups/{groupId}/members/{memberId}/role | 
[**groupsTransferOwner**](GroupsApi.md#groupstransferowner) | **POST** /api/v1/groups/{groupId}/transfer-owner | 
[**groupsUpdate**](GroupsApi.md#groupsupdate) | **PATCH** /api/v1/groups/{groupId} | 


# **groupsAddMembers**
> GroupResponse groupsAddMembers(groupId, addGroupMembersDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final AddGroupMembersDto addGroupMembersDto = ; // AddGroupMembersDto | 

try {
    final response = api.groupsAddMembers(groupId, addGroupMembersDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsAddMembers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **addGroupMembersDto** | [**AddGroupMembersDto**](AddGroupMembersDto.md)|  | 

### Return type

[**GroupResponse**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsApplyToJoin**
> GroupJoinRequestResponse groupsApplyToJoin(groupId, groupJoinMessageDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final GroupJoinMessageDto groupJoinMessageDto = ; // GroupJoinMessageDto | 

try {
    final response = api.groupsApplyToJoin(groupId, groupJoinMessageDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsApplyToJoin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **groupJoinMessageDto** | [**GroupJoinMessageDto**](GroupJoinMessageDto.md)|  | 

### Return type

[**GroupJoinRequestResponse**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsApproveJoinRequest**
> GroupJoinRequestResponse groupsApproveJoinRequest(requestId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String requestId = requestId_example; // String | 

try {
    final response = api.groupsApproveJoinRequest(requestId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsApproveJoinRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **String**|  | 

### Return type

[**GroupJoinRequestResponse**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsCancelJoinRequest**
> GroupJoinRequestResponse groupsCancelJoinRequest(requestId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String requestId = requestId_example; // String | 

try {
    final response = api.groupsCancelJoinRequest(requestId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsCancelJoinRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **String**|  | 

### Return type

[**GroupJoinRequestResponse**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsCreate**
> GroupResponse groupsCreate(createGroupDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final CreateGroupDto createGroupDto = ; // CreateGroupDto | 

try {
    final response = api.groupsCreate(createGroupDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createGroupDto** | [**CreateGroupDto**](CreateGroupDto.md)|  | 

### Return type

[**GroupResponse**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsDisband**
> SuccessResponse groupsDisband(groupId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 

try {
    final response = api.groupsDisband(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsDisband: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsGet**
> GroupResponse groupsGet(groupId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 

try {
    final response = api.groupsGet(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 

### Return type

[**GroupResponse**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsInviteMember**
> GroupJoinRequestResponse groupsInviteMember(groupId, inviteGroupMemberDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final InviteGroupMemberDto inviteGroupMemberDto = ; // InviteGroupMemberDto | 

try {
    final response = api.groupsInviteMember(groupId, inviteGroupMemberDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsInviteMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **inviteGroupMemberDto** | [**InviteGroupMemberDto**](InviteGroupMemberDto.md)|  | 

### Return type

[**GroupJoinRequestResponse**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsLeave**
> SuccessResponse groupsLeave(groupId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 

try {
    final response = api.groupsLeave(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsLeave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsList**
> BuiltList<GroupResponse> groupsList()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();

try {
    final response = api.groupsList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;GroupResponse&gt;**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsListActionableJoinRequests**
> BuiltList<GroupJoinRequestResponse> groupsListActionableJoinRequests(before, beforeId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String before = before_example; // String | 
final String beforeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.groupsListActionableJoinRequests(before, beforeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsListActionableJoinRequests: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **before** | **String**|  | [optional] 
 **beforeId** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;GroupJoinRequestResponse&gt;**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsListMyJoinRequests**
> BuiltList<GroupJoinRequestResponse> groupsListMyJoinRequests(before, beforeId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String before = before_example; // String | 
final String beforeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.groupsListMyJoinRequests(before, beforeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsListMyJoinRequests: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **before** | **String**|  | [optional] 
 **beforeId** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;GroupJoinRequestResponse&gt;**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsListPendingJoinRequests**
> BuiltList<GroupJoinRequestResponse> groupsListPendingJoinRequests(groupId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 

try {
    final response = api.groupsListPendingJoinRequests(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsListPendingJoinRequests: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 

### Return type

[**BuiltList&lt;GroupJoinRequestResponse&gt;**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsMuteMember**
> GroupMemberResponse groupsMuteMember(groupId, memberId, muteMemberDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final String memberId = memberId_example; // String | 
final MuteMemberDto muteMemberDto = ; // MuteMemberDto | 

try {
    final response = api.groupsMuteMember(groupId, memberId, muteMemberDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsMuteMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **memberId** | **String**|  | 
 **muteMemberDto** | [**MuteMemberDto**](MuteMemberDto.md)|  | 

### Return type

[**GroupMemberResponse**](GroupMemberResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsPendingJoinRequestCount**
> CountResponse groupsPendingJoinRequestCount()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();

try {
    final response = api.groupsPendingJoinRequestCount();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsPendingJoinRequestCount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CountResponse**](CountResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsRejectJoinRequest**
> GroupJoinRequestResponse groupsRejectJoinRequest(requestId, groupJoinMessageDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String requestId = requestId_example; // String | 
final GroupJoinMessageDto groupJoinMessageDto = ; // GroupJoinMessageDto | 

try {
    final response = api.groupsRejectJoinRequest(requestId, groupJoinMessageDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsRejectJoinRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **String**|  | 
 **groupJoinMessageDto** | [**GroupJoinMessageDto**](GroupJoinMessageDto.md)|  | 

### Return type

[**GroupJoinRequestResponse**](GroupJoinRequestResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsRemoveAvatar**
> GroupResponse groupsRemoveAvatar(groupId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 

try {
    final response = api.groupsRemoveAvatar(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsRemoveAvatar: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 

### Return type

[**GroupResponse**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsRemoveMember**
> SuccessResponse groupsRemoveMember(groupId, memberId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final String memberId = memberId_example; // String | 

try {
    final response = api.groupsRemoveMember(groupId, memberId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsRemoveMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **memberId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsSetAvatar**
> GroupResponse groupsSetAvatar(groupId, setGroupAvatarDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final SetGroupAvatarDto setGroupAvatarDto = ; // SetGroupAvatarDto | 

try {
    final response = api.groupsSetAvatar(groupId, setGroupAvatarDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsSetAvatar: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **setGroupAvatarDto** | [**SetGroupAvatarDto**](SetGroupAvatarDto.md)|  | 

### Return type

[**GroupResponse**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsSetMemberRole**
> GroupMemberResponse groupsSetMemberRole(groupId, memberId, setMemberRoleDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final String memberId = memberId_example; // String | 
final SetMemberRoleDto setMemberRoleDto = ; // SetMemberRoleDto | 

try {
    final response = api.groupsSetMemberRole(groupId, memberId, setMemberRoleDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsSetMemberRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **memberId** | **String**|  | 
 **setMemberRoleDto** | [**SetMemberRoleDto**](SetMemberRoleDto.md)|  | 

### Return type

[**GroupMemberResponse**](GroupMemberResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsTransferOwner**
> GroupResponse groupsTransferOwner(groupId, transferOwnerDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final TransferOwnerDto transferOwnerDto = ; // TransferOwnerDto | 

try {
    final response = api.groupsTransferOwner(groupId, transferOwnerDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsTransferOwner: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **transferOwnerDto** | [**TransferOwnerDto**](TransferOwnerDto.md)|  | 

### Return type

[**GroupResponse**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsUpdate**
> GroupResponse groupsUpdate(groupId, updateGroupDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getGroupsApi();
final String groupId = groupId_example; // String | 
final UpdateGroupDto updateGroupDto = ; // UpdateGroupDto | 

try {
    final response = api.groupsUpdate(groupId, updateGroupDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->groupsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **updateGroupDto** | [**UpdateGroupDto**](UpdateGroupDto.md)|  | 

### Return type

[**GroupResponse**](GroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

