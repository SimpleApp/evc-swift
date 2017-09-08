#  Services
A service exposes a coherent set of end-user visible fonctionnalities and their associated data.
## instanciation
* It is instanciated by the engine and exposed through it
* it depends
  * on capabilities, most of the time
  * on other services, when you don't have a choice.

## interface
* it is interacted with *on the main thread* by view controllers

## state
* its behavior may depends on the engine context (background / foreground, production / testing, etc.)
* It owns the application's data for its domain and is responsible for it.

>Hint : assess the size of your data before architecturing your app around a database. One background image occupies around 16MB in memory. A christian bible contains 3 millions characters. There are very good chances that you could keep all your non-graphical data in memory without making any kind of difference.

## misc
* A service is most-often related to a business domain. They are highly dependant on the features for the application, and are very likely not reusable through apps.

>Hint : If you're unsure whether a function should belong to a service or a capabilty, ask yourself whether a (non technical) project manager would have an interesting opinion on what this function should do. If he would, then it belongs to a service.
