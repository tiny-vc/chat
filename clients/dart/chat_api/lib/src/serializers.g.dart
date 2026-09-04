// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(AddGroupMembersDto.serializer)
      ..add(AdminGroupMemberPageResponse.serializer)
      ..add(AdminGroupMemberResponse.serializer)
      ..add(AdminGroupMemberResponseRoleEnum.serializer)
      ..add(AdminGroupMemberResponseStatusEnum.serializer)
      ..add(AdminGroupPageResponse.serializer)
      ..add(AdminGroupResponse.serializer)
      ..add(AdminGroupResponseStatusEnum.serializer)
      ..add(AdminOverviewResponse.serializer)
      ..add(AdminOverviewResponseCalls.serializer)
      ..add(AdminOverviewResponseFiles.serializer)
      ..add(AdminOverviewResponseGroups.serializer)
      ..add(AdminOverviewResponseModeration.serializer)
      ..add(AdminOverviewResponseUsers.serializer)
      ..add(AdminUserPageResponse.serializer)
      ..add(AdminUserResponse.serializer)
      ..add(AdminUserResponseRoleEnum.serializer)
      ..add(AdminUserResponseStatusEnum.serializer)
      ..add(AuditLogPageResponse.serializer)
      ..add(AuditLogResponse.serializer)
      ..add(AuthSessionResponse.serializer)
      ..add(CallSessionResponse.serializer)
      ..add(CallSessionResponseStatusEnum.serializer)
      ..add(CallSessionResponseTypeEnum.serializer)
      ..add(ChangePasswordDto.serializer)
      ..add(ConversationSettingResponse.serializer)
      ..add(ConversationSettingResponseChannelTypeEnum.serializer)
      ..add(CountResponse.serializer)
      ..add(CreateCallDto.serializer)
      ..add(CreateCallDtoTypeEnum.serializer)
      ..add(CreateFriendRequestDto.serializer)
      ..add(CreateGroupDto.serializer)
      ..add(CreateUploadDto.serializer)
      ..add(CreateUploadDtoPurposeEnum.serializer)
      ..add(CreateUploadDtoScopeEnum.serializer)
      ..add(DeactivateAccountDto.serializer)
      ..add(DeviceSessionResponse.serializer)
      ..add(DeviceSessionResponseDeviceTypeEnum.serializer)
      ..add(ErrorResponse.serializer)
      ..add(FileDownloadResponse.serializer)
      ..add(FileUploadResponse.serializer)
      ..add(FileUsageResponse.serializer)
      ..add(ForwardFileDto.serializer)
      ..add(ForwardFileDtoScopeEnum.serializer)
      ..add(FriendResponse.serializer)
      ..add(FriendshipResponse.serializer)
      ..add(FriendshipResponseStatusEnum.serializer)
      ..add(GroupJoinMessageDto.serializer)
      ..add(GroupJoinRequestResponse.serializer)
      ..add(GroupJoinRequestResponseStatusEnum.serializer)
      ..add(GroupJoinRequestResponseTypeEnum.serializer)
      ..add(GroupMemberResponse.serializer)
      ..add(GroupMemberResponseRoleEnum.serializer)
      ..add(GroupMemberResponseStatusEnum.serializer)
      ..add(GroupResponse.serializer)
      ..add(GroupResponseStatusEnum.serializer)
      ..add(ImConnectionResponse.serializer)
      ..add(InviteGroupMemberDto.serializer)
      ..add(JobRunPageResponse.serializer)
      ..add(JobRunResponse.serializer)
      ..add(JobRunResponseStatusEnum.serializer)
      ..add(LiveKitTokenResponse.serializer)
      ..add(LoginDto.serializer)
      ..add(LoginDtoDeviceTypeEnum.serializer)
      ..add(MarkImReadDto.serializer)
      ..add(MarkImReadDtoChannelTypeEnum.serializer)
      ..add(MuteMemberDto.serializer)
      ..add(ReceiptMessageDto.serializer)
      ..add(RefreshTokenDto.serializer)
      ..add(RegisterDto.serializer)
      ..add(RegisterDtoDeviceTypeEnum.serializer)
      ..add(ReportUserDto.serializer)
      ..add(ReportUserDtoReasonEnum.serializer)
      ..add(RevokeImMessageDto.serializer)
      ..add(RevokeImMessageDtoChannelTypeEnum.serializer)
      ..add(SetAvatarDto.serializer)
      ..add(SetGroupAvatarDto.serializer)
      ..add(SetGroupPolicyDto.serializer)
      ..add(SetMemberRoleDto.serializer)
      ..add(SetMemberRoleDtoRoleEnum.serializer)
      ..add(SetThumbnailDto.serializer)
      ..add(StoredFileResponse.serializer)
      ..add(StoredFileResponseScopeEnum.serializer)
      ..add(StoredFileResponseStatusEnum.serializer)
      ..add(SuccessResponse.serializer)
      ..add(SyncImChannelMessagesDto.serializer)
      ..add(SyncImChannelMessagesDtoChannelTypeEnum.serializer)
      ..add(SyncImChannelMessagesDtoPullModeEnum.serializer)
      ..add(SyncImConversationsDto.serializer)
      ..add(SyncImReceiptsDto.serializer)
      ..add(SyncImReceiptsDtoChannelTypeEnum.serializer)
      ..add(TransferOwnerDto.serializer)
      ..add(UpdateConversationSettingDto.serializer)
      ..add(UpdateConversationSettingDtoChannelTypeEnum.serializer)
      ..add(UpdateGroupDto.serializer)
      ..add(UpdateProfileDto.serializer)
      ..add(UserResponse.serializer)
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AdminGroupMemberResponse)]),
          () => ListBuilder<AdminGroupMemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AdminGroupResponse)]),
          () => ListBuilder<AdminGroupResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AdminUserResponse)]),
          () => ListBuilder<AdminUserResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AuditLogResponse)]),
          () => ListBuilder<AuditLogResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GroupMemberResponse)]),
          () => ListBuilder<GroupMemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(JobRunResponse)]),
          () => ListBuilder<JobRunResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ReceiptMessageDto)]),
          () => ListBuilder<ReceiptMessageDto>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => SetBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => SetBuilder<String>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
