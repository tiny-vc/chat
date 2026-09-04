# AdminUserResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**username** | **string** |  | [default to undefined]
**nickname** | **string** |  | [default to undefined]
**avatarUrl** | **string** |  | [optional] [default to undefined]
**avatarFileId** | **string** |  | [optional] [default to undefined]
**status** | **string** |  | [default to undefined]
**role** | **string** |  | [default to undefined]
**revokedSessions** | **number** |  | [optional] [default to undefined]
**createdAt** | **string** |  | [default to undefined]
**updatedAt** | **string** |  | [default to undefined]
**deviceSessions** | **Array&lt;{ [key: string]: any; }&gt;** |  | [optional] [default to undefined]
**_count** | **{ [key: string]: number; }** |  | [optional] [default to undefined]

## Example

```typescript
import { AdminUserResponse } from '@chat/admin-api-client';

const instance: AdminUserResponse = {
    id,
    username,
    nickname,
    avatarUrl,
    avatarFileId,
    status,
    role,
    revokedSessions,
    createdAt,
    updatedAt,
    deviceSessions,
    _count,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
