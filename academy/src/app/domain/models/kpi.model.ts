export type KpiIcon = 'folder' | 'document' | 'globe' | 'alert';

export interface Kpi {
  id: string;
  label: string;
  value: number;
  helperText: string;
  icon: KpiIcon;
}
