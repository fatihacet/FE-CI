module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      'build/js/**/*.js',
      'build/tests/**/test_*.js'
    ],
    exclude: [],
    preprocessors: {},
    reporters: ['dots'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['PhantomJS'],
    singleRun: true
  });
};