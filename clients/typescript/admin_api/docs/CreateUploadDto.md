# CreateUploadDto


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**fileName** | **string** |  | [default to undefined]
**mimeType** | **string** |  | [default to undefined]
**size** | **number** |  | [default to undefined]
**sha256** | **string** |  | [default to undefined]
**purpose** | **string** |  | [default to undefined]
**scope** | **string** |  | [default to undefined]
**scopeId** | **string** |  | [optional] [default to undefined]

## Example

```typescript
import { CreateUploadDto } from '@chat/admin-api-client';

const instance: CreateUploadDto = {
    fileName,
    mimeType,
    size,
    sha256,
    purpose,
    scope,
    scopeId,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
