# chat_api_client.api.AdminApi

## Load the API package
```dart
import 'package:chat_api_client/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminActivateUser**](AdminApi.md#adminactivateuser) | **PATCH** /api/v1/admin/users/{userId}/activate | 
[**adminGetGroup**](AdminApi.md#admingetgroup) | **GET** /api/v1/admin/groups/{groupId} | 
[**adminGetUser**](AdminApi.md#admingetuser) | **GET** /api/v1/admin/users/{userId} | 
[**adminListAuditLogs**](AdminApi.md#adminlistauditlogs) | **GET** /api/v1/admin/audit-logs | 
[**adminListGroupMembers**](AdminApi.md#adminlistgroupmembers) | **GET** /api/v1/admin/groups/{groupId}/members | 
[**adminListGroups**](AdminApi.md#adminlistgroups) | **GET** /api/v1/admin/groups | 
[**adminListJobRuns**](AdminApi.md#adminlistjobruns) | **GET** /api/v1/admin/jobs/runs | 
[**adminListUsers**](AdminApi.md#adminlistusers) | **GET** /api/v1/admin/users | 
[**adminOverview**](AdminApi.md#adminoverview) | **GET** /api/v1/admin/overview | 
[**adminRevokeUserDevice**](AdminApi.md#adminrevokeuserdevice) | **DELETE** /api/v1/admin/users/{userId}/devices/{sessionId} | 
[**adminRunCleanup**](AdminApi.md#adminruncleanup) | **POST** /api/v1/admin/jobs/cleanup/run | 
[**adminSetGroupPolicy**](AdminApi.md#adminsetgrouppolicy) | **PATCH** /api/v1/admin/groups/{groupId}/policy | 
[**adminSuspendUser**](AdminApi.md#adminsuspenduser) | **PATCH** /api/v1/admin/users/{userId}/suspend | 


# **adminActivateUser**
> AdminUserResponse adminActivateUser(userId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final String userId = userId_example; // String | 

try {
    final response = api.adminActivateUser(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminActivateUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**AdminUserResponse**](AdminUserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminGetGroup**
> AdminGroupResponse adminGetGroup(groupId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final String groupId = groupId_example; // String | 

try {
    final response = api.adminGetGroup(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminGetGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 

### Return type

[**AdminGroupResponse**](AdminGroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminGetUser**
> AdminUserResponse adminGetUser(userId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final String userId = userId_example; // String | 

try {
    final response = api.adminGetUser(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminGetUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**AdminUserResponse**](AdminUserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListAuditLogs**
> AuditLogPageResponse adminListAuditLogs(limit, cursor, action, targetType, actorUserId, targetId, from, to)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final int limit = 56; // int | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String action = action_example; // String | 
final String targetType = targetType_example; // String | 
final String actorUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String targetId = targetId_example; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.adminListAuditLogs(limit, cursor, action, targetType, actorUserId, targetId, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminListAuditLogs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 50]
 **cursor** | **String**|  | [optional] 
 **action** | **String**|  | [optional] 
 **targetType** | **String**|  | [optional] 
 **actorUserId** | **String**|  | [optional] 
 **targetId** | **String**|  | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**AuditLogPageResponse**](AuditLogPageResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListGroupMembers**
> AdminGroupMemberPageResponse adminListGroupMembers(groupId, limit, cursor, search)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final String groupId = groupId_example; // String | 
final int limit = 56; // int | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String search = search_example; // String | 

try {
    final response = api.adminListGroupMembers(groupId, limit, cursor, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminListGroupMembers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **limit** | **int**|  | [optional] [default to 30]
 **cursor** | **String**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**AdminGroupMemberPageResponse**](AdminGroupMemberPageResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListGroups**
> AdminGroupPageResponse adminListGroups(limit, status, cursor, search)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final int limit = 56; // int | 
final String status = status_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String search = search_example; // String | 

try {
    final response = api.adminListGroups(limit, status, cursor, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminListGroups: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 30]
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**AdminGroupPageResponse**](AdminGroupPageResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListJobRuns**
> JobRunPageResponse adminListJobRuns(limit, cursor, status)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final int limit = 56; // int | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 

try {
    final response = api.adminListJobRuns(limit, cursor, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminListJobRuns: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 30]
 **cursor** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**JobRunPageResponse**](JobRunPageResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListUsers**
> AdminUserPageResponse adminListUsers(limit, status, role, cursor, search)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final int limit = 56; // int | 
final String status = status_example; // String | 
final String role = role_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String search = search_example; // String | 

try {
    final response = api.adminListUsers(limit, status, role, cursor, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminListUsers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 30]
 **status** | **String**|  | [optional] 
 **role** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**AdminUserPageResponse**](AdminUserPageResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOverview**
> AdminOverviewResponse adminOverview()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();

try {
    final response = api.adminOverview();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminOverview: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminOverviewResponse**](AdminOverviewResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRevokeUserDevice**
> SuccessResponse adminRevokeUserDevice(userId, sessionId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final String userId = userId_example; // String | 
final String sessionId = sessionId_example; // String | 

try {
    final response = api.adminRevokeUserDevice(userId, sessionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRevokeUserDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **sessionId** | **String**|  | 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRunCleanup**
> JobRunResponse adminRunCleanup()



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();

try {
    final response = api.adminRunCleanup();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRunCleanup: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JobRunResponse**](JobRunResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSetGroupPolicy**
> AdminGroupResponse adminSetGroupPolicy(groupId, setGroupPolicyDto)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final String groupId = groupId_example; // String | 
final SetGroupPolicyDto setGroupPolicyDto = ; // SetGroupPolicyDto | 

try {
    final response = api.adminSetGroupPolicy(groupId, setGroupPolicyDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSetGroupPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  | 
 **setGroupPolicyDto** | [**SetGroupPolicyDto**](SetGroupPolicyDto.md)|  | 

### Return type

[**AdminGroupResponse**](AdminGroupResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSuspendUser**
> AdminUserResponse adminSuspendUser(userId)



### Example
```dart
import 'package:chat_api_client/api.dart';

final api = ChatApiClient().getAdminApi();
final String userId = userId_example; // String | 

try {
    final response = api.adminSuspendUser(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSuspendUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**AdminUserResponse**](AdminUserResponse.md)

### Authorization

[access-token](../README.md#access-token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

