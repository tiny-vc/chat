# ImSyncConversationResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**channel_id** | **string** |  | [default to undefined]
**channel_type** | **number** |  | [default to undefined]
**unread** | **number** |  | [default to undefined]
**timestamp** | **number** |  | [default to undefined]
**last_msg_seq** | **number** |  | [default to undefined]
**last_client_msg_no** | **string** |  | [default to undefined]
**version** | **number** |  | [default to undefined]
**recents** | [**Array&lt;ImSyncMessageResponse&gt;**](ImSyncMessageResponse.md) |  | [default to undefined]

## Example

```typescript
import { ImSyncConversationResponse } from '@chat/admin-api-client';

const instance: ImSyncConversationResponse = {
    channel_id,
    channel_type,
    unread,
    timestamp,
    last_msg_seq,
    last_client_msg_no,
    version,
    recents,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
