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
      collections: getIconCollections(["bi"]),
    }),
  ],
  daisyui: {
    themes: ["corporate"],
  },
};
