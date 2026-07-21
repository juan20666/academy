import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-search-bar',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
      <p class="text-sm font-semibold text-slate-700">Buscar actividad</p>

      <div class="mt-3 flex flex-col gap-3 lg:flex-row lg:items-center">
        <div class="relative flex-1">
          <svg xmlns="http://www.w3.org/2000/svg" class="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-blue-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="7" />
            <path stroke-linecap="round" d="m20 20-3.5-3.5" />
          </svg>
          <input
            type="text"
            [placeholder]="placeholder"
            [(ngModel)]="query"
            (ngModelChange)="search.emit($event)"
            class="w-full rounded-xl border border-slate-200 py-2.5 pl-9 pr-3 text-sm text-slate-700 placeholder:text-slate-400 focus:border-blue-400 focus:outline-none focus:ring-2 focus:ring-blue-100"
          />
        </div>

        <div class="flex flex-wrap items-center gap-2">
          <span class="text-sm text-slate-500">Frecuentes:</span>
          @for (tag of tags; track tag) {
            <button
              type="button"
              (click)="tagSelected.emit(tag)"
              class="rounded-full border border-slate-200 px-4 py-1.5 text-sm text-slate-600 transition hover:border-blue-300 hover:text-blue-600"
            >
              {{ tag }}
            </button>
          }
        </div>
      </div>
    </div>
  `
})
export class SearchBarComponent {
  @Input() placeholder = 'Buscar por actividad';
  @Input() tags: string[] = [];
  @Output() search = new EventEmitter<string>();
  @Output() tagSelected = new EventEmitter<string>();

  query = '';
}
