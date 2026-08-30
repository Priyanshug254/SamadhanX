import { apiClient, ApiResponse } from './client';

export interface WorkItem {
  id: string;
  title: string;
  description?: string;
  itemType: string;
  status: 'TODO' | 'IN_PROGRESS' | 'BLOCKED' | 'COMPLETED' | 'CANCELLED';
  priority: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  assignedToUserId?: string;
  assignedToName?: string;
  assignedToEmail?: string;
  challengeId?: string;
  challengeTrackingNumber?: string;
  proposalId?: string;
  proposalTrackingNumber?: string;
  dueDate?: string;
  completedAt?: string;
  resolutionNotes?: string;
  overdue: boolean;
  createdAt: string;
}

export interface ApprovalRequest {
  id: string;
  workflowType: string;
  targetEntityId: string;
  targetReferenceCode?: string;
  requestedByUserId: string;
  requestedByName: string;
  reviewedByUserId?: string;
  reviewedByName?: string;
  status: 'PENDING' | 'APPROVED' | 'REJECTED' | 'CHANGES_REQUESTED';
  justification?: string;
  reviewComments?: string;
  previousState?: string;
  targetState?: string;
  reviewedAt?: string;
  createdAt: string;
}

export interface RoleQueueSummary {
  userRole: string;
  myActiveTasksCount: number;
  pendingApprovalsCount: number;
  overdueWorkItemsCount: number;
  criticalActionItemsCount: number;
  highPriorityWorkItems: WorkItem[];
  pendingApprovals: ApprovalRequest[];
}

export interface UnifiedLifecycleStage {
  stageKey: string;
  stageLabel: string;
  status: string;
  timestamp?: string;
  actorRole: string;
  summary: string;
}

export interface UnifiedLifecycleItem {
  id: string;
  stage: string;
  action: string;
  fromState?: string;
  toState?: string;
  actorName: string;
  actorRole: string;
  details?: string;
  timestamp: string;
  isOfficialAction: boolean;
}

export interface UnifiedLifecycleTimeline {
  challengeId: string;
  challengeTrackingNumber: string;
  challengeTitle: string;
  currentStatus: string;
  resolutionPath: string;
  domainName?: string;
  assignedDepartment?: string;
  stages: UnifiedLifecycleStage[];
  auditStream: UnifiedLifecycleItem[];
}

export const governanceApi = {
  getMyTasks: async (): Promise<WorkItem[]> => {
    const res = await apiClient.get<ApiResponse<WorkItem[]>>('/api/v1/work-items/my-tasks');
    return res.data.data;
  },

  getQueueSummary: async (): Promise<RoleQueueSummary> => {
    const res = await apiClient.get<ApiResponse<RoleQueueSummary>>('/api/v1/work-items/queue-summary');
    return res.data.data;
  },

  updateWorkItem: async (
    id: string,
    status: WorkItem['status'],
    resolutionNotes?: string
  ): Promise<WorkItem> => {
    const res = await apiClient.patch<ApiResponse<WorkItem>>(`/api/v1/work-items/${id}`, {
      status,
      resolutionNotes,
    });
    return res.data.data;
  },

  getPendingApprovals: async (): Promise<ApprovalRequest[]> => {
    const res = await apiClient.get<ApiResponse<ApprovalRequest[]>>('/api/v1/governance/approvals/pending');
    return res.data.data;
  },

  reviewApproval: async (
    id: string,
    decision: 'APPROVED' | 'REJECTED' | 'CHANGES_REQUESTED',
    reviewComments?: string
  ): Promise<ApprovalRequest> => {
    const res = await apiClient.post<ApiResponse<ApprovalRequest>>(`/api/v1/governance/approvals/${id}/review`, {
      decision,
      reviewComments,
    });
    return res.data.data;
  },

  getUnifiedLifecycle: async (challengeId: string): Promise<UnifiedLifecycleTimeline> => {
    const res = await apiClient.get<ApiResponse<UnifiedLifecycleTimeline>>(
      `/api/v1/governance/timeline/challenge/${challengeId}`
    );
    return res.data.data;
  },
};
