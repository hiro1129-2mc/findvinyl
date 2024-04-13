require('esbuild').build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outdir: 'app/assets/builds',
  watch: process.argv.includes('--watch'),
}).catch(() => process.exit(1))
