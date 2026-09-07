# AdminFileResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **string** |  | [default to undefined]
**ownerUserId** | **string** |  | [default to undefined]
**originalName** | **string** |  | [default to undefined]
**mimeType** | **string** |  | [default to undefined]
**sizeBytes** | **string** |  | [default to undefined]
**sha256** | **string** |  | [optional] [default to undefined]
**purpose** | **string** |  | [default to undefined]
**scope** | **string** |  | [default to undefined]
**scopeId** | **string** |  | [optional] [default to undefined]
**status** | **string** |  | [default to undefined]
**thumbnailFileId** | **string** |  | [optional] [default to undefined]
**createdAt** | **string** |  | [default to undefined]
**uploadedAt** | **string** |  | [optional] [default to undefined]
**owner** | **{ [key: string]: any; }** |  | [default to undefined]

## Example

```typescript
import { AdminFileResponse } from '@chat/admin-api-client';

const instance: AdminFileResponse = {
    id,
    ownerUserId,
    originalName,
    mimeType,
    sizeBytes,
    sha256,
    purpose,
    scope,
    scopeId,
    status,
    thumbnailFileId,
    createdAt,
    uploadedAt,
    owner,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
