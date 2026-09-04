# GroupResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**name** | **string** |  | [default to undefined]
**ownerId** | **string** |  | [default to undefined]
**avatarFileId** | **string** |  | [optional] [default to undefined]
**memberLimit** | **number** |  | [default to undefined]
**muteAll** | **boolean** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**members** | [**Array&lt;GroupMemberResponse&gt;**](GroupMemberResponse.md) |  | [optional] [default to undefined]
**createdAt** | **string** |  | [optional] [default to undefined]
**updatedAt** | **string** |  | [optional] [default to undefined]

## Example

```typescript
import { GroupResponse } from '@chat/admin-api-client';

const instance: GroupResponse = {
    id,
    name,
    ownerId,
    avatarFileId,
    memberLimit,
    muteAll,
    status,
    members,
    createdAt,
    updatedAt,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
