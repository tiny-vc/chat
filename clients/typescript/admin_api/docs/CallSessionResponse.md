# CallSessionResponse


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

## Example

```typescript
import { CallSessionResponse } from '@chat/admin-api-client';

const instance: CallSessionResponse = {
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
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
