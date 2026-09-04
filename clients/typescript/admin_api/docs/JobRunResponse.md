# JobRunResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**jobName** | **string** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**trigger** | **string** |  | [default to undefined]
**metrics** | **{ [key: string]: any; }** |  | [optional] [default to undefined]
**error** | **string** |  | [optional] [default to undefined]
**startedAt** | **string** |  | [default to undefined]
**finishedAt** | **string** |  | [optional] [default to undefined]

## Example

```typescript
import { JobRunResponse } from '@chat/admin-api-client';

const instance: JobRunResponse = {
    id,
    jobName,
    status,
    trigger,
    metrics,
    error,
    startedAt,
    finishedAt,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
