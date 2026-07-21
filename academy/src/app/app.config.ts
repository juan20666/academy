import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideClientHydration } from '@angular/platform-browser';
import { ArticleRepository } from './domain/repositories/article.repository';
import { ArticleRepositoryMock } from './infrastructure/mocks/article.repository.mock';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideClientHydration(),
    { provide: ArticleRepository, useClass: ArticleRepositoryMock }
  ]
};
