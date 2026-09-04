# SyncImChannelMessagesDto


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**startMessageSeq** | **number** |  | [optional] [default to 0]
**endMessageSeq** | **number** |  | [optional] [default to 0]
**limit** | **number** |  | [optional] [default to 50]
**channelId** | **string** |  | [default to undefined]
**channelType** | **number** |  | [default to undefined]
**pullMode** | **number** |  | [default to PullModeEnum_NUMBER_0]

## Example

```typescript
import { SyncImChannelMessagesDto } from '@chat/admin-api-client';

const instance: SyncImChannelMessagesDto = {
    startMessageSeq,
    endMessageSeq,
    limit,
    channelId,
    channelType,
    pullMode,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
