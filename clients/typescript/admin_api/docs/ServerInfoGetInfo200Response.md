# ServerInfoGetInfo200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**product** | **string** |  | [default to undefined]
**apiVersion** | **number** |  | [default to undefined]
**name** | **string** |  | [default to undefined]
**registrationEnabled** | **boolean** |  | [default to undefined]
**capabilities** | [**ServerInfoGetInfo200ResponseCapabilities**](ServerInfoGetInfo200ResponseCapabilities.md) |  | [default to undefined]
**uploadLimits** | **{ [key: string]: number; }** |  | [default to undefined]

## Example

```typescript
import { ServerInfoGetInfo200Response } from '@chat/admin-api-client';

const instance: ServerInfoGetInfo200Response = {
    product,
    apiVersion,
    name,
    registrationEnabled,
    capabilities,
    uploadLimits,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
