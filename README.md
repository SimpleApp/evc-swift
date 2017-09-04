# evc-swift
Engine - View - Controller template

## Goal
This project template is meant to be used as a bootstrap for a sane iOS application architecture.

It provides a clean layered architecture aimed at preventing the following bad habits :
* Implicit global state (singletons)
* GUI-oriented design
* Business logic intricated with graphical or technical layers.
* Poorly isolated, not testable components

## Architecture
EVC is just MVC, with emphasis put on the M. Rather than thinking about your app as a GUI first, we encourage the developer to spend a good amount of time to design its model layer first. Because many front-end developer aren't familiar with software architecture, we provide a classical layered architecture template to be used as a starting point.

