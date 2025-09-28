import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { AppComponent } from './app/app';

bootstrapApplication(AppComponent, appConfig)
  .catch((err) => {
    console.error('Error al inicializar la aplicación:', err);
    // En producción, considerar enviar el error a un servicio de monitoreo
    document.body.innerHTML = '<h1>Error al cargar la aplicación</h1><p>Por favor, recarga la página.</p>';
  });
