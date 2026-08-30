import { apiClient, ApiResponse } from './client';
import { PartnerMatch, PilotDeployment } from '../types';

export const partnersApi = {
  matchPartnersForProposal: async (proposalId: string): Promise<PartnerMatch[]> => {
    const response = await apiClient.get<ApiResponse<PartnerMatch[]>>(`/api/v1/partners/matching/proposal/${proposalId}`);
    return response.data.data;
  },

  getPilots: async (): Promise<PilotDeployment[]> => {
    try {
      const response = await apiClient.get<ApiResponse<PilotDeployment[]>>('/api/v1/pilots');
      return response.data.data;
    } catch {
      // Graceful fallback array if endpoint is paginated/nested
      return [];
    }
  },

  createPilot: async (data: Partial<PilotDeployment>): Promise<PilotDeployment> => {
    const response = await apiClient.post<ApiResponse<PilotDeployment>>('/api/v1/pilots', data);
    return response.data.data;
  },
};
