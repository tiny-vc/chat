# AdminOverviewResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**generatedAt** | **string** |  | [default to undefined]
**users** | [**AdminOverviewResponseUsers**](AdminOverviewResponseUsers.md) |  | [default to undefined]
**groups** | [**AdminOverviewResponseGroups**](AdminOverviewResponseGroups.md) |  | [default to undefined]
**files** | [**AdminOverviewResponseFiles**](AdminOverviewResponseFiles.md) |  | [default to undefined]
**calls** | [**AdminOverviewResponseCalls**](AdminOverviewResponseCalls.md) |  | [default to undefined]
**moderation** | [**AdminOverviewResponseModeration**](AdminOverviewResponseModeration.md) |  | [default to undefined]

## Example

```typescript
import { AdminOverviewResponse } from '@chat/admin-api-client';

const instance: AdminOverviewResponse = {
    generatedAt,
    users,
    groups,
    files,
    calls,
    moderation,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
