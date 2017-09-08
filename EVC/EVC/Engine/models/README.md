#  Models
This folder contains the types used throughout your application. We encourage using structs instead of classes as well as message-passing style communication between components rather than reference sharing.

Logic (such as validation rules or state transition functions) should not be written in those structs, but in the corresponding services instead. That is, don't write user.isValid(). Write userService.isValid(user) instead. This will let you evolve those rules easily.
