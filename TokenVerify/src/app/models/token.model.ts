export interface TokenVerificationResponse {
  success: boolean;
  message: string;
  data?: {
    userId: string;
    email: string;
  };
}

export interface PasswordResetResponse {
  success: boolean;
  message: string;
  data?: any;
}

export interface TokenValidationError {
  type: 'TOKEN_NOT_FOUND' | 'TOKEN_EXPIRED' | 'TOKEN_INVALID' | 'NETWORK_ERROR';
  message: string;
}

export interface PasswordResetRequest {
  token: string;
  newPassword: string;
}

export interface EmailVerificationRequest {
  token: string;
}

export type TokenType = 'email-verification' | 'password-reset';

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