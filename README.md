Skype Public API for Ruby
=========================

**GitHub:** https://github.com/mscharley/ruby-skype  
**Author:** Matthew Scharley  
**Contributors:** [See contributors on GitHub][gh-contrib]  
**Bugs/Support:** [Github Issues][gh-issues]  
**Copyright:** 2012  
**License:** [MIT license][license]  
**Status:** *Defunct* - [Skype FAQ explaining in detail][skype-faq]

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

There are also prerelease versions available via `gem` if you want to test
out a stable version, however at this early stage these may not be as useful
as the development version in git. You may install the gem version with

    gem install ruby-skype --pre

Mac OS X Support
----------------

OS X integration should be possible, however I don't have a Mac to
test/develop with. If you want to help out, then look at the 
`Skype::Communication::*` classes. `Skype::Communication::Protocol` is the
base interface you need to implement. See [GH-8][gh-8] for more information. 
Any help would be greatly appreciated!

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
  [ruby-skype-rubydoc]: http://rubydoc.info/github/mscharley/ruby-skype/frames
  [gh-contrib]: https://github.com/mscharley/ruby-skype/graphs/contributors
  [gh-issues]: https://github.com/mscharley/ruby-skype/issues
  [gh-8]: https://github.com/mscharley/ruby-skype/issues/8
  [skype-faq]: https://support.skype.com/en/faq/FA12349/skype-says-my-application-will-stop-working-with-skype-in-december-2013-why-is-that

