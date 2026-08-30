import { apiClient, ApiResponse } from './client';
import { AuthResponse, User } from '../types';

export const authApi = {
  login: async (email: string, password: string): Promise<AuthResponse> => {
    const response = await apiClient.post<ApiResponse<AuthResponse>>('/api/v1/auth/login', {
      email,
      password,
    });
    return response.data.data;
  },

  getCurrentUser: async (): Promise<User> => {
    const response = await apiClient.get<ApiResponse<User>>('/api/v1/users/me');
    return response.data.data;
  },
};
