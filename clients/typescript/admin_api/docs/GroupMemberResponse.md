# GroupMemberResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**groupId** | **string** |  | [default to undefined]
**userId** | **string** |  | [default to undefined]
**role** | **string** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**mutedUntil** | **string** |  | [optional] [default to undefined]
**joinedAt** | **string** |  | [default to undefined]
**user** | [**UserResponse**](UserResponse.md) |  | [optional] [default to undefined]

## Example

```typescript
import { GroupMemberResponse } from '@chat/admin-api-client';

const instance: GroupMemberResponse = {
    groupId,
    userId,
    role,
    status,
    mutedUntil,
    joinedAt,
    user,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
