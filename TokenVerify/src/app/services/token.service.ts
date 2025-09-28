import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, of, throwError } from 'rxjs';
import { delay, map, catchError } from 'rxjs/operators';
import { TokenVerificationResponse, TokenValidationError, NextStep, TourismOption } from '../models/token.model';

@Injectable({
  providedIn: 'root'
})
export class TokenService {
  private readonly apiUrl = 'https://app-turismo.onrender.com/api';
  private readonly messages = {
    success: '¡Tu cuenta ha sido verificada exitosamente! Ya puedes acceder a todas las funcionalidades de TurisApp Colombia.',
    tokenNotFound: 'Token no encontrado en la URL',
    tokenInvalid: 'El token de verificación no es válido o ha expirado'
  };

  constructor(private http: HttpClient) { }

  /**
   * Extrae el token de la URL actual
   */
  extractTokenFromUrl(): string | null {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('token');
  }

  /**
   * Verifica el token con el servidor (simulado)
   */
  verifyToken(token: string): Observable<TokenVerificationResponse> {
    // Simulación de verificación de token
    if (!token) {
      return throwError(() => ({
        type: 'TOKEN_NOT_FOUND',
        message: this.messages.tokenNotFound
      } as TokenValidationError));
    }

    // Validación básica de formato de token
    const tokenPattern = /^[A-Za-z0-9+/=]{20,}$/;
    if (tokenPattern.test(token)) {
      return of({
        success: true,
        message: this.messages.success,
        data: {
          userId: 'demo-user-id',
          email: 'demo@turisapp.com'
        }
      });
    }

    // Token inválido
    return throwError(() => ({
      type: 'TOKEN_INVALID',
      message: this.messages.tokenInvalid
    } as TokenValidationError));
  }

  /**
   * Obtiene los próximos pasos después de la verificación
   */
  getNextSteps(): NextStep[] {
    return [
      {
        icon: 'fa-link',
        text: 'Verifica que el enlace sea correcto'
      },
      {
        icon: 'fa-redo',
        text: 'Intenta registrarte nuevamente si el token ha expirado',
        link: '/register'
      },
      {
        icon: 'fa-headset',
        text: 'Contacta con soporte si el problema persiste',
        link: '/contact'
      }
    ];
  }

  /**
   * Obtiene las opciones de turismo disponibles
   */
  getTourismOptions(): TourismOption[] {
    return [
      {
        title: 'Cartagena',
        description: 'Descubre los mejores hospedajes, restaurantes y precios justos en la Ciudad Heroica.',
        icon: 'fa-building',
        color: '#f59e0b'
      },
      {
        title: 'Coveñas',
        description: 'Explora las hermosas playas de Sucre con recomendaciones confiables y precios transparentes.',
        icon: 'fa-umbrella-beach',
        color: '#06b6d4'
      }
    ];
  }
}