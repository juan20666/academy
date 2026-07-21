import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Kpi } from '../models/kpi.model';
import { ArticleRepository } from '../repositories/article.repository';

@Injectable({ providedIn: 'root' })
export class GetKpisUseCase {
  constructor(private readonly articleRepository: ArticleRepository) {}

  execute(): Observable<Kpi[]> {
    return this.articleRepository.getKpis();
  }
}
