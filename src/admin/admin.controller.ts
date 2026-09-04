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
} from "./dto/admin-list-query.dto";
import { AdminAuditQueryDto } from "./dto/admin-audit-query.dto";
import { AdminJobRunsQueryDto } from "./dto/admin-job-runs-query.dto";

@UseGuards(JwtAuthGuard, AdminGuard)
@Controller("admin")
export class AdminController {
  constructor(
    private readonly service: AdminService,
    private readonly jobs: JobsService,
  ) {}

  @Get("overview")
  overview() {
    return this.service.overview();
  }

  @Get("users")
  listUsers(@Query() query: AdminUserListQueryDto) {
    return this.service.listUsers(query);
  }

  @Get("users/:userId")
  getUser(@Param("userId") userId: string) {
    return this.service.getUser(userId);
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

  @Get("jobs/runs")
  listJobRuns(@Query() query: AdminJobRunsQueryDto) {
    return this.jobs.listRuns(query);
  }

  @Post("jobs/cleanup/run")
  runCleanup() {
    return this.jobs.runCleanup("MANUAL");
  }
}
