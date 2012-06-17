Skype Public API for Ruby
=========================

This library is a binding for the [Skype Public API][skype-api]. Currently,
due to the Skype API being accessed in different ways on different platforms
this library will initially only be supported on Linux/DBus.

**This is very much still under development**

If you want to use this or help out, please feel free to clone/fork and play
with this, but it is prone to break or change at any time.

Installation
------------

For now, you will need to install from the git repository. Simply clone it
to wherever you like and then add it to your include path if needed.

Windows Support
---------------

Windows support has been attempted, but isn't functional. If you would like
to help, then please look at the windows and windows-dl branches and see if
you can get them running.

Documentation
-------------

There is some documentation about the Skype API itself in the doc folder. The
ruby-skype API documentation is not available online currently, however we
use YARD and have a .yardopts file in the repo for easy generation. Simply
clone the library, then run `yard` in the repo root. The API documentation
will be available in `/doc/api` when complete.

License
-------

This project is released under [an MIT license][license].

Goals
-----

Generate a Ruby friendly front-end to access the Skype public API.

  [skype-api]: http://developer.skype.com/public-api-reference
  [license]: https://raw.github.com/mscharley/ruby-skype/master/LICENSE
