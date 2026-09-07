# AdminReportResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**reporterUserId** | **string** |  | [default to undefined]
**targetUserId** | **string** |  | [default to undefined]
**reason** | **string** |  | [default to undefined]
**details** | **string** |  | [optional] [default to undefined]
**status** | **string** |  | [default to undefined]
**decidedById** | **string** |  | [optional] [default to undefined]
**decisionNote** | **string** |  | [optional] [default to undefined]
**createdAt** | **string** |  | [default to undefined]
**decidedAt** | **string** |  | [optional] [default to undefined]
**reporter** | **{ [key: string]: any; }** |  | [default to undefined]
**target** | **{ [key: string]: any; }** |  | [default to undefined]
**decidedBy** | **{ [key: string]: any; }** |  | [optional] [default to undefined]

## Example

```typescript
import { AdminReportResponse } from '@chat/admin-api-client';

const instance: AdminReportResponse = {
    id,
    reporterUserId,
    targetUserId,
    reason,
    details,
    status,
    decidedById,
    decisionNote,
    createdAt,
    decidedAt,
    reporter,
    target,
    decidedBy,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
