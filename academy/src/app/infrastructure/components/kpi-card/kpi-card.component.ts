import { CommonModule } from '@angular/common';
import { Component, Input } from '@angular/core';
import { Kpi } from '../../../domain/models/kpi.model';

@Component({
  selector: 'app-kpi-card',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div
      class="flex items-center justify-between rounded-2xl border border-slate-100 bg-white p-5 shadow-sm"
    >
      <div>
        <p class="text-3xl font-bold text-slate-800">{{ kpi.value }}</p>
        <p class="mt-1 text-sm font-semibold text-slate-700">{{ kpi.label }}</p>
        <p class="mt-2 text-xs text-slate-400">{{ kpi.helperText }}</p>
      </div>

      <div
        class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl"
        [ngClass]="{
          'bg-violet-100 text-violet-600': kpi.icon === 'folder',
          'bg-blue-100 text-blue-600': kpi.icon === 'document',
          'bg-emerald-100 text-emerald-600': kpi.icon === 'globe',
          'bg-amber-100 text-amber-500': kpi.icon === 'alert'
        }"
      >
        @switch (kpi.icon) {
          @case ('folder') {
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7Z" />
            </svg>
          }
          @case ('document') {
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M7 3h7l5 5v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1Z" />
              <path stroke-linecap="round" stroke-linejoin="round" d="M14 3v5h5" />
            </svg>
          }
          @case ('globe') {
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="9" />
              <path stroke-linecap="round" stroke-linejoin="round" d="M3 12h18M12 3c2.5 2.5 3.8 5.7 3.8 9s-1.3 6.5-3.8 9c-2.5-2.5-3.8-5.7-3.8-9s1.3-6.5 3.8-9Z" />
            </svg>
          }
          @case ('alert') {
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v4m0 4h.01M10.3 4.2 2.9 17a1.5 1.5 0 0 0 1.3 2.3h15.6a1.5 1.5 0 0 0 1.3-2.3L13.7 4.2a1.5 1.5 0 0 0-2.6 0Z" />
            </svg>
          }
        }
      </div>
    </div>
  `
})
export class KpiCardComponent {
  @Input({ required: true }) kpi!: Kpi;
}
