import { Routes } from '@angular/router';
import { TokenVerificationComponent } from './components/token-verification/token-verification.component';
import { DemoComponent } from './components/demo/demo.component';

export const routes: Routes = [
    {
    path: '',
    component: TokenVerificationComponent
  },
  {
    path: 'demo',
    component: DemoComponent
  },
  {
    path: '**',
    redirectTo: ''
  }
];
