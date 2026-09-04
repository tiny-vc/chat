## @chat/admin-api-client@0.1.0

This generator creates TypeScript/JavaScript client that utilizes [axios](https://github.com/axios/axios). The generated Node module can be used in the following environments:

Environment
* Node.js
* Webpack
* Browserify

Language level
* ES5 - you must have a Promises/A+ library installed
* ES6

Module system
* CommonJS
* ES6 module system

It can be used in both TypeScript and JavaScript. In TypeScript, the definition will be automatically resolved via `package.json`. ([Reference](https://www.typescriptlang.org/docs/handbook/declaration-files/consumption.html))

### Building

To build and compile the typescript sources to javascript use:
```
npm install
npm run build
```

### Publishing

First build the package then run `npm publish`

### Consuming

navigate to the folder of your consuming project and run one of the following commands.

_published:_

```
npm install @chat/admin-api-client@0.1.0 --save
```

_unPublished (not recommended):_

```
npm install PATH_TO_GENERATED_PACKAGE --save
```

### Documentation for API Endpoints

All URIs are relative to *http://localhost:3000*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*AdminApi* | [**adminActivateUser**](docs/AdminApi.md#adminactivateuser) | **PATCH** /api/v1/admin/users/{userId}/activate | 
*AdminApi* | [**adminGetGroup**](docs/AdminApi.md#admingetgroup) | **GET** /api/v1/admin/groups/{groupId} | 
*AdminApi* | [**adminGetUser**](docs/AdminApi.md#admingetuser) | **GET** /api/v1/admin/users/{userId} | 
*AdminApi* | [**adminListAuditLogs**](docs/AdminApi.md#adminlistauditlogs) | **GET** /api/v1/admin/audit-logs | 
*AdminApi* | [**adminListGroupMembers**](docs/AdminApi.md#adminlistgroupmembers) | **GET** /api/v1/admin/groups/{groupId}/members | 
*AdminApi* | [**adminListGroups**](docs/AdminApi.md#adminlistgroups) | **GET** /api/v1/admin/groups | 
*AdminApi* | [**adminListJobRuns**](docs/AdminApi.md#adminlistjobruns) | **GET** /api/v1/admin/jobs/runs | 
*AdminApi* | [**adminListUsers**](docs/AdminApi.md#adminlistusers) | **GET** /api/v1/admin/users | 
*AdminApi* | [**adminOverview**](docs/AdminApi.md#adminoverview) | **GET** /api/v1/admin/overview | 
*AdminApi* | [**adminRevokeUserDevice**](docs/AdminApi.md#adminrevokeuserdevice) | **DELETE** /api/v1/admin/users/{userId}/devices/{sessionId} | 
*AdminApi* | [**adminRunCleanup**](docs/AdminApi.md#adminruncleanup) | **POST** /api/v1/admin/jobs/cleanup/run | 
*AdminApi* | [**adminSetGroupPolicy**](docs/AdminApi.md#adminsetgrouppolicy) | **PATCH** /api/v1/admin/groups/{groupId}/policy | 
*AdminApi* | [**adminSuspendUser**](docs/AdminApi.md#adminsuspenduser) | **PATCH** /api/v1/admin/users/{userId}/suspend | 
*AuthApi* | [**authChangePassword**](docs/AuthApi.md#authchangepassword) | **POST** /api/v1/auth/change-password | 
*AuthApi* | [**authDeactivateAccount**](docs/AuthApi.md#authdeactivateaccount) | **DELETE** /api/v1/auth/account | 
*AuthApi* | [**authDevices**](docs/AuthApi.md#authdevices) | **GET** /api/v1/auth/devices | 
*AuthApi* | [**authLogin**](docs/AuthApi.md#authlogin) | **POST** /api/v1/auth/login | 
*AuthApi* | [**authLogout**](docs/AuthApi.md#authlogout) | **POST** /api/v1/auth/logout | 
*AuthApi* | [**authLogoutAll**](docs/AuthApi.md#authlogoutall) | **POST** /api/v1/auth/logout-all | 
*AuthApi* | [**authRefresh**](docs/AuthApi.md#authrefresh) | **POST** /api/v1/auth/refresh | 
*AuthApi* | [**authRegister**](docs/AuthApi.md#authregister) | **POST** /api/v1/auth/register | 
*AuthApi* | [**authRevokeDevice**](docs/AuthApi.md#authrevokedevice) | **DELETE** /api/v1/auth/devices/{sessionId} | 
*BlocksApi* | [**blocksBlock**](docs/BlocksApi.md#blocksblock) | **POST** /api/v1/blocks/{userId} | 
*BlocksApi* | [**blocksList**](docs/BlocksApi.md#blockslist) | **GET** /api/v1/blocks | 
*BlocksApi* | [**blocksUnblock**](docs/BlocksApi.md#blocksunblock) | **DELETE** /api/v1/blocks/{userId} | 
*CallsApi* | [**callsAccept**](docs/CallsApi.md#callsaccept) | **POST** /api/v1/calls/{callId}/accept | 
*CallsApi* | [**callsBusy**](docs/CallsApi.md#callsbusy) | **POST** /api/v1/calls/{callId}/busy | 
*CallsApi* | [**callsCancel**](docs/CallsApi.md#callscancel) | **POST** /api/v1/calls/{callId}/cancel | 
*CallsApi* | [**callsCreate**](docs/CallsApi.md#callscreate) | **POST** /api/v1/calls | 
*CallsApi* | [**callsCreateToken**](docs/CallsApi.md#callscreatetoken) | **POST** /api/v1/calls/{callId}/token | 
*CallsApi* | [**callsEnd**](docs/CallsApi.md#callsend) | **POST** /api/v1/calls/{callId}/end | 
*CallsApi* | [**callsList**](docs/CallsApi.md#callslist) | **GET** /api/v1/calls | 
*CallsApi* | [**callsMiss**](docs/CallsApi.md#callsmiss) | **POST** /api/v1/calls/{callId}/miss | 
*CallsApi* | [**callsReject**](docs/CallsApi.md#callsreject) | **POST** /api/v1/calls/{callId}/reject | 
*ConversationsApi* | [**conversationsList**](docs/ConversationsApi.md#conversationslist) | **GET** /api/v1/conversations/settings | 
*ConversationsApi* | [**conversationsRemove**](docs/ConversationsApi.md#conversationsremove) | **DELETE** /api/v1/conversations/settings/{channelType}/{channelId} | 
*ConversationsApi* | [**conversationsUpdate**](docs/ConversationsApi.md#conversationsupdate) | **PATCH** /api/v1/conversations/settings | 
*FilesApi* | [**filesComplete**](docs/FilesApi.md#filescomplete) | **POST** /api/v1/files/{fileId}/complete | 
*FilesApi* | [**filesCreateUpload**](docs/FilesApi.md#filescreateupload) | **POST** /api/v1/files/uploads | 
*FilesApi* | [**filesDeleteFile**](docs/FilesApi.md#filesdeletefile) | **DELETE** /api/v1/files/{fileId} | 
*FilesApi* | [**filesDownload**](docs/FilesApi.md#filesdownload) | **GET** /api/v1/files/{fileId}/download | 
*FilesApi* | [**filesForward**](docs/FilesApi.md#filesforward) | **POST** /api/v1/files/{fileId}/forward | 
*FilesApi* | [**filesSetThumbnail**](docs/FilesApi.md#filessetthumbnail) | **POST** /api/v1/files/{fileId}/thumbnail | 
*FilesApi* | [**filesUsage**](docs/FilesApi.md#filesusage) | **GET** /api/v1/files/usage | 
*FriendsApi* | [**friendsAccept**](docs/FriendsApi.md#friendsaccept) | **POST** /api/v1/friends/requests/{requestId}/accept | 
*FriendsApi* | [**friendsList**](docs/FriendsApi.md#friendslist) | **GET** /api/v1/friends | 
*FriendsApi* | [**friendsListRequests**](docs/FriendsApi.md#friendslistrequests) | **GET** /api/v1/friends/requests | 
*FriendsApi* | [**friendsReject**](docs/FriendsApi.md#friendsreject) | **POST** /api/v1/friends/requests/{requestId}/reject | 
*FriendsApi* | [**friendsRemove**](docs/FriendsApi.md#friendsremove) | **DELETE** /api/v1/friends/{userId} | 
*FriendsApi* | [**friendsRequest**](docs/FriendsApi.md#friendsrequest) | **POST** /api/v1/friends/requests | 
*GroupsApi* | [**groupsAddMembers**](docs/GroupsApi.md#groupsaddmembers) | **POST** /api/v1/groups/{groupId}/members | 
*GroupsApi* | [**groupsApplyToJoin**](docs/GroupsApi.md#groupsapplytojoin) | **POST** /api/v1/groups/{groupId}/join-requests | 
*GroupsApi* | [**groupsApproveJoinRequest**](docs/GroupsApi.md#groupsapprovejoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/approve | 
*GroupsApi* | [**groupsCancelJoinRequest**](docs/GroupsApi.md#groupscanceljoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/cancel | 
*GroupsApi* | [**groupsCreate**](docs/GroupsApi.md#groupscreate) | **POST** /api/v1/groups | 
*GroupsApi* | [**groupsDisband**](docs/GroupsApi.md#groupsdisband) | **DELETE** /api/v1/groups/{groupId} | 
*GroupsApi* | [**groupsGet**](docs/GroupsApi.md#groupsget) | **GET** /api/v1/groups/{groupId} | 
*GroupsApi* | [**groupsInviteMember**](docs/GroupsApi.md#groupsinvitemember) | **POST** /api/v1/groups/{groupId}/invitations | 
*GroupsApi* | [**groupsLeave**](docs/GroupsApi.md#groupsleave) | **POST** /api/v1/groups/{groupId}/leave | 
*GroupsApi* | [**groupsList**](docs/GroupsApi.md#groupslist) | **GET** /api/v1/groups | 
*GroupsApi* | [**groupsListActionableJoinRequests**](docs/GroupsApi.md#groupslistactionablejoinrequests) | **GET** /api/v1/groups/join-requests/actionable | 
*GroupsApi* | [**groupsListMyJoinRequests**](docs/GroupsApi.md#groupslistmyjoinrequests) | **GET** /api/v1/groups/join-requests/me | 
*GroupsApi* | [**groupsListPendingJoinRequests**](docs/GroupsApi.md#groupslistpendingjoinrequests) | **GET** /api/v1/groups/{groupId}/join-requests | 
*GroupsApi* | [**groupsMuteMember**](docs/GroupsApi.md#groupsmutemember) | **PATCH** /api/v1/groups/{groupId}/members/{memberId}/mute | 
*GroupsApi* | [**groupsPendingJoinRequestCount**](docs/GroupsApi.md#groupspendingjoinrequestcount) | **GET** /api/v1/groups/join-requests/pending-count | 
*GroupsApi* | [**groupsRejectJoinRequest**](docs/GroupsApi.md#groupsrejectjoinrequest) | **POST** /api/v1/groups/join-requests/{requestId}/reject | 
*GroupsApi* | [**groupsRemoveAvatar**](docs/GroupsApi.md#groupsremoveavatar) | **DELETE** /api/v1/groups/{groupId}/avatar | 
*GroupsApi* | [**groupsRemoveMember**](docs/GroupsApi.md#groupsremovemember) | **DELETE** /api/v1/groups/{groupId}/members/{memberId} | 
*GroupsApi* | [**groupsSetAvatar**](docs/GroupsApi.md#groupssetavatar) | **PUT** /api/v1/groups/{groupId}/avatar | 
*GroupsApi* | [**groupsSetMemberRole**](docs/GroupsApi.md#groupssetmemberrole) | **PATCH** /api/v1/groups/{groupId}/members/{memberId}/role | 
*GroupsApi* | [**groupsTransferOwner**](docs/GroupsApi.md#groupstransferowner) | **POST** /api/v1/groups/{groupId}/transfer-owner | 
*GroupsApi* | [**groupsUpdate**](docs/GroupsApi.md#groupsupdate) | **PATCH** /api/v1/groups/{groupId} | 
*HealthApi* | [**healthGetHealth**](docs/HealthApi.md#healthgethealth) | **GET** /api/v1/health | 
*HealthApi* | [**healthGetReadiness**](docs/HealthApi.md#healthgetreadiness) | **GET** /api/v1/ready | 
*ImSyncApi* | [**imSyncMarkRead**](docs/ImSyncApi.md#imsyncmarkread) | **POST** /api/v1/im/conversations/read | 
*ImSyncApi* | [**imSyncReceipts**](docs/ImSyncApi.md#imsyncreceipts) | **POST** /api/v1/im/messages/receipts | 
*ImSyncApi* | [**imSyncRevokeMessage**](docs/ImSyncApi.md#imsyncrevokemessage) | **POST** /api/v1/im/messages/revoke | 
*ImSyncApi* | [**imSyncSyncConversations**](docs/ImSyncApi.md#imsyncsyncconversations) | **POST** /api/v1/im/conversations/sync | 
*ImSyncApi* | [**imSyncSyncMessages**](docs/ImSyncApi.md#imsyncsyncmessages) | **POST** /api/v1/im/messages/sync | 
*MessagesApi* | [**messagesDescribe**](docs/MessagesApi.md#messagesdescribe) | **GET** /api/v1/messages/protocol | 
*MessagesApi* | [**messagesValidate**](docs/MessagesApi.md#messagesvalidate) | **POST** /api/v1/messages/protocol/validate | 
*UsersApi* | [**usersGetById**](docs/UsersApi.md#usersgetbyid) | **GET** /api/v1/users/{userId} | 
*UsersApi* | [**usersGetMe**](docs/UsersApi.md#usersgetme) | **GET** /api/v1/users/me | 
*UsersApi* | [**usersRemoveAvatar**](docs/UsersApi.md#usersremoveavatar) | **DELETE** /api/v1/users/me/avatar | 
*UsersApi* | [**usersReport**](docs/UsersApi.md#usersreport) | **POST** /api/v1/users/{userId}/report | 
*UsersApi* | [**usersSearch**](docs/UsersApi.md#userssearch) | **GET** /api/v1/users/search | 
*UsersApi* | [**usersSetAvatar**](docs/UsersApi.md#userssetavatar) | **PUT** /api/v1/users/me/avatar | 
*UsersApi* | [**usersUpdateMe**](docs/UsersApi.md#usersupdateme) | **PATCH** /api/v1/users/me | 
*WukongWebhookApi* | [**wukongWebhookReceive**](docs/WukongWebhookApi.md#wukongwebhookreceive) | **POST** /api/v1/webhooks/wukongim | 


### Documentation For Models

 - [AddGroupMembersDto](docs/AddGroupMembersDto.md)
 - [AdminGroupMemberPageResponse](docs/AdminGroupMemberPageResponse.md)
 - [AdminGroupMemberResponse](docs/AdminGroupMemberResponse.md)
 - [AdminGroupPageResponse](docs/AdminGroupPageResponse.md)
 - [AdminGroupResponse](docs/AdminGroupResponse.md)
 - [AdminOverviewResponse](docs/AdminOverviewResponse.md)
 - [AdminOverviewResponseCalls](docs/AdminOverviewResponseCalls.md)
 - [AdminOverviewResponseFiles](docs/AdminOverviewResponseFiles.md)
 - [AdminOverviewResponseGroups](docs/AdminOverviewResponseGroups.md)
 - [AdminOverviewResponseModeration](docs/AdminOverviewResponseModeration.md)
 - [AdminOverviewResponseUsers](docs/AdminOverviewResponseUsers.md)
 - [AdminUserPageResponse](docs/AdminUserPageResponse.md)
 - [AdminUserResponse](docs/AdminUserResponse.md)
 - [AuditLogPageResponse](docs/AuditLogPageResponse.md)
 - [AuditLogResponse](docs/AuditLogResponse.md)
 - [AuthSessionResponse](docs/AuthSessionResponse.md)
 - [CallSessionResponse](docs/CallSessionResponse.md)
 - [ChangePasswordDto](docs/ChangePasswordDto.md)
 - [ConversationSettingResponse](docs/ConversationSettingResponse.md)
 - [CountResponse](docs/CountResponse.md)
 - [CreateCallDto](docs/CreateCallDto.md)
 - [CreateFriendRequestDto](docs/CreateFriendRequestDto.md)
 - [CreateGroupDto](docs/CreateGroupDto.md)
 - [CreateUploadDto](docs/CreateUploadDto.md)
 - [DeactivateAccountDto](docs/DeactivateAccountDto.md)
 - [DeviceSessionResponse](docs/DeviceSessionResponse.md)
 - [ErrorResponse](docs/ErrorResponse.md)
 - [FileDownloadResponse](docs/FileDownloadResponse.md)
 - [FileUploadResponse](docs/FileUploadResponse.md)
 - [FileUsageResponse](docs/FileUsageResponse.md)
 - [ForwardFileDto](docs/ForwardFileDto.md)
 - [FriendResponse](docs/FriendResponse.md)
 - [FriendshipResponse](docs/FriendshipResponse.md)
 - [GroupJoinMessageDto](docs/GroupJoinMessageDto.md)
 - [GroupJoinRequestResponse](docs/GroupJoinRequestResponse.md)
 - [GroupMemberResponse](docs/GroupMemberResponse.md)
 - [GroupResponse](docs/GroupResponse.md)
 - [ImConnectionResponse](docs/ImConnectionResponse.md)
 - [InviteGroupMemberDto](docs/InviteGroupMemberDto.md)
 - [JobRunPageResponse](docs/JobRunPageResponse.md)
 - [JobRunResponse](docs/JobRunResponse.md)
 - [LiveKitTokenResponse](docs/LiveKitTokenResponse.md)
 - [LoginDto](docs/LoginDto.md)
 - [MarkImReadDto](docs/MarkImReadDto.md)
 - [MuteMemberDto](docs/MuteMemberDto.md)
 - [ReceiptMessageDto](docs/ReceiptMessageDto.md)
 - [RefreshTokenDto](docs/RefreshTokenDto.md)
 - [RegisterDto](docs/RegisterDto.md)
 - [ReportUserDto](docs/ReportUserDto.md)
 - [RevokeImMessageDto](docs/RevokeImMessageDto.md)
 - [SetAvatarDto](docs/SetAvatarDto.md)
 - [SetGroupAvatarDto](docs/SetGroupAvatarDto.md)
 - [SetGroupPolicyDto](docs/SetGroupPolicyDto.md)
 - [SetMemberRoleDto](docs/SetMemberRoleDto.md)
 - [SetThumbnailDto](docs/SetThumbnailDto.md)
 - [StoredFileResponse](docs/StoredFileResponse.md)
 - [SuccessResponse](docs/SuccessResponse.md)
 - [SyncImChannelMessagesDto](docs/SyncImChannelMessagesDto.md)
 - [SyncImConversationsDto](docs/SyncImConversationsDto.md)
 - [SyncImReceiptsDto](docs/SyncImReceiptsDto.md)
 - [TransferOwnerDto](docs/TransferOwnerDto.md)
 - [UpdateConversationSettingDto](docs/UpdateConversationSettingDto.md)
 - [UpdateGroupDto](docs/UpdateGroupDto.md)
 - [UpdateProfileDto](docs/UpdateProfileDto.md)
 - [UserResponse](docs/UserResponse.md)


<a id="documentation-for-authorization"></a>
## Documentation For Authorization


Authentication schemes defined for the API:
<a id="access-token"></a>
### access-token

- **Type**: Bearer authentication (JWT)

