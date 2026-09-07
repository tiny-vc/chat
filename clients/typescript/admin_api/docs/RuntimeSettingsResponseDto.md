# RuntimeSettingsResponseDto


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**registrationEnabled** | **boolean** |  | [default to undefined]
**capabilities** | [**RuntimeCapabilitiesDto**](RuntimeCapabilitiesDto.md) |  | [default to undefined]
**messagingPolicy** | [**MessagingPolicySyncDto**](MessagingPolicySyncDto.md) |  | [default to undefined]
**updatedAt** | **string** |  | [default to undefined]

## Example

```typescript
import { RuntimeSettingsResponseDto } from '@chat/admin-api-client';

const instance: RuntimeSettingsResponseDto = {
    registrationEnabled,
    capabilities,
    messagingPolicy,
    updatedAt,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
