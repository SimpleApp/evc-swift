#  Capabilities

A capability deals with low-level, technical functionnalities, very often related to I/O.
## instanciation
* it is instanciated by the engine, and kepts hidden from the outside.
* it is injected to services as dependencies, by the engine.

## interface
* its public interface understands application-defined types and models (and not just basic types)
* its exposed interface *may* be designed to work on a background thread, but most often isn't.
* it very often calls to and handles callback from a background thread.

## state
* A capability should have minimal state, except for context-related configuration
* most often than not, a capability's state is transient (go away when the app stops)

## misc
* capabilities *may* be reused between different apps, but application-specific types will need to be updated.
* capabilities are very often mocked in service unit-tests.
