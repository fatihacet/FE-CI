Front End Testing and Continuous Integration
=======

*TL;DR*

This blog post will be about integrating Continuous Integration workflow into a Front End project with using best practices. In this blog post I will use the following technology, library and services which are Grunt, Jasmine, Karma Test Runner, IstanbulJS, Coveralls.io and Travis CI.

Here is the resources about the post,

* [GitHub repository](https://github.com/fatihacet/FE-CI)
* [Travis build history](https://travis-ci.org/fatihacet/FE-CI)
* [Coveralls coverage history](https://coveralls.io/r/fatihacet/FE-CI)
* [Up and Running details](http://github.com/fatihacet/FE-CI)

------

A few months ago I created my automated CI and testing workflow for my project [here](https://github.com/fatihacet/spark). I was using [Grunt](http://gruntjs.com/) to automate my tasks, [Jasmine](http://jasmine.github.io/) to write my tests, [Karma](http://karma-runner.github.io/) to run my tests, [Istanbul](http://gotwarlost.github.io/istanbul/) to learn my coverage information, [Coveralls](https://coveralls.io/) to create good looking coverage history and [Travis](travis-ci.org) to automate my builds. Every push triggers a new build on Travis and does all thing above again.

It seems like this blog post will be a long one. Here is steps we will do.


* Create a new GitHub repo.
* Create a `package.json` to have our packages.
* Create a `Gruntfile.coffee` and include our tasks.
* Then we write some code to.
* Write our tests with JasmineJS.
* Integrate Karma Test Runner.
* Integrate IstanbulJS to create coverage reports.
* Integrate [coveralls.io](coveralls.io) coverage service to have fancy coverage reports.
* And finally enable [Travis CI](travis-ci.org).

After doing all of those work above we will have a fully automated development environment with test and CI supported. Our builds will be also automated and our tests will work in a different machine.

So to get started, let's create a GitHub repository then create our `package.json`.


### package.json

We will use Grunt so we need to use [npm](https://www.npmjs.com/). Very first step is creating a `package.json`. The easiest way to do is running `npm init` in our working directory. Then npm will ask a few questions and it will create our `package.json`. [Here](https://gist.github.com/fatihacet/ec5dffbc02cacfc7e826) you can see a Gist with the log of `npm-init`. Also our very first `package.json` will be something like that. 

```
{
  "name": "FE-CI",
  "version": "0.0.1",
  "description": "Front End Testing and Continuous Integration",
  "main": "index.js",
  "scripts": {
    "test": ""
  },
  "repository": {
    "type": "git",
    "url": "git://github.com/fatihacet/fe-ci.git"
  },
  "keywords": [ "front-end-testing", "continuous-integration", "ci", "grunt", "karma", "jasmine", "istanbul", "coveralls", "travis-ci"
  ],
  "author": "Fatih Acet",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/fatihacet/fe-ci/issues"
  },
  "homepage": "https://github.com/fatihacet/fe-ci",
  "devDependencies": {
  }
}
```

### Gruntfile.coffee

I will use CoffeeScript so our Gruntfile will be written in CoffeeScript. Here is our initial `Gruntfile.coffee`.

```
module.exports = (grunt) ->

  grunt.initConfig()

  grunt.loadNpmTasks 'grunt-npm'

  grunt.registerTask 'default', 'Default task',->
    grunt.task.run []
```

To test our initial Gruntfile we need to run `grunt` in our working directory. When you do that you will see an error like that.

```
acetz:fe-ci facet$ grunt
>> Local Npm module "grunt-npm" not found. Is it installed?

Running "default" task

Done, without errors.
```

This is because we tried to load the task but we didn't install it yet. Installing a task is easy. We need to run `npm install TASK_NAME --save-dev`. `--save-dev` part will also update our `package.json` to inlcude that package. Let's install `grunt-npm`. 

```
npm install grunt-npm --save-dev
```

And we will see a log like this.

```
acetz:fe-ci facet$ npm install grunt-npm --save-dev
npm http GET https://registry.npmjs.org/grunt-npm
npm http 304 https://registry.npmjs.org/grunt-npm
grunt-npm@0.0.2 node_modules/grunt-npm
```

Our project code will be written in CoffeeScript so we need to install `grunt-contrib-coffee`. Let's do it.

```
npm install grunt-contrib-coffee --save-dev
```


Now we should see the following lines are already added to our `package.json` because we used `--save-dev`. 

```
  "devDependencies": {
    "grunt-npm": "0.0.2",
    "grunt": "^0.4.5",
    "grunt-contrib-coffee": "^0.12.0"
  }
```


`coffee` task will compile our JavaScript files to CoffeeScript. But currently we have to run `grunt` manually. We need a file watcher to automate running `coffee` task when our source code changed. So let's add Grunt file watcher to our Gruntfile.

```
npm install grunt-contrib-watch --save-dev
```

That's nice. We have coffee and watch tasks but we need some configuration thing. First let me give talk about the folder structure a bit. We will put our codes into a `src` folder and out tests into `tests` folder. We will use `build` folder to store the files created by Grunt. Below you can see a Gruntfile which configured to use the file structure above. 

<script src="https://gist.github.com/fatihacet/95c8de3a057e5d0cca9d.js"></script>


### Our Application Code 

We made our preparation and it's time to write some code. I created a Box class and implemented `getWidth` `getHeight` `clone` `scale` methods. This Box class will create a box representation with given `top`, `right`, `bottom` and `left` values. I got the idea from Google's Closure Library. This Box class is a small subset of `goog.Math.Box`. They are using it to calculate width, heigt, margin and paddings of the elements. 

You can see our simple Box class here.

<script src="https://gist.github.com/fatihacet/1ece4fc516b5dda8b9d7.js"></script>

Here is a representation of our Box.

```
new Box
  top    : 200
  right  : 400
  bottom : 400
  left   : 100
```

![http://take.ms/iSzEa](http://take.ms/iSzEa)


### Tests

Ideally, it's a better practice to write tests first then code. It's Red to Green Testing. This means see the red then make it green. Red means test is failing green means test works fine. You know, we already wrote our app code and we will write our test now. But you don't do what I did, do what I say :)

I prefer JasmineJS as my testing framework. It has a pretty simple API and making a test asynchronous is just about calling a method which named `done`. I used it almost one and half year and I can easily say Jasmine does what it offer.

Here is our tests written for our Box class.

<script src="https://gist.github.com/fatihacet/a8e8ffa62d5ffe32d0c7.js"></script>

### Karma Test Runner

Karma is a great test runner written by AngularJS Team. It's awesome and it's easy to use and configure. It comes with a built-in file watcher but we won't use it because we already implemented a file watcher in our Gruntfile.

We need a `karma.conf.js`. Below you can see a `karma.conf.js` in the following Gist.

<script src="https://gist.github.com/fatihacet/c54b6b3e542aea11da86.js"></script>

We have a `karma.conf.js` now and we need to integrate it with Grunt. To do so, we need to install `grunt-karma` package. I am planning to run our tests with PhantomJS and Google Chrome. So we need to install those for Karma. Also one last thing is Jasmine for Karma. Let's install them.

```
npm install grunt-karma --save-dev
npm install karma-phantomjs-launcher --save-dev
npm install karma-chrome-launcher --save-dev
npm install karma-jasmine --save-dev
````

Now let's add our karma task into our `Gruntfile.coffee`. It's damn simple btw, all we need to tell Karma where is our config file.

```
karma          :
  tests        :
    configFile : 'karma.conf.js'
```

And load the task.

```
grunt.loadNpmTasks 'grunt-karma'
```

And add our `karma` task into our `default` task.

```
grunt.registerTask 'default', 'Default task', ->
  grunt.task.run [
    'coffee'
    'karma'
    'watch'
  ]
```

At this point, if we run `grunt` in our command line here is what will happen. Our `coffee` task will compile CoffeeScript files to JavaScript. `karma` task will run our tests and `watch` task will listen for file changes and run `coffee` and `karma` tasks when a file change happened.

Here is a sample output.

```
acetz:fe-ci facet$ grunt
Running "default" task

Running "coffee:src" (coffee) task
>> 1 files created.

Running "coffee:tests" (coffee) task
>> 1 files created.

Running "karma:tests" (karma) task
INFO [karma]: Karma v0.12.28 server started at http://localhost:9876/
INFO [launcher]: Starting browser PhantomJS
INFO [PhantomJS 1.9.8 (Mac OS X)]: Connected on socket 3lBTlIgNmRlo9kBaPnzW with id 9367162
......
PhantomJS 1.9.8 (Mac OS X): Executed 6 of 6 SUCCESS (0.002 secs / 0.002 secs)
......
Chrome 39.0.2171 (Mac OS X 10.10.0): Executed 6 of 6 SUCCESS (0.027 secs / 0.01 secs)
TOTAL: 12 SUCCESS

Running "watch" task
Waiting...
```

### Istanbul Code Coverage

We wrote our code and test. We implemented an environment to run them but we actually don't know which part of our code is coverage by our tests. To know that and create coverage report we need a tool which do that. As far as I know, Istanbul is one the best coverage tool for JavaScript. Using a coverage tool is great because it will encourage you to write more test to cover all lines of your app code.

By the way, it's also great for me to use a tool named Istanbul while I am writing this blog post from Istanbul :) If you wonder where the name comes from, it's about the beautiful carpets of Istanbul. That's very clever, tho :)

Integrating Istanbul into our workflow is really easy for us because we are using Grunt and Karma. We need to install `karma-coverage` package and configure our `karma.conf.js` 

Let's start with installing `karma-coverage`

```
npm install karma-coverage --save-dev
```

Now add the following lines into our `karma.conf.js` to configure it.  

```
preprocessors: {
  'build/tests/**/*.js': ['coverage']
},
reporters: ['dots', 'coverage'],
coverageReporter: {
  type: 'lcov',
  dir: 'build/coverage/'
}

```

In this point when we run `grunt` we should see our coverage report in our `build` folder. Here is a few screenshots to understand it better.

![http://take.ms/j9smK](http://take.ms/j9smK)

![http://take.ms/d1eVl](http://take.ms/d1eVl)

![http://take.ms/fOxyH](http://take.ms/fOxyH)


### Continuous Integration with Travis CI

We are talking about Continuous Integration for a while. But what is that Continuous Integration? 

> Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early.

We will use GitHub to integrate Travis CI. Thanks GitHub to their awesome Travis integration. When we push code to our repo hosted in GitHub or someone send a Pull Request to our repo a build will be triggered in Travis and GitHub will know the build status.

To integrate Travis with GitHub, we need to login to Travis with our GitHub account. Then in our profile page we need to find our repo which we want to enable in Travis and toggle it to `ON` state. Here is the screenshot.

![http://take.ms/jYBmj](http://take.ms/jYBmj)

After doing that, we should see Travis CI enabled at GitHub under Webhooks and Services section.

![http://take.ms/hVVbO](http://take.ms/hVVbO)

Now we need to add a configuration file into our repo which Travis will use. It should be in `yml` and named `.travis.yml`. Here is the example `.travis.yml`.

```
language: node_js
node_js:
- '0.10'
install:
- npm -d install
- npm install -g grunt-cli
- npm install -g grunt
script:
- grunt ci
```

When we push some commit into our repo a build should be triggered in Travis. Travis will fetch our code and run our tests. We need to see a page like this in Travis.

![http://take.ms/flV4y](http://take.ms/flV4y)

Also you should get a good looking mail like that.

![http://take.ms/yctn2](http://take.ms/yctn2)

By the way, I choose Travis as my CI tool but you may want to give chance to [drone.io](drone.io) or [wercker.com](wercker.com). But I think Travis is the most stable. Also all of them is free for public repositories.

### Coveralls

We integrated Travis into our workflow not the last step is send our coverage report we generated with IstanbulJS after a Travis build succeed. Then Coveralls will provide us some gorgeous reports and history.

We need to login [coveralls.io](coveralls.io) with our GitHub account. Then we need to enable our repo in Coveralls like we did in Travis step. Here is the screenshot.

![http://take.ms/3fJEk](http://take.ms/3fJEk)


Now let's install `coveralls` npm package. 

```
npm install coveralls --save-dev
```

And one last thing to do is tell Travis to push our coverage data to Coveralls. Add the following line into our `.travis.yml`.

```
after_script:
- cat ./build/coverage/**/lcov.info | ./node_modules/coveralls/bin/coveralls.js
```

At his point we should see a page like this in coveralls.io. This means all is set and working good.

![http://take.ms/khL60](http://take.ms/khL60)


### Adding Build Status and Coverage badges into README.md in our repo

For build status badge, click the `Build Passing` badge in Travis page and copy the Markdown snippet. Here is the screenshot.

![http://take.ms/LYJSi](http://take.ms/LYJSi)

For coverage information badge, copy Markdown snippet in Coveralls page using `BADGE URLS` button. Here is the screenshot. 

![http://take.ms/RTKVH](http://take.ms/RTKVH)

By doing that, now we have [![Build Status](https://img.shields.io/travis/fatihacet/FE-CI.svg)](https://travis-ci.org/fatihacet/FE-CI) and [![Coverage Status](https://img.shields.io/coveralls/fatihacet/FE-CI.svg)](https://coveralls.io/r/fatihacet/FE-CI?branch=master) badges. 

You can add those badges into your README.md to make in fancier.

----

You may think steps are passed so quickly, not explained well and it would be better if I made them more detailed. Actually I am agree with that. But this blog post covers all the steps so I think it will you give an overall idea to create a workflow from the beginning. 

Please add your comments, let me know what you think and star or fork and send Pull Request to the blog post repo which is [here](http://github.com/fatihacet/FE-CI). Remember if you submit a Pull Request you should see a build triggered in Travis by going [this page](https://travis-ci.org/fatihacet/FE-CI) in Travis.

> Sharing is caring.


See you with other English posts.
