export interface TokenVerificationResponse {
  success: boolean;
  message: string;
  data?: {
    userId: string;
    email: string;
  };
}

export interface TokenValidationError {
  type: 'TOKEN_NOT_FOUND' | 'TOKEN_EXPIRED' | 'TOKEN_INVALID' | 'NETWORK_ERROR';
  message: string;
}

export interface NextStep {
  icon: string;
  text: string;
  link?: string;
}

export interface TourismOption {
  title: string;
  description: string;
  icon: string;
  color: string;
}