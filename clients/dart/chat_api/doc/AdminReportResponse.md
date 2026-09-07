# chat_api_client.model.AdminReportResponse

## Load the model package
```dart
import 'package:chat_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**reporterUserId** | **String** |  | 
**targetUserId** | **String** |  | 
**reason** | **String** |  | 
**details** | **String** |  | [optional] 
**status** | **String** |  | 
**decidedById** | **String** |  | [optional] 
**decisionNote** | **String** |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**decidedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**reporter** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | 
**target** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | 
**decidedBy** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


