Skype Public API for Ruby
=========================

**GitHub:** https://github.com/mscharley/ruby-skype  
**Author:** Matthew Scharley  
**Contributors:** [See contributors on GitHub][gh-contrib]  
**Bugs/Support:** [Github Issues][gh-issues]  
**Copyright:** 2012  
**License:** [MIT license][license]

Synopsis
--------

This library is a binding for the [Skype Public API][skype-api]. Currently,
due to the Skype API being accessed in different ways on different platforms
this library will initially only be supported on Linux/DBus and Windows. The
Skype Public API is a way to hook into the Skype client released by Microsoft
and automate it. To use this library *you must have a copy of the Skype 
client installed locally*. This is not a stand-alone library to access the
Skype network.

**This is very much still under development**

If you want to use this or help out, please feel free to clone/fork and play
with this, but it is prone to break or change at any time.

Installation
------------

For now, you will need to install from the git repository. Simply clone it
to wherever you like and then add it to your include path if needed.

Windows Support
---------------

Window support has been started and is progressing well now. Check out the
`windows` branch on GitHub if you are interested in helping out.

Mac OS X Support
----------------

OS X integration should be possible, however I don't have a Mac to
test/develop with. If you want to help out, then look at the 
`Skype::Communication::*` classes. `Skype::Communication::Protocol` is the
base interface you need to implement. Any help would be greatly appreciated!

Documentation
-------------

There is some documentation about the Skype API itself in the doc folder. The
[ruby-skype API documentation is available online][ruby-skype-rubydoc]. To 
generate them locally, simply clone the library, then run `yard` in the repo 
root. The API documentation will be available in `/doc/api` when complete.

Goals
-----

Generate a Ruby friendly front-end to access the Skype public API.


  [skype-api]: http://developer.skype.com/public-api-reference
  [license]: https://raw.github.com/mscharley/ruby-skype/master/LICENSE
  [ruby-skype-rubydoc]: http://rubydoc.info/github/mscharley/ruby-skype/master/frames
  [gh-contrib]: https://github.com/mscharley/ruby-skype/graphs/contributors
  [gh-issues]: https://github.com/mscharley/ruby-skype/issues

