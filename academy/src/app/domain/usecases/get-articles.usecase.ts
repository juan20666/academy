import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Article } from '../models/article.model';
import { ArticleRepository } from '../repositories/article.repository';

@Injectable({ providedIn: 'root' })
export class GetArticlesUseCase {
  constructor(private readonly articleRepository: ArticleRepository) {}

  execute(): Observable<Article[]> {
    return this.articleRepository.getArticles();
  }
}
