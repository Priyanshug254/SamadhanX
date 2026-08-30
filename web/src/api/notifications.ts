import { apiClient, ApiResponse } from './client';

export interface NotificationItem {
  id: string;
  title: string;
  body: string;
  notificationType: string;
  referenceId?: string;
  referenceType?: string;
  read: boolean;
  createdAt: string;
}

export interface ActivityFeedItem {
  id: string;
  eventType: string;
  title: string;
  summary: string;
  referenceCode?: string;
  referenceType?: string;
  actorName?: string;
  timestamp: string;
}

export const notificationsApi = {
  getUserNotifications: async (page = 0, size = 20): Promise<{ content: NotificationItem[]; totalElements: number }> => {
    const res = await apiClient.get<ApiResponse<{ content: NotificationItem[]; totalElements: number }>>(
      `/api/v1/notifications?page=${page}&size=${size}`
    );
    return res.data.data;
  },

  getUnreadCount: async (): Promise<number> => {
    const res = await apiClient.get<ApiResponse<{ unreadCount: number }>>('/api/v1/notifications/unread-count');
    return res.data.data.unreadCount;
  },

  markAsRead: async (id: string): Promise<void> => {
    await apiClient.patch<ApiResponse<void>>(`/api/v1/notifications/${id}/read`);
  },

  markAllAsRead: async (): Promise<void> => {
    await apiClient.patch<ApiResponse<void>>('/api/v1/notifications/read-all');
  },

  getActivityFeed: async (limit = 15): Promise<ActivityFeedItem[]> => {
    const res = await apiClient.get<ApiResponse<ActivityFeedItem[]>>(`/api/v1/notifications/activity-feed?limit=${limit}`);
    return res.data.data;
  },
};
