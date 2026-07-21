import { Injectable } from '@angular/core';
import { Observable, delay, of } from 'rxjs';
import { Article } from '../../domain/models/article.model';
import { Kpi } from '../../domain/models/kpi.model';
import { ArticleRepository } from '../../domain/repositories/article.repository';

const MOCK_KPIS: Kpi[] = [
  {
    id: 'total-articles',
    label: 'Total Artículos',
    value: 248,
    helperText: '+12 este mes',
    icon: 'folder'
  },
  {
    id: 'active-categories',
    label: 'Categorías activas',
    value: 34,
    helperText: '7 módulos',
    icon: 'document'
  },
  {
    id: 'published-docs',
    label: 'Documentos publicados',
    value: 34,
    helperText: '76% del total',
    icon: 'globe'
  },
  {
    id: 'pending-review',
    label: 'Pendientes de revisión',
    value: 23,
    helperText: 'Requieren accion',
    icon: 'alert'
  }
];

const MOCK_ARTICLES: Article[] = [
  {
    id: 'art-01',
    title: 'Guía de Onboarding para Nuevos Empleados',
    category: 'Empleados',
    views: 1240,
    status: 'Publicado',
    updatedAt: '2024-05-10'
  },
  {
    id: 'art-02',
    title: 'Catálogo de Beneficios para Empleados 2024',
    category: 'Empleados',
    views: 1120,
    status: 'Publicado',
    updatedAt: '2024-05-02'
  },
  {
    id: 'art-03',
    title: 'Política de Vacaciones y Permisos 2024',
    category: 'Empleados',
    views: 890,
    status: 'Publicado',
    updatedAt: '2024-06-15'
  },
  {
    id: 'art-04',
    title: 'Proceso de Evaluación de Candidatos',
    category: 'Reclutamiento',
    views: 654,
    status: 'Publicado',
    updatedAt: '2024-04-20'
  },
  {
    id: 'art-05',
    title: 'Manual de Gestión de Proyectos Internos',
    category: 'Proyectos',
    views: 478,
    status: 'Publicado',
    updatedAt: '2024-04-02'
  },
  {
    id: 'art-06',
    title: 'Configuración de Notificaciones SMTP',
    category: 'Sistema',
    views: 210,
    status: 'Publicado',
    updatedAt: '2024-06-22'
  },
  {
    id: 'art-07',
    title: 'Guía de Seguridad y Roles del Sistema',
    category: 'Seguridad',
    views: 340,
    status: 'Publicado',
    updatedAt: '2024-06-20'
  },
  {
    id: 'art-08',
    title: 'Manual de Configuración LDAP Empresarial',
    category: 'Seguridad',
    views: 275,
    status: 'Publicado',
    updatedAt: '2024-06-18'
  },
  {
    id: 'art-09',
    title: 'Política de Nómina y Pagos 2024',
    category: 'Nómina',
    views: 190,
    status: 'Pendiente',
    updatedAt: '2024-03-11'
  },
  {
    id: 'art-10',
    title: 'Manual de Inducción para Contratistas',
    category: 'Empleados',
    views: 132,
    status: 'Borrador',
    updatedAt: '2024-02-18'
  }
];

@Injectable({ providedIn: 'root' })
export class ArticleRepositoryMock implements ArticleRepository {
  getKpis(): Observable<Kpi[]> {
    return of(MOCK_KPIS).pipe(delay(500));
  }

  getArticles(): Observable<Article[]> {
    return of(MOCK_ARTICLES).pipe(delay(500));
  }
}
