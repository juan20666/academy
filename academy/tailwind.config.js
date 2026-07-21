/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{html,ts}'],
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#eef2fb',
          100: '#d9e2f5',
          500: '#2f4a8c',
          600: '#25396b',
          700: '#1c2c54'
        }
      }
    }
  },
  plugins: []
};
