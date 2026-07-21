import { CommonModule } from '@angular/common';
import { Component, Input } from '@angular/core';
import { Article } from '../../../domain/models/article.model';

export type ArticleListItemMode = 'ranked' | 'update';

@Component({
  selector: 'app-article-list-item',
  standalone: true,
  imports: [CommonModule],
  template: `
    @if (mode === 'ranked') {
      <div class="flex items-center justify-between gap-4 border-b border-slate-100 px-6 py-4 last:border-b-0">
        <div class="flex items-center gap-4">
          <span class="text-sm font-semibold text-slate-400">{{ position }}</span>
          <div>
            <p class="text-sm font-semibold text-slate-800">{{ article.title }}</p>
            <p class="mt-0.5 text-xs text-slate-400">{{ article.category }} · {{ article.views }} vistas</p>
          </div>
        </div>
        <span class="shrink-0 rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1 text-xs font-medium text-emerald-600">
          {{ article.status }}
        </span>
      </div>
    } @else {
      <div class="border-b border-slate-100 px-6 py-4 last:border-b-0">
        <p class="text-sm font-semibold text-slate-800">{{ article.title }}</p>
        <p class="mt-0.5 text-xs text-slate-400">{{ article.updatedAt }}</p>
      </div>
    }
  `
})
export class ArticleListItemComponent {
  @Input({ required: true }) article!: Article;
  @Input() mode: ArticleListItemMode = 'ranked';
  @Input() position?: number;
}
