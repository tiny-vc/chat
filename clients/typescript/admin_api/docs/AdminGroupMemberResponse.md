# AdminGroupMemberResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**groupId** | **string** |  | [default to undefined]
**userId** | **string** |  | [default to undefined]
**role** | **string** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**nickname** | **string** |  | [optional] [default to undefined]
**mutedUntil** | **string** |  | [optional] [default to undefined]
**joinedAt** | **string** |  | [default to undefined]
**user** | **{ [key: string]: any; }** |  | [default to undefined]

## Example

```typescript
import { AdminGroupMemberResponse } from '@chat/admin-api-client';

const instance: AdminGroupMemberResponse = {
    groupId,
    userId,
    role,
    status,
    nickname,
    mutedUntil,
    joinedAt,
    user,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
