# CallHistoryResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**initiatorUserId** | **string** |  | [default to undefined]
**targetUserId** | **string** |  | [optional] [default to undefined]
**groupId** | **string** |  | [optional] [default to undefined]
**livekitRoomName** | **string** |  | [default to undefined]
**type** | **string** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**startedAt** | **string** |  | [default to undefined]
**answeredAt** | **string** |  | [optional] [default to undefined]
**endedAt** | **string** |  | [optional] [default to undefined]
**endReason** | **string** |  | [optional] [default to undefined]
**outgoing** | **boolean** |  | [default to undefined]
**peer** | [**UserResponse**](UserResponse.md) |  | [default to undefined]

## Example

```typescript
import { CallHistoryResponse } from '@chat/admin-api-client';

const instance: CallHistoryResponse = {
    id,
    initiatorUserId,
    targetUserId,
    groupId,
    livekitRoomName,
    type,
    status,
    startedAt,
    answeredAt,
    endedAt,
    endReason,
    outgoing,
    peer,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
