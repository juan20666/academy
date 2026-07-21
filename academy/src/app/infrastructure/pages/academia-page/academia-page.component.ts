import { CommonModule } from '@angular/common';
import { Component, computed, inject, signal } from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import { AcademyNavItem, AcademyTab, QuickAccessItem } from '../../../domain/models/academy.model';
import { Article } from '../../../domain/models/article.model';
import { GetArticlesUseCase } from '../../../domain/usecases/get-articles.usecase';
import { GetKpisUseCase } from '../../../domain/usecases/get-kpis.usecase';
import { ArticleListItemComponent } from '../../components/article-list-item/article-list-item.component';
import { KpiCardComponent } from '../../components/kpi-card/kpi-card.component';
import { SearchBarComponent } from '../../components/search-bar/search-bar.component';

@Component({
  selector: 'app-academia-page',
  standalone: true,
  imports: [
    CommonModule,
    KpiCardComponent,
    ArticleListItemComponent,
    SearchBarComponent
  ],
  templateUrl: './academia-page.component.html'
})
export class AcademiaPageComponent {

  readonly frequentTags = ['Onboarding', 'Vacaciones', 'LDAP', 'Seguridad', 'Nómina'];

  readonly navItems: AcademyNavItem[] = [
    { id: 'config', label: 'Configuración Administrativa', icon: 'gear' },
    { id: 'academia', label: 'Academia', icon: 'academy', active: true }
  ];

  readonly tabs: AcademyTab[] = [
    { id: 'dashboard', label: 'Dashboard', icon: 'dashboard', active: true },
    { id: 'articulos', label: 'Artículos', icon: 'document' },
    { id: 'categorias', label: 'Categorías', icon: 'folder' },
    { id: 'versiones', label: 'Versiones', icon: 'clock' },
    { id: 'auditoria', label: 'Auditoría', icon: 'activity' }
  ];

  readonly quickAccessItems: QuickAccessItem[] = [
    { id: 'articulos', label: 'Artículos', icon: 'document' },
    { id: 'categorias', label: 'Categorías', icon: 'folder' },
    { id: 'versiones', label: 'Versiones', icon: 'clock' },
    { id: 'auditoria', label: 'Auditoría', icon: 'activity' }
  ];

  isSidebarOpen = signal(false);

  // Inyección de dependencias
  private readonly getKpisUseCase = inject(GetKpisUseCase);
  private readonly getArticlesUseCase = inject(GetArticlesUseCase);

  // Signals
  private readonly kpis = toSignal(
    this.getKpisUseCase.execute(),
    { initialValue: [] }
  );

  private readonly articles = toSignal(
    this.getArticlesUseCase.execute(),
    { initialValue: [] as Article[] }
  );

  readonly kpiCards = computed(() => this.kpis());

  readonly isLoading = computed(() => this.kpis().length === 0);

  readonly topArticles = computed(() =>
    [...this.articles()]
      .sort((a, b) => b.views - a.views)
      .slice(0, 5)
  );

  readonly updates = computed(() =>
    [...this.articles()]
      .sort(
        (a, b) =>
          new Date(b.updatedAt).getTime() -
          new Date(a.updatedAt).getTime()
      )
      .slice(0, 4)
  );

  toggleSidebar(): void {
    this.isSidebarOpen.update(value => !value);
  }
}