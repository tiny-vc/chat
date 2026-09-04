# ErrorResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**statusCode** | **number** |  | [default to undefined]
**code** | **string** |  | [default to undefined]
**message** | **string** |  | [default to undefined]
**details** | **{ [key: string]: any; }** |  | [optional] [default to undefined]
**requestId** | **string** |  | [default to undefined]
**timestamp** | **string** |  | [default to undefined]
**path** | **string** |  | [default to undefined]

## Example

```typescript
import { ErrorResponse } from '@chat/admin-api-client';

const instance: ErrorResponse = {
    statusCode,
    code,
    message,
    details,
    requestId,
    timestamp,
    path,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
