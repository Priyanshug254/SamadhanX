import { apiClient, ApiResponse } from './client';
import { Challenge, Domain, TimelineEvent } from '../types';

export interface ChallengeFilterParams {
  domain?: string;
  status?: string;
  severity?: string;
  urgency?: string;
  search?: string;
  page?: number;
  size?: number;
  sortBy?: string;
  sortDirection?: 'ASC' | 'DESC';
}

export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
}

export const challengesApi = {
  getChallenges: async (params?: ChallengeFilterParams): Promise<PageResponse<Challenge>> => {
    const response = await apiClient.get<ApiResponse<PageResponse<Challenge>>>('/api/v1/challenges', {
      params,
    });
    return response.data.data;
  },

  getChallengeById: async (id: string): Promise<Challenge> => {
    const response = await apiClient.get<ApiResponse<Challenge>>(`/api/v1/challenges/${id}`);
    return response.data.data;
  },

  getChallengeTimeline: async (id: string): Promise<TimelineEvent[]> => {
    const response = await apiClient.get<ApiResponse<TimelineEvent[]>>(`/api/v1/challenges/${id}/timeline`);
    return response.data.data;
  },

  getDomains: async (): Promise<Domain[]> => {
    const response = await apiClient.get<ApiResponse<Domain[]>>('/api/v1/domains');
    return response.data.data;
  },

  triageChallenge: async (id: string, decision: string, comments: string): Promise<Challenge> => {
    const response = await apiClient.post<ApiResponse<Challenge>>(`/api/v1/challenges/${id}/triage`, {
      decision,
      comments,
    });
    return response.data.data;
  },

  resolveDepartmental: async (id: string, summary: string, evidenceUrls: string[] = []): Promise<Challenge> => {
    const response = await apiClient.post<ApiResponse<Challenge>>(`/api/v1/challenges/${id}/resolve-departmental`, {
      resolutionSummary: summary,
      resolutionEvidenceUrls: evidenceUrls,
    });
    return response.data.data;
  },

  escalateToInnovation: async (id: string, reason: string, targetDomain?: string): Promise<Challenge> => {
    const response = await apiClient.post<ApiResponse<Challenge>>(`/api/v1/challenges/${id}/escalate-innovation`, {
      reason,
      targetDomain,
      recommendedFundingRange: 'TIER_2_MEDIUM',
    });
    return response.data.data;
  },
};
