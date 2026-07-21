import { Observable } from 'rxjs';
import { Article } from '../models/article.model';
import { Kpi } from '../models/kpi.model';

export abstract class ArticleRepository {
  abstract getKpis(): Observable<Kpi[]>;
  abstract getArticles(): Observable<Article[]>;
}
