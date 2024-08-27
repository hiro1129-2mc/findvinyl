const {
  iconsPlugin,
  getIconCollections,
} = require("@egoist/tailwindcss-icons");

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  plugins: [
    require('daisyui'),
    iconsPlugin({
      collections: getIconCollections(["bi", "ion", "majesticons", "ic"]),
    }),
  ],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "rgb(239 68 68)",
          "secondary": "rgb(64 64 64)",
          "accent": "rgb(214 211 209)",
          "neutral": "rgb(24 24 27)",
          "base-100": "rgb(38 38 38)",
          "base-200": "rgb(42, 42, 42)",
        },
      },
    ],
  },
};
