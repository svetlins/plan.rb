plan.rb
-------

WHAT IT IS
----------

Interpreter for a small subset of Scheme written in ruby


REQUIREMENTS
------------
ruby (tested with 1.8.7) and gems:

*   treetop
*   rspec


TRY IT
------

For bearable REPL experience, grab *rlwrap* and run:

    $ rlwrap ./run_repl.rb

It is a tedious experience without *rlwrap* 

Also, multiline input is not handled very well

SOME FEATURES
-------------

It has *call/cc* and a basic infrastructure for tail call elimination

WHAT'S MISSING
--------------

*   standard library (even map, length ...)
*   error reporting - you get mystic Ruby exceptions on invalid input
*   tons of other things
