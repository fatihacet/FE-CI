Front End Testing ve Continuous Integration
=======

*TL;DR*

Bu yazimda Front End gelistirme surecleri icin test ve CI entegrasyonlarini en iyi yontemlerle (best practice) yapmayi gostermek istiyorum.

Kullanilan teknoloji, library ve servisler ise Grunt, Jasmine, Karma Test Runner, IstanbulJS, Coveralls.io ve Travis CI olacak.

Yaziya ait,

* GitHub reposu [buradadir](https://github.com/fatihacet/FE-CI).
* Travis build sayfasi [buradadir](https://travis-ci.org/fatihacet/FE-CI).
* Coveralls kod coverage gecmisi [buradadir](https://coveralls.io/r/fatihacet/FE-CI).
* Repo'yu clone'ladiktan sonra calistirmak icin [suraya](http://github.com/fatihacet/FE-CI) bakabilirsiniz.

------

[Suradaki](https://github.com/fatihacet/spark) kendi repom icin kabaca Grunt, JasmineJS, Karma, IstanbulJS, Coveralls ve Travis stack'inden olusan bir CI (Continuos Integration) workflow'u oturtmustum. [Grunt](http://gruntjs.com/) ile task'lari otomatize ediyorum, [Jasmine](http://jasmine.github.io/) ile testlerimi yaziyorum, [Karma](http://karma-runner.github.io/) ile testlerimi calistiriyorum, [Istanbul](http://gotwarlost.github.io/istanbul/) ile test coverage bilgilerimi cikartiyorum, [Coveralls](https://coveralls.io/) ile coverage yuzdemi ve coverage gecmisini ogreniyorum ve [Travis](travis-ci.org) ile repoma her push ettigim zaman bu islemlerin otomatik olarak tekrar edilmesini ve testlerimin calistirilmasini ve coverage raporunun Coveralls'a gonderilmesini sagliyorum.

Yukardaki workflow'u oturtmak hic kolay olmadi. Cunku bu kadar araci ve servisi entegre edip bir arada calisacagi bir sistem ortaya cikarmak oldukca zahmetli ve ogrenilecek cok materyal iceriyor. Ayrica daha burada belirtmedigim -yazinin konusu ile ilgili olmayan- bir suru baska Grunt task'im daha var. Onlarinda karmasikligi isin icine girince isler bir adim daha zorlasiyor.

Bu yaziyi hem kendime referans olmasi hem de bu kadar bilgiyi paylasmak icin yaziyorum ve oldukca uzun bir yazi olacaga benziyor. Yapacagimiz islerin listesi su sekilde olacak.

* Yeni bir GitHub repo'su olusturacagiz.
* Modul yonetimi icin `package.json`'imizi olusturacagiz.
* Task'larimizi yonetmek icin `Gruntfile.coffee`'imizi olusturacagiz.
* Uygulamamiza ait kodlari yazacagiz.
* JasmineJS ile uygulamamizin testlerini yazacagiz.
* Testlerimizi calistirmak icin Karma Test Runner'i entegre edecegiz.
* IstanbulJS kullanarak kod coverage raporumuzu elde edecegiz.
* Coveralls.io ile coverage durum ve gecmisimiz
* Travis ile CI entegrasyonu saglamis olacagiz.

Bu adimlardan sonra gelistirme ortamimizda dosyalarimizi her kaydettigimiz zaman testlerimizin tekrar calismasini ve repomuza her push ettigimiz zaman testlerimizin baska bir ortamda calismasini saglamis olacagiz.


GitHub uzerinde yeni bir repo olusturduktan sonra ilk adim olarak package.json ile baslayalim.

### package.json

Grunt kullanacagimiz icin [npm](https://www.npmjs.com/) kullanmamiz gerekiyor. Ilk adimimiz npm icin gerekli olan `package.json` olusturmak. Bunun icin en kolay yol calisma dizinimizde `npm init` demek. `npm-init` `package.json`'i olusturmak icin repo'muz hakkinda bir kac soru soracak ve asagidaki `package.json`'i olusturacak. `npm-init` log'unu da [suradaki](https://gist.github.com/fatihacet/ec5dffbc02cacfc7e826) Gist'de gorebilirsiniz.

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

Bu yazidaki ornek kodlar icin CoffeeScript kullanacagim. CoffeScript, JavaScript'e alternatif yazim sekli olan bir dil. Daha kisa, hizli ve anlasilir bir sekilde kod yazmamiza olanak sagliyor. CoffeeScript kullanacagimiz icin Gruntfile'imiz da coffee formatinda olacak. Asagidaki gibi basit ve bos bir `Gruntfile.coffee` olusturalim.

```
module.exports = (grunt) ->

  grunt.initConfig()

  grunt.loadNpmTasks 'grunt-npm'

  grunt.registerTask 'default', 'Default task',->
    grunt.task.run []
```

Gruntfile'imiz hazir olduguna gore test etmek icin calisma dizinimizde `grunt` komutunu calistirmamiz gerekli. Fakat bunu suan yaptigimiz zaman asagidaki gibi bir cikti gorecegiz. Cunku load ettigimiz npm task'ini npm ile yuklemedik.

```
acetz:fe-ci facet$ grunt
>> Local Npm module "grunt-npm" not found. Is it installed?

Running "default" task

Done, without errors.
```

Gruntfile icinde load ettigimiz task'lari `npm install TASK_NAME --save-dev` ile yukleyip `package.json`'imiza otomatik olarak yazilmasini saglayabiliriz. Suan icin bize gerekli olan `grunt-npm`'i yuklemek ve package.json'a kaydetmek icin `npm install grunt-npm --save-dev` dememiz lazim. Asagidaki gibi bir cikti gormemiz gerekiyor.

```
acetz:fe-ci facet$ npm install grunt-npm --save-dev
npm http GET https://registry.npmjs.org/grunt-npm
npm http 304 https://registry.npmjs.org/grunt-npm
grunt-npm@0.0.2 node_modules/grunt-npm
```

Projemiz CoffeeScript ile yazilacagi icin `grunt-contrib-coffee` task'ini yuklememiz gerekiyor. Bunun icin `npm install grunt-contrib-coffee --save-dev` calistirmamiz gerekiyor.

Buraya kadar geldigimizde `package.json`'imiza `--save-dev` kullandigimiz icin su satirlarin `npm` tarafindan eklendigini goruyor olmamiz lazim.

```
  "devDependencies": {
    "grunt-npm": "0.0.2",
    "grunt": "^0.4.5",
    "grunt-contrib-coffee": "^0.12.0"
  }
```

Coffee task'imiz CoffeScript file'larimizi JavaScript'e donusturecek. Fakat bunu yapmasi icin her defasinda bu task'i elle calistirmamiz gerekiyor. Bunu otomatiklestirmek icin bir file watcher task'i kullanmamiz gerekiyor. Bu watcher her file degistigi anda bizim task'larimizi tekrar calistiracak. Task'in adi `grunt-contrib-watch`. Yuklemek icin `npm install grunt-contrib-watch --save-dev` dememiz gerekiyor.

Bu adimdan sonra Gruntfile'imizi configure etmemiz gerekiyor. Projemiz icin gerekli olan kodlarimizi `src` klasoru altina test'lerimizi de `tests` klasoru altina ekleyecegiz. `build` klasorunu ise bizim disimizda otomatik olarak olusturulan dosyalar icin kullanacagiz. `coffee` ve `watch` task'larini bu klasor yapisini kullanarak assagidaki Gist'deki gibi configure ettim.

<script src="https://gist.github.com/fatihacet/95c8de3a057e5d0cca9d.js"></script>


### Uygulama kodu
Buraya kadar repo'muz ile ilgili on hazirliklar tamamladik simdi asil kod yazma islemine basliyoruz.

Bu ornek icin basit bir Box class'i yazdim. `getWidth` `getHeight` `clone` `scale` gibi 4 tane method'u var. Bu Box class'i verdigimiz `top`, `right`, `bottom` ve `left` degerlerine gore o koordinatlarda bir Box olusturacak. Bu yazi icin basit bir class yazip icine 3-5 tane basit method ekleyebilecegim bir ornek dusunuyordum. Aklima Closure Library'nin Box class'i geldi. Onun kucuk ve basit bir ornegini yaptim diyebilirim. Closure Library'de bu Box class'i element'lerin width, height, margin, padding gibi degerlerini hesaplamak icin kullaniliyor. Bizim ornegimizdeki basit Box class'ini asagidak Gist'de gorebilirsiniz.

<script src="https://gist.github.com/fatihacet/1ece4fc516b5dda8b9d7.js"></script>

Asagidaki kodun koordinat duzlemi uzerindeki halini su sekilde olacaktir.

```
new Box
  top    : 200
  right  : 400
  bottom : 400
  left   : 100
```

![http://take.ms/iSzEa](http://take.ms/iSzEa)


### Testlerimiz

Ideal durumda once test'ler sonra kod yazilir. Buna Red to Green Testing diyorlar. Yani once kirmiziyi gor sonra yesile cevir. Kirmizidan kasit fail eden test, yesilden kasit ise pass eden test. Fakat ben bu yazimda tam tersini yapicam. Siz yaptigimi degil dedigimi yapin :)

Test framework'u olarak ben Jasmine tercih ediyorum. Oldukca basit bir API'a sahip, async test yazmak sadece bir function cagirmak kadar kolay. Uzun zamandan beri kullaniyorum, gayet yeterli ve basit oldugunu dusunuyorum.

Box class'imiz icin yazdigim testleri asagidaki Gist'de gorebilirsiniz.

<script src="https://gist.github.com/fatihacet/a8e8ffa62d5ffe32d0c7.js"></script>

### Karma Test Runner

Karma AngularJS takimi tarafindan gelistirilmis bir test runner ve oldukca basarili. Calistirmasi ve yonetmesi gayet kolay. Kendi icinde watcher'i ile geliyor. Farkli browser'larda calistirmak icin sadece browser ismini yazmamiz yeterli oluyor. Biz bu ornekte Grunt icinde kullanacagiz ve Karma watcher'ini kullanmayacagiz.

Oncelikle bir `karma.conf.js`'a ihtiyacimiz var. Ornek bir `karma.conf.js`i asagidaki Gist'de gorebilirsiniz.
<script src="https://gist.github.com/fatihacet/c54b6b3e542aea11da86.js"></script>

Simdi Karma test runner'i Grunt ile entegre etmemiz lazim. Bunun icin once `grunt-karma` paketini yuklememiz gerekiyor. Karma ile testlerimizi PhantomJS ve Chrome browser'inda calistirmayi dusunuyorum. Dolayisiyla Karma PhantomJS ve Chrome launcher'larini da yuklememiz gerekiyor. Ayrica testlerimizi Jasmine ile yazdigimiz icin Karma Jasmine'i de yuklememiz gerekiyor.

```
npm install grunt-karma --save-dev
npm install karma-phantomjs-launcher --save-dev
npm install karma-chrome-launcher --save-dev
npm install karma-jasmine --save-dev
````

Simdi Karma task'imizi `Gruntfile.coffee`'miza eklememiz gerekiyor. Soyle basit bir task aslinda. Tek yaptigimiz sadece config file'imizin yerini soylemek.

```
karma          :
  tests        :
    configFile : 'karma.conf.js'
```

Simdi task'imizi load edelim.

```
grunt.loadNpmTasks 'grunt-karma'
```

Ve son olarak `default` task'imiz icinde `karma` task'imizi calistiralim.

```
grunt.registerTask 'default', 'Default task', ->
  grunt.task.run [
    'coffee'
    'karma'
    'watch'
  ]
```

Buraya kadar gelip terminal'imizde `grunt` calistirdigimiz anda once `coffee` task'imiz calisip CoffeeScript file'larimizi JavaScript'e cevirecek, `karma` task'imiz testlerimizi calistiracak ve `watch` task'imiz ise dosya degisikliklerini dinleyip `coffee` ve `karma` task'larimizi tekrar calistiracak. Sonunda soyle bir cikti gormeyi bekliyoruz.

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

### Istanbul Kod Coverage

Kodumuzu yazdik, testlerimizi de yazdik. Bunlari calistiracak ortamimizi hazirladik. Fakat kodumuzun hangi kisimlarini ne kadari test ettigimizi bilemiyoruz. Bu bilgiye ulasmak ve kodumuzun coverage yuzdesini yukarilara cikarmak icin boyle bir araca ihtiyacimiz var. Ben JavaScript icin en populer kod coverage aracindan biri olan IstanbulJS'i tercih ediyorum. Adi neden Istanbul derseniz, gelistiricisi IstanbulJS'i yazdigi anda butun isimler alinmis, bende halilari ile unlu Istanbul sehrinin ismini sectim demis.

Grunt ve Karma kullanmamiz burada islerimizi cok kolaylastiriyor. `karma-coverage` paketini yukledigimiz zaman `karma.conf.js` icine bir kac satir eklememiz yeterli olacak. Oncelikle `karma-coverage` paketimizi yukleyelim.

```
npm install karma-coverage --save-dev
```

Simdi `karma.conf.js`'imizin icine ekleyecegimiz satirlari gostereyim.

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

Bu satirlari ekledikten sonra `grunt` calistirdigimiz zaman `build/coverage` klasoru icinde kod coverage raporumuzu goruyor olacagiz. Asagidaki gorselde gorebilirsiniz.

![http://take.ms/j9smK](http://take.ms/j9smK)

![http://take.ms/d1eVl](http://take.ms/d1eVl)

![http://take.ms/fOxyH](http://take.ms/fOxyH)


### Travis CI ile Continuous Integration adimi

Sabahtan beri bir Continuous Integration tutturduk gidiyoruz. Ne demek bu Continuous Integration. Ustalar soyle demis.

> Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early.

CI gelistiricilere ortak kullanilan bir repo'ya gunde bir cok kez kod gondermesini saglayan bir gelistirme pratigidir. Her kod gonderimi otomatik bir surecten gecerek dogrulanmasini ve gelistiricilere problemleri erken fark etmesini saglamaktir, seklinde nacizane tercume edeyim.

Bizim CI entegrasyonumuz, kodumuzu GitHub'da host ettigimiz icin, sagolsun GitHub ve Travis tarafindan saglanmis olacak. Biz GitHub'a kod push ettigimiz zaman yada repomuza bir Pull Request geldigi anda Travis'de bir built baslayacak ve Travis bizim kodumuzu cekecek ve testlerimizi calistiracak. Eger testlerimiz patlarsa mail ile bilgilendirecek.

Bunun icin once Travis'e GitHub account'imiz ile login olmamiz gerekiyor. Daha sonrasinda kendi profil sayfanizda repo'larinizi goreceksiniz. Burada repo'nuzu bulup yanindaki toggle'i `ON` yapmaniz gerekiyor.

![http://take.ms/jYBmj](http://take.ms/jYBmj)

Bunu yaptiktan sonra GitHub'a gidip Travis CI'in Webhooks and Services kisminda gorunuyor oldugunu dogrulamamiz lazim.

![http://take.ms/hVVbO](http://take.ms/hVVbO)

Simdi repomuza Travis CI'in anlayacagi bir configure dosyasi eklememiz gerekiyor. Travis bunun icin `.yml` uzantisini tercih etmis. Repo'muzda bir `.travis.yml`'i asagida bulabilirsiniz.

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

Simdi bir repomuza yeni bir push yaptigimiz zaman Travis'in test'lerimizi calistiriyor olmasi gerekiyor. Soyle bir ekran gormeniz lazim.

![http://take.ms/flV4y](http://take.ms/flV4y)

Hatta soyle guzel bir mail almaniz da lazim.

![http://take.ms/yctn2](http://take.ms/yctn2)


Travis benim tercih ettigim CI araci. Travis'e alternatif olarak drone.io, wercker.com gibi araclari da kullanabilirsiniz. Sanirim Travis aralarinda en stabil olani ve digerleri gibi public repo'lar icin ucretsiz.

### Coveralls

Travis ile CI olayimizi da hallettigimize gore son adim, Istanbul adiminda olusturdugumuz kod coverage dosyasini Coveralls'a gondermeyi saglamak ve Coveralls.io'da kod coverage gecmisimizi gormek.

Bunun icin once Coveralls.io'ya GitHub ile login olmaniz lazim. Daha sonra tipki Travis'de yaptigimiz gibi repo'larinizin oldugu sayfada kendi repo'nuzu Coveralls'da aktif hale getirmeniz lazim. Asagidaki gorselde gorebilirsiniz.

![http://take.ms/3fJEk](http://take.ms/3fJEk)

Daha sonrasinda `coveralls` npm paketini yuklemek gerekiyor.

```
npm install coveralls --save-dev
```

Ve son olarak `.travis.yml`'a build bittikten sonra coverage data'mizi Coveralls'a gondermesini soylememiz lazim.

```
after_script:
- cat ./build/coverage/**/lcov.info | ./node_modules/coveralls/bin/coveralls.js
```

Bu asamadan sonra coveralls.io'da soyle bir ekran goruyor olmaniz lazim.

![http://take.ms/khL60](http://take.ms/khL60)


### Build Status ve Coverage badge'lerinin repo'ya eklenmesi

Coveralls'un sayfasindaki `BADGE URLS` linkinden Markdown'u kopyalayalim. Asagidaki gorselde gorebilirsiniz.
![http://take.ms/RTKVH](http://take.ms/RTKVH)

Ve Travis'in sayfasinda da `Build Passing` badge'ine tiklayinca cikan modal'daki Markdown'u kopyalayalim. Asagidaki gorselde gorebilirsiniz.
![http://take.ms/LYJSi](http://take.ms/LYJSi)

Bu islem sonunda [![Build Status](https://img.shields.io/travis/fatihacet/FE-CI.svg)](https://travis-ci.org/fatihacet/FE-CI) ve [![Coverage Status](https://img.shields.io/coveralls/fatihacet/FE-CI.svg)](https://coveralls.io/r/fatihacet/FE-CI?branch=master) seklinde iki tane badge elde ettik. Bu markdown'lari repo'muz icindeki README.md'ye paste edip repo'muzdaki README.md'mizi senlendirebiliriz.

----

Bu blog post'un hakki aslinda 3-4 farkli blog post olmak. Ilerleyen zamanlarda TDD ve BDD hakkinda daha cok yazi yazmak istiyorum. O yazilarda Jasmine ve Karma'ya daha genis deginirim. Fakat bu yazinin da genel olarak guzel bir amaca hizmet ettigini dusunuyorum. Bastan asaga bir entegrasyon yapmis olduk. Yazi altina yorumlarinizi ve [GitHub repo](http://github.com/fatihacet/FE-CI)'suna star, fork ve PR'lerinizi bekliyorum. Hatta hatirlatayim PR gonderirseniz Travis'de bir build baslar, [su](https://travis-ci.org/fatihacet/FE-CI) adrese gidip gorebilirsiniz.

> ccc. şuku matters. ccc.

Baska yazilarda gorusmek uzere, saglicakla...
