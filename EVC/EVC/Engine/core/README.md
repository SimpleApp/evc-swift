#  Engine
Engine is the motherboard of all the components required to perform the application's functions.

## instanciation
* It is instanciated by the app delegate when the application launches.
* Can be configured at initialisation depending on the environment (application extensions, watch app, staging environment, etc. )

## interface
* it has public functions meant to inform components about a context change (foreground, notification, etc.)
* it exposes the services to the containing application.


## state
* its internal state is composed of all the capabilities, middlewares and services for the application.
* it also has a context, which is forwarded to all its components.

## misc
* Reference to the engine is passed from view controller to view controller.
* *Please, do NOT create an engine's singleton or manager, or whatever name you give to a global variable. Global state is your enemy.*
