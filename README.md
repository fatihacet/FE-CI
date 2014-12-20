FE-CI
=====

Front End Testing and Continuous Integration [![Build Status](https://travis-ci.org/fatihacet/FE-CI.svg?branch=master)](https://travis-ci.org/fatihacet/FE-CI) [![Coverage Status](https://img.shields.io/coveralls/fatihacet/FE-CI.svg)](https://coveralls.io/r/fatihacet/FE-CI?branch=master)

This repo demonstrates how to start a new project using best Test Driven Development techniques plus a CI workflow with code coverage support. The technologies, services and libraries used in this repo is CoffeeScript, Grunt, Jasmine, Karma, IstanbulJS, Coveralls and Travis.

The blog post currently in Turkish but I am planning to post another one in English soon.

----

Bu repo Front End gelistirme surecleri icin test ve CI entegrasyonlarini en iyi yontemlerle (best practice) yapmayi gosteren [suradaki](http://fatihacet.com/fe-ci) blog post'a aittir. Kodu daha iyi anlayabilmek icin blog post'u okumanizi tavsiye ederim.

Bu projede kullanilan teknoloji, library ve servisler ise Grunt, Jasmine, Karma Test Runner, IstanbulJS, Coveralls.io ve Travis CI olacaktir.

Yapilacak islerin listesi ise su sekilde.

* Modul yonetimi icin `package.json`'imizi olusturacagiz.
* Task'larimizi yonetmek icin `Gruntfile.coffee`'imizi olusturacagiz.
* Uygulamamiza ait kodlari yazacagiz.
* JasmineJS ile uygulamamizin testlerini yazacagiz.
* Testlerimizi calistirmak icin Karma Test Runner'i entegre edecegiz.
* IstanbulJS kullanarak kod coverage raporumuzu elde edecegiz.
* Coveralls.io ile coverage durum ve gecmisimiz
* Travis ile CI entegrasyonu saglamis olacagiz.
