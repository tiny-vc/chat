# AuthSessionResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessToken** | **string** |  | [default to undefined]
**refreshToken** | **string** |  | [default to undefined]
**user** | [**UserResponse**](UserResponse.md) |  | [default to undefined]
**im** | [**ImConnectionResponse**](ImConnectionResponse.md) |  | [default to undefined]

## Example

```typescript
import { AuthSessionResponse } from '@chat/admin-api-client';

const instance: AuthSessionResponse = {
    accessToken,
    refreshToken,
    user,
    im,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
