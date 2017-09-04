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
* its internal state often depends on the engine context.
* In the no-db architecture, it also owns its set of data, in memory.

## misc
* A service is most-often related to a business domain. They are highly dependant on the features for the application, and are most-often not reusable through apps.
