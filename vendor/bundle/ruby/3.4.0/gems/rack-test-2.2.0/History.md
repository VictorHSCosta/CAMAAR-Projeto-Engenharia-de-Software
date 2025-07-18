## 2.2.0 / 2024-12-23

* Bug fixes:
  * `Rack::Test::Cookie` now parses cookie parameters using a
    case-insensitive approach (Guillaume Malette #349)

* Minor enhancements:
  * Arrays of cookies containing a blank cookie are now handled
    correctly when processing responses.  (Martin Emde #343)
  * `Rack::Test::UploadedFile` no longer uses a finalizer for named
    paths to close and unlink the created Tempfile.  Tempfile itself
    uses a finalizer to close and unlink itself, so there is no
    reason for `Rack::Test::UploadedFile` to do so (Jeremy Evans #338)

## 2.1.0 / 2023-03-14

* Breaking changes:
  * Digest authentication support, deprecated in 2.0.0, has been
    removed (Jeremy Evans #307)
  * requiring rack/mock_session, deprecated in 2.0.0, has been removed
    (Jeremy Evans #307)

* Minor enhancements:
  * The `original_filename` for `Rack::Test::UploadedFile` can now be
    set even if the content of the file comes from a file path
    (Stuart Chinery #314)
  * Add `Rack::Test::Session#restore_state`, for executing a block
    and restoring current state (last request, last response, and
    cookies) after the block (Jeremy Evans #316)
  * Make `Rack::Test::Methods` support `default_host` method similar to
    `app`, which will set the default host used for requests to the app
    (Jeremy Evans #317 #318)
  * Allow responses to set cookie paths not matching the current
    request URI. Such cookies will only be sent for paths matching
    the cookie path (Chris Waters #322)
  * Ignore leading dot for cookie domains, per RFC 6265 (Stephen Crosby
    #329)
  * Avoid creating empty multipart body if params is empty in
    `Rack::Test::Session#env_for` (Ryunosuke Sato #331)

## 2.0.2 / 2022-06-28

* Bug fixes:
  * Fix additional incompatible character encodings error when building
    uploaded bodies (Jeremy Evans #311)

## 2.0.1 / 2022-06-27

* Bug fixes:
  * Fix incompatible character encodings error when building uploaded
    file bodies (Jeremy Evans #308 #309)

## 2.0.0 / 2022-06-24

* Breaking changes:
  * Digest authentication support is now deprecated, as it relies on
    digest authentication support in rack, which has been deprecated
    (Jeremy Evans #294)
  * `Rack::Test::Utils.build_primitive_part` no longer handles array
    values (Jeremy Evans #292)
  * `Rack::Test::Utils` module methods other than `build_nested_query`
    and `build_multipart` are now private methods (Jeremy Evans #297)
  * `Rack::MockSession` has been combined into `Rack::Test::Session`,
    and remains as an alias to `Rack::Test::Session`, but to keep some
    backwards compatibility, `Rack::Test::Session.new` will accept a
    `Rack::Test::Session` instance and return it (Jeremy Evans #297)
  * Previously protected methods in `Rack::Test::Cookie{,Jar}` are now
    private methods (Jeremy Evans #297)
  * `Rack::Test::Methods` no longer defines `build_rack_mock_session`,
    but for backwards compatibility, `build_rack_test_session` will call
    `build_rack_mock_session` if it is defined (Jeremy Evans #297)
  * `Rack::Test::Methods::METHODS` is no longer defined
    (Jeremy Evans #297)
  * `Rack::Test::Methods#_current_session_names` has been removed
    (Jeremy Evans #297)
  * Headers used/accessed by rack-test are now lower case, for rack 3
    compliance (Jeremy Evans #295)
  * Frozen literal strings are now used internally, which may break
    code that mutates static strings returned by rack-test, if any
    (Jeremy Evans #304)

* Minor enhancements:
  * rack-test now works with the rack main branch (what will be rack 3)
    (Jeremy Evans #280 #292)
  * rack-test only loads the parts of rack it uses when running on the
    rack main branch (what will be rack 3) (Jeremy Evans #292)
  * Development dependencies have been significantly reduced, and are
    now a subset of the development dependencies of rack itself
    (Jeremy Evans #292)
  * Avoid creating multiple large copies of uploaded file data in
    memory (Jeremy Evans #286)
  * Specify HTTP/1.0 when submitting requests, to avoid responses with
    Transfer-Encoding: chunked (Jeremy Evans #288)
  * Support `:query_params` in rack environment for parameters that
    are appended to the query string instead of used in the request
    body (Jeremy Evans #150 #287)
  * Reduce required ruby version to 2.0, since tests run fine on
    Ruby 2.0 (Jeremy Evans #292)
  * Support :multipart env key for request methods to force multipart
    input (Jeremy Evans #303)
  * Force multipart input for request methods if content type starts
    with multipart (Jeremy Evans #303)
  * Improve performance of Utils.build_multipart by using an
    append-only design (Jeremy Evans #304)
  * Improve performance of Utils.build_nested_query for array values
    (Jeremy Evans #304)

* Bug fixes:
  * The `CONTENT_TYPE` of multipart requests is now respected, if it
    starts with `multipart/` (Tom Knig #238)
  * Work correctly with responses that respond to `to_a` but not
    `to_ary` (Sergio Faria #276)
  * Raise an ArgumentError instead of a TypeError when providing a
    StringIO without an original filename when creating an
    UploadedFile (Nuno Correia #279)
  * Allow combining both an UploadedFile and a plain string when
    building a multipart upload (Mitsuhiro Shibuya #278)
  * Fix the generation of filenames with spaces to use path
    escaping instead of regular escaping, since path unescaping is
    used to decode it (Muir Manders, Jeremy Evans #275 #284)
  * Rewind tempfile used for multipart uploads before it is
    submitted to the application
    (Jeremy Evans, Alexander Dervish #261 #268 #286)
  * Fix Rack::Test.encoding_aware_strings to be true only on rack
    1.6+ (Jeremy Evans #292)
  * Make Rack::Test::CookieJar#valid? return true/false
    (Jeremy Evans #292)
  * Cookies without a domain attribute no longer are submitted to
    requests for subdomains of that domain, for RFC 6265
    compliance (Jeremy Evans #292)
  * Increase required rack version to 1.3, since tests fail on
    rack 1.2 and below (Jeremy Evans #293)

## 1.1.0 / 2018-07-21

* Breaking changes:
  * None

* Minor enhancements / new functionality:
  * [GitHub] Added configuration for Stale (Per Lundberg #232)
  * follow_direct: Include rack.session.options (Mark Edmondson #233)
  * [CI] Add simplecov (fatkodima #227)

* Bug fixes:
  * Follow relative locations correctly. (Samuel Williams #230)

## 1.0.0 / 2018-03-27

* Breaking changes:
  * Always set CONTENT_TYPE for non-GET requests
    (Per Lundberg #223)

* Minor enhancements / bug fixes:
  * Create tempfile using the basename without extension
    (Edouard Chin #201)
  * Save `session` during `follow_redirect!`
    (Alexander Popov #218)
  * Document how to use URL params with DELETE method
    (Timur Platonov #220)

## 0.8.3 / 2018-02-27

* Bug fixes:
  * Do not set Content-Type if params are explicitly set to nil
    (Bartek Bułat #212). Fixes #200.
  * Fix `UploadedFile#new` regression
    (Per Lundberg #215)

* Minor enhancements
  * [CI] Test against Ruby 2.5 (Nicolas Leger #217)

## 0.8.2 / 2017-11-21

* Bug fixes:
  * Bugfix for `UploadedFile.new` unintended API breakage.
    (Per Lundberg #210)

## 0.8.0 / 2017-11-20

* Known Issue
  * In `UploadedFile.new`, when passing e.g. a `Pathname` object,
    errors can be raised (eg. `ArgumentError: Missing original_filename
    for IO`, or `NoMethodError: undefined method 'size'`) See #207, #209.
* Minor enhancements
  * Add a required_ruby_version of >= 2.2.2, similar to rack 2.0.1.
    (Samuel Giddins #194)
  * Remove new line from basic auth. (Felix Kleinschmidt #185)
  * Rubocop fixes (Per Lundberg #196)
  * Add how to install rack-test from github to README. (Jun Aruga #189)
  * Update CodeClimate badges (Toshimaru #195)
  * Add the ability to create Test::UploadedFile instances without
    the file system (Adam Milligan #149)
  * Add custom_request, remove duplication (Johannes Barre #184)
  * README.md: Added note about how to post JSON (Per Lundberg #198)
  * README.md: Added version badge (Per Lundberg #199)
* Bug fixes
  * Bugfix for Cookies with multiple paths (Kyle Welsby #197)

## 0.7.0 / 2017-07-10

* Major enhancements
  * The project URL changed to https://github.com/rack-test/rack-test
    (Per Lundberg, Dennis Sivia, Jun Aruga)
  * Rack 2 compatible. (Trevor Wennblom #81, Vít Ondruch, Jun Aruga #151)
* Minor enhancements
  * Port to RSpec 3. (Murahashi [Matt] Kenichi #70, Antonio Terceiro #134)
  * Add Travis CI (Johannes Barre #108, Jun Aruga #161)
  * Don't append an ampersand when params are empty (sbilharz, #157)
  * Allow symbol access to cookies (Anorlondo448 #156)
  * README: Added Travis badge (Olivier Lacan, Per Lundberg #146)
  * `Rack::Test::Utils#build_multipart`: Allow passing a third parameter
    to force multipart (Koen Punt #142)
  * Allow better testing of cookies (Stephen Best #133)
  * make `build_multipart` work without mixing in `Rack::Test::Utils`
    (Aaron Patterson #131)
  * Add license to gemspec (Jordi Massaguer Pla #72, Anatol Pomozov #89,
    Anatol Pomozov #90, Johannes Barre #109, Mandaryn #115,
    Chris Marshall #120, Robert Reiz #126, Nic Benders #127, Nic Benders #130)
  * Feature/bulk pr for readme updates (Patrick Mulder #65,
    Troels Knak-Nielsen #74, Jeff Casimir #76)
  * Switch README format to Markdown (Dennis Sivia #176)
  * Convert History.txt to Markdown (Dennis Sivia #179)
  * Stop generating gemspec file. (Jun Aruga #181)
  * Fix errors at rake docs and whitespace. (Jun Aruga #183)
  * Ensure Rack::Test::UploadedFile closes its tempfile file descriptor
    on GC (Michael de Silva #180)
  * Change codeclimate URL correctly. (Jun Aruga #186)
* Bug fixes
  * Initialize digest_username before using it. (Guo Xiang Tan #116,
    John Drago #124, Mike Perham #154)
  * Do not set Content-Type for DELETE requests (David Celis #132)
  * Adds support for empty arrays in params. (Cedric Röck, Tim Masliuchenko
    #125)
  * Update README code example quotes to be consistent. (Dmitry Gritsay #112)
  * Update README not to recommend installing gem with sudo. (T.J. Schuck #87)
  * Set scheme when using ENV to enable SSL (Neil Ang #155)
  * Reuse request method and parameters on HTTP 307 redirect. (Martin Mauch
    #138)

## 0.6.3 / 2015-01-09

* Minor enhancements
  * Expose an env helper for persistently configuring the env as needed
    (Darío Javier Cravero #80)
  * Expose the tempfile of UploadedFile (Sytse Sijbrandij #67)
* Bug fixes
  * Improve support for arrays of hashes in multipart forms (Murray Steele #69)
  * Improve test for query strings (Paul Grayson #66)

## 0.6.2 / 2012-09-27

* Minor enhancements
  * Support HTTP PATCH method (Marjan Krekoten' #33)
  * Preserve the exact query string when possible (Paul Grayson #63)
  * Add a #delete method to CookieJar (Paul Grayson #63)
* Bug fixes
  * Fix HTTP Digest authentication when the URI has query params
  * Don't append default ports to HTTP_HOST (David Lee #57)

## 0.6.1 / 2011-07-27

* Bug fixes
  * Fix support for params with arrays in multipart forms (Joel Chippindale)
  * Add `respond_to?` to `Rack::Test::UploadedFile` to match `method_missing` (Josh Nichols)
  * Set the Referer header on requests issued by follow_redirect! (Ryan Bigg)

## 0.6.0 / 2011-05-03

* Bug fixes
  * Add support for HTTP OPTIONS verb (Paolo "Nusco" Perrotta)
  * Call #finish on MockResponses if it's available (Aaron Patterson)
  * Allow HTTP_HOST to be set via #header (Geoff Buesing)

## 0.5.7 / 2011-01-01
* Bug fixes
  * If no URI is present, include all cookies (Pratik Naik)

## 0.5.6 / 2010-09-25

* Bug fixes
  * Use parse_nested_query for parsing URI like Rack does (Eugene Bolshakov)
  * Don't depend on ActiveSupport extension to String (Bryan Helmkamp)
  * Do not overwrite HTTP_HOST if it is set (Krekoten' Marjan)

## 0.5.5 / 2010-09-22

* Bug fixes
  * Fix encoding of file uploads on Ruby 1.9 (Alan Kennedy)
  * Set env["HTTP_HOST"] when making requests (Istvan Hoka)

## 0.5.4 / 2010-05-26

* Bug fixes
  * Don't stomp on Content-Type's supplied via #header (Bryan Helmkamp)
  * Fixed build_multipart to allow for arrays of files (Louis Rose)
  * Don't raise an error if raw cookies contain a blank line (John Reilly)
  * Handle parameter names with brackets properly (Tanner Donovan)

## 0.5.3 / 2009-11-27

* Bug fixes
  * Fix cookie matching for subdomains (Marcin Kulik)

## 0.5.2 / 2009-11-13

* Bug fixes
  * Call close on response body after iteration, not before (Simon Rozet)
  * Add missing require for time in cookie_jar.rb (Jerry West)

## 0.5.1 / 2009-10-27

* Bug fixes
  * Escape cookie values (John Pignata)
  * Close the response body after each request, as per the Rack spec (Elomar França)

## 0.5.0 / 2009-09-19

* Bug fixes
  * Set HTTP_X_REQUESTED_WITH in the Rack env when a request is made with :xhr => true (Ben Sales)
  * Set headers in the Rack env in HTTP_USER_AGENT form
  * Rack::Test now generates no Ruby warnings

## 0.4.2 / 2009-09-01

* Minor enhancements
  * Merge in rack/master's build_multipart method which covers additional cases
  * Accept raw :params string input and merge it with the query string
  * Stringify and upcase request method (e.g. :post => "POST") (Josh Peek)
* Bug fixes
  * Properly convert hashes with nil values (e.g. :foo => nil becomes simply "foo", not "foo=")
  * Prepend a slash to the URI path if it doesn't start with one (Josh Peek)
  * Requiring Rack-Test never modifies the Ruby load path anymore (Josh Peek)
  * Fixed using multiple cookies in a string on Ruby 1.8 (Tuomas Kareinen and Hermanni Hyytiälä)

## 0.4.1 / 2009-08-06

* Minor enhancements
  * Support initializing a `Rack::Test::Session` with an app in addition to
    a `Rack::MockSession`
  * Allow CONTENT_TYPE to be specified in the env and not overwritten when
    sending a POST or PUT

## 0.4.0 / 2009-06-25

* Minor enhancements
  * Expose hook for building `Rack::MockSessions` for frameworks that need
    to configure them before use
  * Support passing in arrays of raw cookies in addition to a newline
    separated string
  * Support after_request callbacks in MockSession for things like running
    background jobs
  * Allow multiple named sessions using with_session
  * Initialize `Rack::Test::Sessions` with `Rack::MockSessions` instead of apps.
    This change should help integration with other Ruby web frameworks
    (like Merb).
  * Support sending bodies for PUT requests (Larry Diehl)

## 0.3.0 / 2009-05-17

* Major enhancements
  * Ruby 1.9 compatible (Simon Rozet, Michael Fellinger)
* Minor enhancements
  * Add `CookieJar#[]` and `CookieJar#[]=` methods
  * Make the default host configurable
  * Use `Rack::Lint` and fix errors (Simon Rozet)
  * Extract `Rack::MockSession` from `Rack::Test::Session` to handle tracking
    the last request and response and the cookie jar
  * Add #set_cookie and #clear_cookies methods
  * Rename #authorize to #basic_authorize (#authorize remains as an alias)
    (Simon Rozet)

## 0.2.0 / 2009-04-26

Because `#last_response` is now a `MockResponse` instead of a `Rack::Response`, `#last_response.body`
now returns a string instead of an array.

* Major enhancements
  * Support multipart requests via the UploadedFile class (thanks, Rails)
* Minor enhancements
  * Updated for Rack 1.0
  * Don't require rubygems (See http://gist.github.com/54177)
  * Support HTTP Digest authentication with the `#digest_authorize` method
  * `#last_response` returns a `MockResponse` instead of a Response
    (Michael Fellinger)

## 0.1.0 / 2009-03-02

* 1 major enhancement
  * Birthday!
