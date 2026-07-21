export type ArticleStatus = 'Publicado' | 'Borrador' | 'Pendiente';

export interface Article {
  id: string;
  title: string;
  category: string;
  views: number;
  status: ArticleStatus;
  updatedAt: string;
}
