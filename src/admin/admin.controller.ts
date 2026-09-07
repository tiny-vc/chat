import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from "@nestjs/common";
import { AdminGuard } from "../auth/admin.guard";
import { CurrentUser } from "../auth/current-user.decorator";
import { JwtAuthGuard } from "../auth/jwt-auth.guard";
import { JwtPayload } from "../auth/jwt-payload";
import { AdminService } from "./admin.service";
import { SetGroupPolicyDto } from "./dto/set-group-policy.dto";
import { JobsService } from "../jobs/jobs.service";
import {
  AdminGroupListQueryDto,
  AdminGroupMemberListQueryDto,
  AdminUserListQueryDto,
  AdminDeviceListQueryDto,
} from "./dto/admin-list-query.dto";
import { AdminAuditQueryDto } from "./dto/admin-audit-query.dto";
import { AdminJobRunsQueryDto } from "./dto/admin-job-runs-query.dto";
import { AdminCallQueryDto } from "./dto/admin-call-query.dto";
import { AdminFileQueryDto } from "./dto/admin-file-query.dto";
import { AdminReportQueryDto, DecideReportDto } from "./dto/admin-report.dto";
import { SetUserRoleDto } from "./dto/set-user-role.dto";
import { RuntimeSettingsService } from "../config/runtime-settings.service";
import { UpdateRuntimeSettingsDto } from "../config/dto/update-runtime-settings.dto";
import { RuntimeSettingsResponseDto } from "../config/dto/runtime-settings-response.dto";
import { ApiOkResponse } from "@nestjs/swagger";

@UseGuards(JwtAuthGuard, AdminGuard)
@Controller("admin")
export class AdminController {
  constructor(
    private readonly service: AdminService,
    private readonly jobs: JobsService,
    private readonly runtimeSettings: RuntimeSettingsService,
  ) {}

  @Get("overview")
  overview() {
    return this.service.overview();
  }

  @Get("runtime-settings")
  @ApiOkResponse({ type: RuntimeSettingsResponseDto })
  getRuntimeSettings() {
    return this.runtimeSettings.get();
  }

  @Patch("runtime-settings")
  @ApiOkResponse({ type: RuntimeSettingsResponseDto })
  updateRuntimeSettings(
    @CurrentUser() actor: JwtPayload,
    @Body() input: UpdateRuntimeSettingsDto,
  ) {
    return this.runtimeSettings.update(actor.sub, input);
  }

  @Get("users")
  listUsers(@Query() query: AdminUserListQueryDto) {
    return this.service.listUsers(query);
  }

  @Get("users/:userId")
  getUser(@Param("userId") userId: string) {
    return this.service.getUser(userId);
  }

  @Get("users/:userId/devices")
  listUserDevices(
    @Param("userId") userId: string,
    @Query() query: AdminDeviceListQueryDto,
  ) {
    return this.service.listUserDevices(userId, query);
  }

  @Patch("users/:userId/suspend")
  suspendUser(
    @CurrentUser() actor: JwtPayload,
    @Param("userId") userId: string,
  ) {
    return this.service.setUserSuspended(actor.sub, userId, true);
  }

  @Patch("users/:userId/activate")
  activateUser(
    @CurrentUser() actor: JwtPayload,
    @Param("userId") userId: string,
  ) {
    return this.service.setUserSuspended(actor.sub, userId, false);
  }

  @Patch("users/:userId/role")
  setUserRole(
    @CurrentUser() actor: JwtPayload,
    @Param("userId") userId: string,
    @Body() input: SetUserRoleDto,
  ) {
    return this.service.setUserRole(actor.sub, userId, input.role);
  }

  @Delete("users/:userId/devices/:sessionId")
  revokeUserDevice(
    @CurrentUser() actor: JwtPayload,
    @Param("userId") userId: string,
    @Param("sessionId") sessionId: string,
  ) {
    return this.service.revokeUserDevice(actor.sub, userId, sessionId);
  }

  @Get("groups")
  listGroups(@Query() query: AdminGroupListQueryDto) {
    return this.service.listGroups(query);
  }

  @Get("groups/:groupId")
  getGroup(@Param("groupId") groupId: string) {
    return this.service.getGroup(groupId);
  }

  @Get("groups/:groupId/members")
  listGroupMembers(
    @Param("groupId") groupId: string,
    @Query() query: AdminGroupMemberListQueryDto,
  ) {
    return this.service.listGroupMembers(groupId, query);
  }

  @Patch("groups/:groupId/policy")
  setGroupPolicy(
    @CurrentUser() actor: JwtPayload,
    @Param("groupId") groupId: string,
    @Body() input: SetGroupPolicyDto,
  ) {
    return this.service.setGroupPolicy(actor.sub, groupId, input);
  }

  @Get("audit-logs")
  listAuditLogs(@Query() query: AdminAuditQueryDto) {
    return this.service.listAuditLogs(query);
  }

  @Get("calls")
  listCalls(@Query() query: AdminCallQueryDto) {
    return this.service.listCalls(query);
  }

  @Get("files")
  listFiles(@Query() query: AdminFileQueryDto) {
    return this.service.listFiles(query);
  }

  @Get("reports")
  listReports(@Query() query: AdminReportQueryDto) {
    return this.service.listReports(query);
  }

  @Patch("reports/:reportId/decision")
  decideReport(
    @CurrentUser() actor: JwtPayload,
    @Param("reportId") reportId: string,
    @Body() input: DecideReportDto,
  ) {
    return this.service.decideReport(actor.sub, reportId, input);
  }

  @Get("jobs/runs")
  listJobRuns(@Query() query: AdminJobRunsQueryDto) {
    return this.jobs.listRuns(query);
  }

  @Post("jobs/cleanup/run")
  runCleanup() {
    return this.jobs.runCleanup("MANUAL");
  }
}
