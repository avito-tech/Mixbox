## Overview

![Version](https://cocoapod-badges.herokuapp.com/v/MixboxFoundation/badge.png)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
[![Build Status](https://travis-ci.org/avito-tech/Mixbox.svg?branch=master)](https://travis-ci.org/avito-tech/Mixbox)

Code for E2E/Functional/UI/Blackbox testing. It is called Mixbox, because we want to share code across tests of every type (blackbox/greybox/whitebox).

## For English Speakers

English is coming soon.

## Для русскоязычных пользователей

Репозиторий только что выкорчеван из Авито. Есть проект `Demo`, можно посмотреть как коннектить инструмент в приложение. Часть кода не вынесена, так как я еще не придумал как зашарить, например, сервисное приложение для настроек доступа, оно у нас просто как target dependency в основном проекте. Пока еще не вынесена очистка стейта, не особо все хорошо с конфигурацией зависимостей (скорее всего будет Dip и возможности по настройке. Интерфейсы будут меняться (я надеюсь), например, ассерты может быть вынесен из PageObjectElement наружу.

Планы по развитию: в зависимости от реакции сообщества медленно подпиливаем опенсурсную версию инструмента. Фокусируемся конкретно на своих тестах, достигаем максимального качества тестов. Избавляемся от техдолга.

[Почему так много фреймворков](Docs/Frameworks.md)