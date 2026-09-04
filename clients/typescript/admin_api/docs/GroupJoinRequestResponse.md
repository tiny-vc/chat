# GroupJoinRequestResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**groupId** | **string** |  | [default to undefined]
**userId** | **string** |  | [default to undefined]
**requestedById** | **string** |  | [default to undefined]
**decidedById** | **string** |  | [optional] [default to undefined]
**type** | **string** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**message** | **string** |  | [optional] [default to undefined]
**decisionNote** | **string** |  | [optional] [default to undefined]
**expiresAt** | **string** |  | [default to undefined]
**createdAt** | **string** |  | [default to undefined]
**decidedAt** | **string** |  | [optional] [default to undefined]
**group** | [**GroupResponse**](GroupResponse.md) |  | [optional] [default to undefined]
**user** | [**UserResponse**](UserResponse.md) |  | [optional] [default to undefined]

## Example

```typescript
import { GroupJoinRequestResponse } from '@chat/admin-api-client';

const instance: GroupJoinRequestResponse = {
    id,
    groupId,
    userId,
    requestedById,
    decidedById,
    type,
    status,
    message,
    decisionNote,
    expiresAt,
    createdAt,
    decidedAt,
    group,
    user,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
