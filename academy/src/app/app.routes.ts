import { Routes } from '@angular/router';
import { AcademiaPageComponent } from './infrastructure/pages/academia-page/academia-page.component';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'academia' },
  { path: 'academia', component: AcademiaPageComponent }
];
