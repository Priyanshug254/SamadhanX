import { apiClient, ApiResponse } from './client';
import { PageResponse } from './challenges';
import { ProjectTeam, Proposal, ProposalStatus } from '../types';

export const innovationApi = {
  getProposals: async (params?: { page?: number; size?: number; status?: ProposalStatus; challengeId?: string }): Promise<PageResponse<Proposal>> => {
    const response = await apiClient.get<ApiResponse<PageResponse<Proposal>>>('/api/v1/proposals', {
      params,
    });
    return response.data.data;
  },

  getProposalById: async (id: string): Promise<Proposal> => {
    const response = await apiClient.get<ApiResponse<Proposal>>(`/api/v1/proposals/${id}`);
    return response.data.data;
  },

  createProposal: async (data: {
    challengeId: string;
    teamId: string;
    title: string;
    executiveSummary: string;
    technicalApproach: string;
    trlLevel: number;
    budgetRequired: number;
    timelineWeeks: number;
  }): Promise<Proposal> => {
    const response = await apiClient.post<ApiResponse<Proposal>>('/api/v1/proposals', data);
    return response.data.data;
  },

  updateProposalStatus: async (id: string, status: ProposalStatus, comments?: string): Promise<Proposal> => {
    const response = await apiClient.patch<ApiResponse<Proposal>>(`/api/v1/proposals/${id}/status`, {
      status,
      comments,
    });
    return response.data.data;
  },

  getTeamsByChallenge: async (challengeId: string): Promise<ProjectTeam[]> => {
    const response = await apiClient.get<ApiResponse<ProjectTeam[]>>(`/api/v1/teams/challenge/${challengeId}`);
    return response.data.data;
  },

  createTeam: async (name: string, challengeId: string): Promise<ProjectTeam> => {
    const response = await apiClient.post<ApiResponse<ProjectTeam>>('/api/v1/teams', {
      name,
      challengeId,
    });
    return response.data.data;
  },

  inviteMember: async (teamId: string, email: string, roleInTeam: string): Promise<void> => {
    await apiClient.post(`/api/v1/teams/${teamId}/members`, {
      email,
      roleInTeam,
    });
  },
};
