# AuditLogResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**actorUserId** | **string** |  | [optional] [default to undefined]
**action** | **string** |  | [default to undefined]
**targetType** | **string** |  | [default to undefined]
**targetId** | **string** |  | [default to undefined]
**metadata** | **{ [key: string]: any; }** |  | [optional] [default to undefined]
**createdAt** | **string** |  | [default to undefined]
**actor** | **{ [key: string]: any; }** |  | [optional] [default to undefined]

## Example

```typescript
import { AuditLogResponse } from '@chat/admin-api-client';

const instance: AuditLogResponse = {
    id,
    actorUserId,
    action,
    targetType,
    targetId,
    metadata,
    createdAt,
    actor,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
