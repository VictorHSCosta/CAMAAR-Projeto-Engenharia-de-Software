### 6.0.4 / 2023-11-21
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v6.0.3...v6.0.4)

Bug Fixes:

* Fuzzy match `have_broadcasted_to` so that argument matchers can be used.
  (Timothy Peraza, #2684)
* Fix fixture warning during `:context` hooks on Rails `main`. (Jon Rowe, #2685)
* Fix `stub_template` on Rails `main`. (Jon Rowe, #2685)
* Fix variable name in scaffolded view specs when namespaced. (Taketo Takashima, #2694)
* Prevent `take_failed_screenshot` producing an additional error through `metadata`
  access. (Jon Rowe, #2704)
* Use `ActiveSupport::ExecutionContext::TestHelper` on Rails 7+. (Jon Rowe, #2711)
* Fix leak of templates stubbed with `stub_template` on Rails 7.1. (Jon Rowe, #2714)

### 6.0.3 / 2023-05-31
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v6.0.2...v6.0.3)

Bug Fixes:

* Set `ActiveStorage::FixtureSet.file_fixture_path` when including file fixture support.
  (Jason Yates, #2671)
* Allow `broadcast_to` matcher to take Symbols. (@Vagab, #2680)

### 6.0.2 / 2023-05-04
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v6.0.1...v6.0.2)

Bug Fixes:

* Fix ActionView::PathSet when `render_views` is off for Rails 7.1.
  (Eugene Kenny, Iliana, #2631)
* Support Rails 7.1's `#fixtures_paths` in example groups (removes a deprecation warning).
  (Nicholas Simmons, #2664)
* Fix `have_enqueued_job` to properly detect enqueued jobs when other jobs were
  performed inside the expectation block. (Slava Kardakov, Phil Pirozhkov, #2573)

### 6.0.1 / 2022-10-18
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v6.0.0...v6.0.1)

Bug Fixes:

* Prevent tagged logged support in Rails 7 calling `#name`. (Jon Rowe, #2625)

### 6.0.0 / 2022-10-10
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v5.1.2...v6.0.0)

Enhancements:

* Support Rails 7
* Template tweaks to remove instance variables from generated specs. (Takuma Ishikawa, #2599)
* Generators now respects default path configuration option. (@vivekmiyani, #2508)

Breaking Changes:

* Drop support for Rails below 6.1
* Drop support for Ruby below 2.5 (following supported versions of Rails 6.1)
* Change the order of `after_teardown` from `after` to `around` in system
  specs to improve compatibility with extensions and Capybara. (Tim Diggins, #2596)

Deprecations:

* Deprecates integration spec generator (`rspec:integration`)
  which was an alias of request spec generator (`rspec:request`)
  (Luka Lüdicke, #2374)

### 5.1.2 / 2022-04-24
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v5.1.1...v5.1.2)

Bug Fixes:

* Fix controller scaffold templates parameter name.  (Taketo Takashima, #2591)
* Include generator specs in the inferred list of specs. (Jason Karns, #2597)

### 5.1.1 / 2022-03-07
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v5.1.0...v5.1.1)

Bug Fixes:

* Properly handle global id serialised arguments in `have_enqueued_mail`.
  (Jon Rowe, #2578)

### 5.1.0 / 2022-01-26
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v5.0.3...v5.1.0)

Enhancements:

* Make the API request scaffold template more consistent and compatible with
  Rails 6.1. (Naoto Hamada, #2484)
* Change the scaffold `rails_helper.rb` template to use `require_relative`.
  (Jon Dufresne, #2528)

### 5.0.3 / 2022-01-26
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v5.0.2...v5.0.3)

Bug Fixes:

* Properly name params in controller and request spec templates when
  using the `--model-name` parameter. (@kenzo-tanaka, #2534)
* Fix parameter matching with mail delivery job and
  ActionMailer::MailDeliveryJob. (Fabio Napoleoni, #2516, #2546)
* Fix Rails 7 `have_enqueued_mail` compatibility (Mikael Henriksson, #2537, #2546)

### 5.0.2 / 2021-08-14
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v5.0.1...v5.0.2)

Bug Fixes:

* Prevent generated job specs from duplicating `_job` in filenames.
  (Nick Flückiger, #2496)
* Fix `ActiveRecord::TestFixture#uses_transaction` by using example description
  to replace example name rather than example in our monkey patched
  `run_in_transaction?` method.  (Stan Lo, #2495)
* Prevent keyword arguments being lost when methods are invoked dynamically
  in controller specs. (Josh Cheek, #2509, #2514)

### 5.0.1 / 2021-03-18
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v5.0.0...v5.0.1)

Bug Fixes:

* Limit multibyte example descriptions when used in system tests for #method_name
  which ends up as screenshot names etc. (@y-yagi, #2405, #2487)

### 5.0.0 / 2021-03-09
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v4.1.1...v5.0.0)

Enhancements:

* Support new #file_fixture_path and new fixture test support code. (Jon Rowe, #2398)
* Support for Rails 6.1. (Benoit Tigeot, Jon Rowe, Phil Pirozhkov, and more #2398)

Breaking Changes:

* Drop support for Rails below 5.2.

### 4.1.1 / 2021-03-09

Bug Fixes:

* Remove generated specs when destroying a generated controller.
  (@Naokimi, #2475)

### 4.1.0 / 2021-03-06

Enhancements:

* Issue a warning when using job matchers with `#at` mismatch on `usec` precision.
  (Jon Rowe, #2350)
* Generated request specs now have a bare `_spec` suffix instead of `request_spec`.
  (Eloy Espinaco, Luka Lüdicke, #2355, #2356, #2378)
* Generated scaffold now includes engine route helpers when inside a mountable engine.
  (Andrew W. Lee, #2372)
* Improve request spec "controller" scafold when no action is specified.
  (Thomas Hareau, #2399)
* Introduce testing snippets concept (Phil Pirozhkov, Benoit Tigeot, #2423)
* Prevent collisions with `let(:name)` for Rails 6.1 and `let(:method_name)` on older
  Rails. (Benoit Tigeot, #2461)

### 4.0.2 / 2020-12-26
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v4.0.1...v4.0.2)

Bug Fixes:

* Indent all extra failure lines output from system specs. (Alex Robbin, #2321)
* Generated request spec for update now uses the correct let. (Paul Hanyzewski, #2344)
* Return `true`/`false` from predicate methods in config rather than raw values.
  (Phil Pirozhkov, Jon Rowe, #2353, #2354)
* Remove old #fixture_path feature detection code which broke under newer Rails.
  (Koen Punt, Jon Rowe, #2370)
* Fix an error when `use_active_record` is `false` (Phil Pirozhkov, #2423)

### 4.0.1 / 2020-05-16
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v4.0.0...v4.0.1)

Bug Fixes:

* Remove warning when calling `driven_by` in system specs. (Aubin Lorieux, #2302)
* Fix comparison of times for `#at` in job matchers. (Jon Rowe, Markus Doits, #2304)
* Allow `have_enqueued_mail` to match when a sub class of `ActionMailer::DeliveryJob`
  is set using `<Class>.delivery_job=`. (Atsushi Yoshida #2305)
* Restore Ruby 2.2.x compatibility. (Jon Rowe, #2332)
* Add `required_ruby_version` to gem spec. (Marc-André Lafortune, #2319, #2338)

### 4.0.0 / 2020-03-24
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.9.1...v4.0.0)

Enhancements:

* Adds support for Rails 6. (Penelope Phippen, Benoit Tigeot, Jon Rowe, #2071)
* Adds support for JRuby on Rails 5.2 and 6
* Add support for parameterised mailers (Ignatius Reza, #2125)
* Add ActionMailbox spec helpers and test type (James Dabbs, #2119)
* Add ActionCable spec helpers and test type (Vladimir Dementyev, #2113)
* Add support for partial args when using `have_enqueued_mail`
  (Ignatius Reza, #2118, #2125)
* Add support for time arguments for `have_enqueued_job` (@alpaca-tc, #2157)
* Improve path parsing in view specs render options. (John Hawthorn, #2115)
* Add routing spec template as an option for generating controller specs.
  (David Revelo, #2134)
* Add argument matcher support to `have_enqueued_*` matchers. (Phil Pirozhkov, #2206)
* Switch generated templates to use ruby 1.9 hash keys. (Tanbir Hasan, #2224)
* Add `have_been_performed`/`have_performed_job`/`perform_job` ActiveJob
  matchers (Isaac Seymour, #1785)
* Default to generating request specs rather than controller specs when
  generating a controller (Luka Lüdicke, #2222)
* Allow `ActiveJob` matchers `#on_queue` modifier to take symbolic queue names. (Nils Sommer, #2283)
* The scaffold generator now generates request specs in preference to controller specs.
  (Luka Lüdicke, #2288)
* Add configuration option to disable ActiveRecord. (Jon Rowe, Phil Pirozhkov, Hermann Mayer, #2266)
*  Set `ActionDispatch::SystemTesting::Server.silence_puma = true` when running system specs.
  (ta1kt0me, Benoit Tigeot, #2289)

Bug Fixes:

* `EmptyTemplateHandler.call` now needs to support an additional argument in
  Rails 6. (Pavel Rosický, #2089)
* Suppress warning from `SQLite3Adapter.represent_boolean_as_integer` which is
  deprecated. (Pavel Rosický, #2092)
* `ActionView::Template#formats` has been deprecated and replaced by
  `ActionView::Template#format`(Seb Jacobs, #2100)
* Replace `before_teardown` as well as `after_teardown` to ensure screenshots
  are generated correctly. (Jon Rowe, #2164)
* `ActionView::FixtureResolver#hash` has been renamed to `ActionView::FixtureResolver#data`.
  (Penelope Phippen, #2076)
* Prevent `driven_by(:selenium)` being called due to hook precedence.
  (Takumi Shotoku, #2188)
* Prevent a `WrongScopeError` being thrown during loading fixtures on Rails
  6.1 development version. (Edouard Chin, #2215)
* Fix Mocha mocking support with `should`. (Phil Pirozhkov, #2256)
* Restore previous conditional check for setting `default_url_options` in feature
  specs, prevents a `NoMethodError` in some scenarios. (Eugene Kenny, #2277)
* Allow changing `ActiveJob::Base.queue_adapter` inside a system spec.
  (Jonathan Rochkind, #2242)
* `rails generate generator` command now creates related spec file (Joel Azemar, #2217)
* Relax upper `capybara` version constraint to allow for Capybara 3.x (Phil Pirozhkov, #2281)
* Clear ActionMailer test mailbox after each example (Benoit Tigeot, #2293)

Breaking Changes:

* Drops support for Rails below 5.0
* Drops support for Ruby below 2.3

### 3.9.1 / 2020-03-10
[Full Changelog](http://github.com/rspec/rspec-rails/compare/v3.9.0...v3.9.1)

Bug Fixes:

* Add missing require for have_enqueued_mail matcher. (Ignatius Reza, #2117)

### 3.9.0 / 2019-10-08
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.8.3...v3.9.0)

Enhancements

* Use `__dir__` instead of `__FILE__` in generated `rails_helper.rb` where
  supported. (OKURA Masafumi, #2048)
* Add `have_enqueued_mail` matcher as a "super" matcher to the `ActiveJob` matchers
  making it easier to match on `ActiveJob` delivered emails. (Joel Lubrano, #2047)
* Add generator for system specs on Rails 5.1 and above. (Andrzej Sliwa, #1933)
* Add generator for generator specs. (@ConSou, #2085)
* Add option to generate routes when generating controller specs. (David Revelo, #2134)

Bug Fixes:

* Make the `ActiveJob` matchers fail when multiple jobs are queued for negated
  matches. e.g. `expect { job; job; }.to_not have_enqueued_job`.
  (Emric Istanful, #2069)

### 3.8.3 / 2019-10-03
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.8.2...v3.8.3)

Bug Fixes:

* Namespaced fixtures now generate a `/` separated path rather than an `_`.
  (@nxlith, #2077)
* Check the arity of `errors` before attempting to use it to generate the `be_valid`
  error message. (Kevin Kuchta, #2096)

### 3.8.2 / 2019-01-13
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.8.1...v3.8.2)

Bug Fixes:

* Fix issue with generator for preview specs where `Mailer` would be duplicated
  in the name. (Kohei Sugi, #2037)
* Fix the request spec generator to handle namespaced files. (Kohei Sugi, #2057)
* Further truncate system test filenames to handle cases when extra words are
  prepended. (Takumi Kaji, #2058)
* Backport: Make the `ActiveJob` matchers fail when multiple jobs are queued
  for negated matches. e.g. `expect { job; job; }.to_not have_enqueued_job
  (Emric Istanful, #2069)

### 3.8.1 / 2018-10-23
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.8.0...v3.8.1)

Bug Fixes:

* Fix `NoMethodError: undefined method 'strip'` when using a `Pathname` object
  as the fixture file path. (Aaron Kromer, #2026)
* When generating feature specs, do not duplicate namespace in the path name.
  (Laura Paakkinen, #2034)
* Prevent `ActiveJob::DeserializationError` from being issued when `ActiveJob`
  matchers de-serialize arguments. (@aymeric-ledorze, #2036)

### 3.8.0 / 2018-08-04
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.7.2...v3.8.0)

Enhancements:

* Improved message when migrations are pending in the default `rails_helper.rb`
  (Koichi ITO, #1924)
* `have_http_status` matcher now supports Rails 5.2 style response symbols
  (Douglas Lovell, #1951)
* Change generated Rails helper to match Rails standards for Rails.root
  (Alessandro Rodi, #1960)
* At support for asserting enqueued jobs have no wait period attached.
  (Brad Charna, #1977)
* Cache instances of `ActionView::Template` used in `stub_template` resulting
  in increased performance due to less allocations and setup. (Simon Coffey, #1979)
* Rails scaffold generator now respects longer namespaces (e.g. api/v1/\<thing\>).
  (Laura Paakkinen, #1958)

Bug Fixes:

* Escape quotation characters when producing method names for system spec
  screenshots. (Shane Cavanaugh, #1955)
* Use relative path for resolving fixtures when `fixture_path` is not set.
  (Laurent Cobos, #1943)
* Allow custom template resolvers in view specs. (@ahorek, #1941)


### 3.7.2 / 2017-11-20
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.7.1...v3.7.2)

Bug Fixes:

* Delay loading system test integration until used. (Jon Rowe, #1903)
* Ensure specs using the aggregate failures feature take screenshots on failure.
  (Matt Brictson, #1907)

### 3.7.1 / 2017-10-18
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.7.0...v3.7.1)

Bug Fixes:

* Prevent system test integration loading when puma or capybara are missing (Sam Phippen, #1884)

### 3.7.0 / 2017-10-17
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.6.0...v3.7.0)

Bug Fixes:

* Prevent "template not rendered" log message from erroring in threaded
  environments. (Samuel Cochran, #1831)
* Correctly generate job name in error message. (Wojciech Wnętrzak, #1814)

Enhancements:

* Allow `be_a_new(...).with(...)` matcher to accept matchers for
  attribute values. (Britni Alexander, #1811)
* Only configure RSpec Mocks if it is fully loaded. (James Adam, #1856)
* Integrate with `ActionDispatch::SystemTestCase`. (Sam Phippen, #1813)

### 3.6.0 / 2017-05-04
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.6.0.beta2...v3.6.0)

Enhancements:

* Add compatibility for Rails 5.1. (Sam Phippen, Yuichiro Kaneko, #1790)

Bug Fixes:

* Fix scaffold generator so that it does not generate broken controller specs
  on Rails 3.x and 4.x. (Yuji Nakayama, #1710)

### 3.6.0.beta2 / 2016-12-12
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.6.0.beta1...v3.6.0.beta2)

Enhancements:

* Improve failure output of ActiveJob matchers by listing queued jobs.
  (Wojciech Wnętrzak, #1722)
* Load `spec_helper.rb` earlier in `rails_helper.rb` by default.
  (Kevin Glowacz, #1795)

### 3.6.0.beta1 / 2016-10-09
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.5.2...v3.6.0.beta1)

Enhancements:

* Add support for `rake notes` in Rails `>= 5.1`. (John Meehan, #1661)
* Remove `assigns` and `assert_template` from scaffold spec generators (Josh
  Justice, #1689)
* Add support for generating scaffolds for api app specs. (Krzysztof Zych, #1685)

### 3.5.2 / 2016-08-26
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.5.1...v3.5.2)

Bug Fixes:

* Stop unnecessarily loading `rspec/core` from `rspec/rails` to avoid
  IRB context warning. (Myron Marston, #1678)
* Deserialize arguments within ActiveJob matchers correctly.
  (Wojciech Wnętrzak, #1684)

### 3.5.1 / 2016-07-08
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.5.0...v3.5.1)

Bug Fixes:

* Only attempt to load `ActionDispatch::IntegrationTest::Behavior` on Rails 5,
  and above; Prevents possible `TypeError` when an existing `Behaviour` class
  is defined. (#1660, Betesh).

### 3.5.0 / 2016-07-01
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.5.0.beta4...v3.5.0)

**No user facing changes since beta4**

### 3.5.0.beta4 / 2016-06-05
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.5.0.beta3...v3.5.0.beta4)

Enhancements:

* Add support for block when using `with` on `have_enqueued_job`. (John Schroeder, #1578)
* Add support for `file_fixture(...)`. (Wojciech Wnętrzak, #1587)
* Add support for `setup` and `teardown` with blocks (Miklós Fazekas, #1598)
* Add `enqueue_job ` alias for `have_enqueued_job`, support `once`/`twice`/
  `thrice`, add `have_been_enqueued` matcher to support use without blocks.
  (Sergey Alexandrovich, #1613)

Bug fixes:

* Prevent asset helpers from taking precedence over route helpers. (Prem Sichanugrist, #1496)
* Prevent `NoMethodError` during failed `have_rendered` assertions on weird templates.
  (Jon Rowe, #1623).

### 3.5.0.beta3 / 2016-04-02
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.5.0.beta2...v3.5.0.beta3)

Enhancements:

* Add support for Rails 5 Beta 3 (Sam Phippen, Benjamin Quorning, Koen Punt, #1589, #1573)

Bug fixes:

* Support custom resolvers when preventing views from rendering.
  (Jon Rowe, Benjamin Quorning, #1580)

### 3.5.0.beta2 / 2016-03-10
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.5.0.beta1...v3.5.0.beta2)

Enhancements:

* Include `ActionDispatch::IntegrationTest::Behavior` in request spec
  example groups when on Rails 5, allowing integration test helpers
  to be used in request specs. (Scott Bronson, #1560)

Bug fixes:

* Make it possible to use floats in auto generated (scaffold) tests.
  (Alwahsh, #1550)

### 3.5.0.beta1 / 2016-02-06
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.4.2...v3.5.0.beta1)

Enhancements:

* Add a `--singularize` option for the feature spec generator (Felicity McCabe,
  #1503)
* Prevent leaking TestUnit methods in Rails 4+ (Fernando Seror Garcia, #1512)
* Add support for Rails 5 (Sam Phippen, #1492)

Bug fixes:

* Make it possible to write nested specs within helper specs on classes that are
  internal to helper classes. (Sam Phippen, Peter Swan, #1499).
* Warn if a fixture method is called from a `before(:context)` block, instead of
  crashing with a `undefined method for nil:NilClass`. (Sam Phippen, #1501)
* Expose path to view specs (Ryan Clark, Sarah Mei, Sam Phippen, #1402)
* Prevent installing Rails 3.2.22.1 on Ruby 1.8.7. (Jon Rowe, #1540)
* Raise a clear error when `have_enqueued_job` is used with non-test
  adapter. (Wojciech Wnętrzak, #1489)

### 3.4.2 / 2016-02-02
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.4.1...v3.4.2)

Bug Fixes:

* Cache template resolvers during path lookup to prevent performance
  regression from #1535. (Andrew White, #1544)

### 3.4.1 / 2016-01-25
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.4.0...v3.4.1)

Bug Fixes:

* Fix no method error when rendering templates with explicit `:file`
  parameters for Rails version `4.2.5.1`. (Andrew White, Sam Phippen, #1535)

### 3.4.0 / 2015-11-11
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.3.3...v3.4.0)

Enhancements:

* Improved the failure message for `have_rendered` matcher on a redirect
  response. (Alex Egan, #1440)
* Add configuration option to filter out Rails gems from backtraces.
  (Bradley Schaefer, #1458)
* Enable resolver cache for view specs for a large speed improvement
  (Chris Zetter, #1452)
* Add `have_enqueued_job` matcher for checking if a block has queued jobs.
  (Wojciech Wnętrzak, #1464)

Bug Fixes:

* Fix another load order issued which causes an undefined method `fixture_path` error
  when loading rspec-rails after a spec has been created. (Nikki Murray, #1430)
* Removed incorrect surrounding whitespace in the rspec-rails backtrace
  exclusion pattern for its own `lib` code. (Jam Black, #1439)

### 3.3.3 / 2015-07-15
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.3.2...v3.3.3)

Bug Fixes:

* Fix issue with generators caused by `Rails.configuration.hidden_namespaces`
  including symbols. (Dan Kohn, #1414)

### 3.3.2 / 2015-06-18
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.3.1...v3.3.2)

Bug Fixes:

* Fix regression that caused stubbing abstract ActiveRecord model
  classes to trigger internal errors in rails due the the verifying
  double lifecycle wrongly calling `define_attribute_methods` on the
  abstract AR class. (Jon Rowe, #1396)

### 3.3.1 / 2015-06-14
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.3.0...v3.3.1)

Bug Fixes:

* Fix regression that caused stubbing ActiveRecord model classes to
  trigger internal errors in rails. (Myron Marston, Aaron Kromer, #1395)

### 3.3.0 / 2015-06-12
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.2.3...v3.3.0)

Enhancements:

* Add support for PATCH to route specs created via scaffold. (Igor Zubkov, #1336)
* Improve controller and routing spec calls to `routes` by using `yield`
  instead of `call`. (Anton Davydov, #1308)
* Add support for `ActiveJob` specs as standard `RSpec::Rails::RailsExampleGoup`s
  via both `type: :job` and inferring type from spec directory `spec/jobs`.
  (Gabe Martin-Dempesy, #1361)
* Include `RSpec::Rails::FixtureSupport` into example groups using metadata
  `use_fixtures: true`. (Aaron Kromer, #1372)
* Include `rspec:request` generator for generating request specs; this is an
  alias of `rspec:integration` (Aaron Kromer, #1378)
* Update `rails_helper` generator with a default check to abort the spec run
  when the Rails environment is production. (Aaron Kromer, #1383)

### 3.2.3 / 2015-06-06
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.2.2...v3.2.3)

Bug Fixes:

* Fix regression with the railtie resulting in undefined method `preview_path=`
  on Rails 3.x and 4.0 (Aaron Kromer, #1388)

### 3.2.2 / 2015-06-03
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.2.1...v3.2.2)

Bug Fixes:

* Fix auto-including of generic `Helper` object for view specs sitting in the
  `app/views` root (David Daniell, #1289)
* Remove pre-loading of ActionMailer in the Railtie (Aaron Kromer, #1327)
* Fix undefined method `need_auto_run=` error when using Ruby 2.1 and Rails 3.2
  without the test-unit gem (Orien Madgwick, #1350)
* Fix load order issued which causes an undefined method `fixture_path` error
  when loading rspec-rails after a spec has been created. (Aaron Kromer, #1372)

### 3.2.1 / 2015-02-23
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.2.0...v3.2.1)

Bug Fixes:

* Add missing `require` to RSpec generator root fixing an issue where Rail's
  autoload does not find it in some environments. (Aaron Kromer, #1305)
* `be_routable` matcher now has the correct description. (Tony Ta, #1310)
* Fix dependency to allow Rails 4.2.x patches / pre-releases (Lucas Mazza, #1318)
* Disable the `test-unit` gem's autorunner on projects running Rails < 4.1 and
  Ruby < 2.2 (Aaron Kromer, #1320)

### 3.2.0 / 2015-02-03
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.1.0...v3.2.0)

Enhancements:

* Include generator for `ActionMailer` mailer previews (Takashi Nakagawa, #1185)
* Configure the `ActionMailer` preview path via a Railtie (Aaron Kromer, #1236)
* Show all RSpec generators when running `rails generate` (Eliot Sykes, #1248)
* Support Ruby 2.2 with Rails 3.2 and 4.x (Aaron Kromer, #1264, #1277)
* Improve `instance_double` to support verifying dynamic column methods defined
  by `ActiveRecord` (Jon Rowe, #1238)
* Mirror the use of Ruby 1.9 hash syntax for the `type` tags in the spec
  generators on Rails 4. (Michael Stock, #1292)

Bug Fixes:

* Fix `rspec:feature` generator to use `RSpec` namespace preventing errors when
  monkey-patching is disabled. (Rebecca Skinner, #1231)
* Fix `NoMethodError` caused by calling `RSpec.feature` when Capybara is not
  available or the Capybara version is < 2.4.0. (Aaron Kromer, #1261)
* Fix `ArgumentError` when using an anonymous controller which inherits an
  outer group's anonymous controller. (Yuji Nakayama, #1260)
* Fix "Test is not a class (TypeError)" error when using a custom `Test` class
  in Rails 4.1 and 4.2. (Aaron Kromer, #1295)

### 3.1.0 / 2014-09-04
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.0.2...v3.1.0)

Enhancements:

* Switch to using the `have_http_status` matcher in spec generators. (Aaron Kromer, #1086)
* Update `rails_helper` generator to allow users to opt-in to auto-loading
  `spec/support` files instead of forcing it upon them. (Aaron Kromer, #1137)
* Include generator for `ActiveJob`. (Abdelkader Boudih, #1155)
* Improve support for non-ActiveRecord apps by not loading ActiveRecord related
  settings in the generated `rails_helper`. (Aaron Kromer, #1150)
* Remove Ruby warnings as a suggested configuration. (Aaron Kromer, #1163)
* Improve the semantics of the controller spec for scaffolds. (Griffin Smith, #1204)
* Use `#method` syntax in all generated controller specs. (Griffin Smith, #1206)

Bug Fixes:

* Fix controller route lookup for Rails 4.2. (Tomohiro Hashidate, #1142)

### 3.0.2 / 2014-07-21
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.0.1...v3.0.2)

Bug Fixes:

* Suppress warning in `SetupAndTeardownAdapter`. (André Arko, #1085)
* Remove dependency on Rubygems. (Andre Arko & Doc Riteze, #1099)
* Standardize controller spec template style. (Thomas Kriechbaumer, #1122)

### 3.0.1 / 2014-06-02
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.0.0...v3.0.1)

Bug Fixes:

* Fix missing require in `rails g rspec:install`. (Sam Phippen, #1058)

### 3.0.0 / 2014-06-01
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.0.0.rc1...v3.0.0)

Enhancements:

* Separate RSpec configuration in generated `spec_helper` from Rails setup
  and associated configuration options. Moving Rails specific settings and
  options to `rails_helper`. (Aaron Kromer)

Bug Fixes:

* Fix an issue with fixture support when `ActiveRecord` isn't loaded. (Jon Rowe)

### 3.0.0.rc1 / 2014-05-18
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.0.0.beta2...v3.0.0.rc1)

Breaking Changes for 3.0.0:

* Extracts the `mock_model` and `stub_model` methods to the
  `rspec-activemodel-mocks` gem. (Thomas Holmes)
* Spec types are no longer inferred by location, they instead need to be
  explicitly tagged. The old behaviour is enabled by
  `config.infer_spec_type_from_file_location!`, which is still supplied
  in the default generated `spec_helper.rb`. (Xavier Shay, Myron Marston)
* `controller` macro in controller specs no longer mutates
  `:described_class` metadata. It still overrides the subject and sets
  the controller, though. (Myron Marston)
* Stop depending on or requiring `rspec-collection_matchers`. Users who
  want those matchers should add the gem to their Gemfile and require it
  themselves. (Myron Marston)
* Removes runtime dependency on `ActiveModel`. (Rodrigo Rosenfeld Rosas)

Enhancements:

* Supports Rails 4.x reference attribute ids in generated scaffold for view
  specs. (Giovanni Cappellotto)
* Add `have_http_status` matcher. (Aaron Kromer)
* Add spec type metadata to generator templates. (Aaron Kromer)

Bug Fixes:

* Fix an inconsistency in the generated scaffold specs for a controller. (Andy Waite)
* Ensure `config.before(:all, type: <type>)` hooks run before groups
  of the given type, even when the type is inferred by the file
  location. (Jon Rowe, Myron Marston)
* Switch to parsing params with `Rack::Utils::parse_nested_query` to match Rails.
  (Tim Watson)
* Fix incorrect namespacing of anonymous controller routes. (Aaron Kromer)

### 3.0.0.beta2 / 2014-02-17
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v3.0.0.beta1...v3.0.0.beta2)

Breaking Changes for 3.0.0:

* Removes the `--webrat` option for the request spec generator (Andy Lindeman)
* Methods from `Capybara::DSL` (e.g., `visit`) are no longer available in
  controller specs. It is more appropriate to use capybara in feature specs
  (`spec/features`) instead. (Andy Lindeman)
* `infer_base_class_for_anonymous_controllers` is
  enabled by default. (Thomas Holmes)
* Capybara 2.2.0 or above is required for feature specs. (Andy Lindeman)

Enhancements:

* Improve `be_valid` matcher for non-ActiveModel::Errors implementations (Ben Hamill)

Bug Fixes:

* Use `__send__` rather than `send` to prevent naming collisions (Bradley Schaefer)
* Supports Rails 4.1. (Andy Lindeman)
* Routes are drawn correctly for anonymous controllers with abstract
  parents. (Billy Chan)
* Loads ActiveSupport properly to support changes in Rails 4.1. (Andy Lindeman)
* Anonymous controllers inherit from `ActionController::Base` if `ApplicationController`
  is not present. (Jon Rowe)
* Require `rspec/collection_matchers` when `rspec/rails` is required. (Yuji Nakayama)

### 3.0.0.beta1 / 2013-11-07
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.99.0...v3.0.0.beta1)

Breaking Changes for 3.0.0:

* Extracts `autotest` and `autotest-rails` support to `rspec-autotest` gem.
  (Andy Lindeman)

### 2.99.0 / 2014-06-01
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.99.0.rc1...v2.99.0)

No changes. Just taking it out of pre-release.

### 2.99.0.rc1 / 2014-05-18
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.99.0.beta2...v2.99.0.rc1)

Deprecations

* Deprecates `stub_model` and `mock_model` in favor of the
  `rspec-activemodel-mocks` gem. (Thomas Holmes)
* Issue a deprecation to instruct users to configure
  `config.infer_spec_type_from_file_location!` during the
  upgrade process since spec type inference is opt-in in 3.0.
  (Jon Rowe)
* Issue a deprecation when `described_class` is accessed in a controller
  example group that has used the `controller { }` macro to generate an
  anonymous controller class, since in 2.x, `described_class` would
  return that generated class but in 3.0 it will continue returning the
  class passed to `describe`. (Myron Marston)

### 2.99.0.beta2 / 2014-02-17
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.99.0.beta1...v2.99.0.beta2)

Deprecations:

* Deprecates the `--webrat` option to the scaffold and request spec generator (Andy Lindeman)
* Deprecates the use of `Capybara::DSL` (e.g., `visit`) in controller specs.
  It is more appropriate to use capybara in feature specs (`spec/features`)
  instead. (Andy Lindeman)

Bug Fixes:

* Use `__send__` rather than `send` to prevent naming collisions (Bradley Schaefer)
* Supports Rails 4.1. (Andy Lindeman)
* Loads ActiveSupport properly to support changes in Rails 4.1. (Andy Lindeman)
* Anonymous controllers inherit from `ActionController::Base` if `ApplicationController`
  is not present. (Jon Rowe)

### 2.99.0.beta1 / 2013-11-07
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.14.0...v2.99.0.beta1)

Deprecations:

* Deprecates autotest integration in favor of the `rspec-autotest` gem. (Andy
  Lindeman)

Enhancements:

* Supports Rails 4.1 and Minitest 5. (Patrick Van Stee)

Bug Fixes:

* Fixes "warning: instance variable @orig\_routes not initialized" raised by
  controller specs when `--warnings` are enabled. (Andy Lindeman)
* Where possible, check against the version of ActiveRecord, rather than
  Rails. It is possible to use some of rspec-rails without all of Rails.
  (Darryl Pogue)
* Explicitly depends on `activemodel`. This allows libraries that do not bring
  in all of `rails` to use `rspec-rails`. (John Firebaugh)

### 2.14.1 / 2013-12-29
[full changelog](https://github.com/rspec/rspec-rails/compare/v2.14.0...v2.14.1)

Bug Fixes:

* Fixes "warning: instance variable @orig\_routes not initialized" raised by
  controller specs when `--warnings` are enabled. (Andy Lindeman)
* Where possible, check against the version of ActiveRecord, rather than
  Rails. It is possible to use some of rspec-rails without all of Rails.
  (Darryl Pogue)
* Supports Rails 4.1 and Minitest 5. (Patrick Van Stee, Andy Lindeman)
* Explicitly depends on `activemodel`. This allows libraries that do not bring
  in all of `rails` to use `rspec-rails`. (John Firebaugh)
* Use `__send__` rather than `send` to prevent naming collisions (Bradley Schaefer)

### 2.14.0 / 2013-07-06
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.14.0.rc1...v2.14.0)

Bug fixes

* Rake tasks do not define methods that might interact with other libraries.
  (Fujimura Daisuke)
* Reverts fix for out-of-order `let` definitions in controller specs after the
  issue was fixed upstream in rspec-core. (Andy Lindeman)
* Fixes deprecation warning when using `expect(Model).to have(n).records` with
  Rails 4. (Andy Lindeman)

### 2.14.0.rc1 / 2013-05-27
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.13.2...v2.14.0.rc1)

Enhancements

* Prelimiarily support Rails 4.1 by updating adapters to support Minitest 5.0.
  (Andy Lindeman)

Bug fixes

* `rake stats` runs correctly when spec files exist at the top level of the
  spec/ directory. (Benjamin Fleischer)

### 2.13.2 / 2013-05-18
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.13.1...v2.13.2)

Bug fixes

* `let` definitions may override methods defined in modules brought in via
  `config.include` in controller specs. Fixes regression introduced in 2.13.
  (Andy Lindeman, Jon Rowe)
* Code that checks Rails version numbers is more robust in cases where Rails is
  not fully loaded. (Andy Lindeman)

Enhancements

* Document how the spec/support directory works. (Sam Phippen)

### 2.13.1 / 2013-04-27
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.13.0...v2.13.1)

Bug fixes

* View specs are no longer generated if no template engine is specified (Kevin
  Glowacz)
* `ActionController::Base.allow_forgery_protection` is set to its original
  value after each example. (Mark Dimas)
* `patch` is supported in routing specs. (Chris Your)
* Routing assertions are supported in controller specs in Rails 4. (Andy
  Lindeman)
* Fix spacing in the install generator template (Taiki ONO)

### 2.13.0 / 2013-02-23
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.12.2...v2.13.0)

Enhancements

* `be_valid` matcher includes validation error messages. (Tom Scott)
* Adds cucumber scenario showing how to invoke an anonymous controller's
  non-resourceful actions. (Paulo Luis Franchini Casaretto)
* Null template handler is used when views are stubbed. (Daniel Schierbeck)
* The generated `spec_helper.rb` in Rails 4 includes a check for pending
  migrations. (Andy Lindeman)
* Adds `rake spec:features` task. (itzki)
* Rake tasks are automatically generated for each spec/ directory.
  (Rudolf Schmidt)

### 2.12.2 / 2013-01-12
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.12.1...v2.12.2)

Bug fixes

* Reverts earlier fix where anonymous controllers defined the `_routes` method
  to support testing of redirection and generation of URLs from other contexts.
  The implementation ended up breaking the ability to refer to non-anonymous
  routes in the context of the controller under test.
* Uses `assert_select` correctly in view specs generated by scaffolding. (Andy
  Lindeman)

### 2.12.1 / 2013-01-07
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.12.0...v2.12.1)

Bug fixes

* Operates correctly when ActiveRecord is only partially loaded (e.g., with
  older versions of Mongoid). (Eric Marden)
* `expect(subject).to have(...).errors_on` operates correctly for
  ActiveResource models where `valid?` does not accept an argument. (Yi Wen)
* Rails 4 support for routing specs. (Andy Lindeman)
* Rails 4 support for `ActiveRecord::Relation` and the `=~` operator matcher.
  (Andy Lindeman)
* Anonymous controllers define `_routes` to support testing of redirection
  and generation of URLs from other contexts. (Andy Lindeman)

### 2.12.0 / 2012-11-12
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.11.4...v2.12.0)

Enhancements

* Support validation contexts when using `#errors_on` (Woody Peterson)
* Include RequestExampleGroup in groups in spec/api

Bug fixes

* Add `should` and `should_not` to `CollectionProxy` (Rails 3.1+) and
  `AssociationProxy` (Rails 3.0).  (Myron Marston)
* `controller.controller_path` is set correctly for view specs in Rails 3.1+.
  (Andy Lindeman)
* Generated specs support module namespacing (e.g., in a Rails engine).
  (Andy Lindeman)
* `render` properly infers the view to be rendered in Rails 3.0 and 3.1
  (John Firebaugh)
* AutoTest mappings involving config/ work correctly (Brent J. Nordquist)
* Failures message for `be_new_record` are more useful (Andy Lindeman)

### 2.11.4 / 2012-10-14
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.11.0...v2.11.4)

Capybara-2.0 integration support:

* include RailsExampleGroup in spec/features (necessary when there is no AR)
* include Capybara::DSL and Capybara::RSpecMatchers in spec/features

See [https://github.com/jnicklas/capybara/pull/809](https://github.com/jnicklas/capybara/pull/809)
and [https://rubydoc.info/gems/rspec-rails/file/Capybara.md](https://rubydoc.info/gems/rspec-rails/file/Capybara.md)
for background.

2.11.1, .2, .3 were yanked due to errant documentation.

### 2.11.0 / 2012-07-07
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.10.1...v2.11.0)

Enhancements

* The generated `spec/spec_helper.rb` sets `config.order = "random"` so that
  specs run in random order by default.
* rename `render_template` to `have_rendered` (and alias to `render_template`
  for backward compatibility)
* The controller spec generated with `rails generate scaffold namespaced::model`
  matches the spec generated with `rails generate scaffold namespaced/model`
  (Kohei Hasegawa)

Bug fixes

* "uninitialized constant" errors are avoided when using using gems like
  `rspec-rails-uncommitted` that define `Rspec::Rails` before `rspec-rails`
  loads (Andy Lindeman)

### 2.10.1 / 2012-05-03
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.10.0...v2.10.1)

Bug fixes

* fix regression introduced in 2.10.0 that broke integration with Devise
  (https://github.com/rspec/rspec-rails/issues/534)
* remove generation of helper specs when running the scaffold generator, as
  Rails already does this (Jack Dempsey)

### 2.10.0 / 2012-05-03
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.9.0...v2.10.0)

Bug fixes

* `render_views` called in a spec can now override the config setting. (martinsvalin)
* Fix `render_views` for anonymous controllers on 1.8.7. (hudge, mudge)
* Eliminate use of deprecated `process_view_paths`
* Fix false negatives when using `route_to` matcher with `should_not`
* `controller` is no longer nil in `config.before` hooks
* Change `request.path_parameters` keys to symbols to match real Rails
  environment (Nathan Broadbent)
* Silence deprecation warnings in pre-2.9 generated view specs (Jonathan del
  Strother)

### 2.9.0 / 2012-03-17
[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.8.1...v2.9.0)

Enhancements

* add description method to RouteToMatcher (John Wulff)
* Run "db:test:clone_structure" instead of "db:test:prepare" if Active Record's
  schema format is ":sql". (Andrey Voronkov)

Bug fixes

* `mock_model(XXX).as_null_object.unknown_method` returns self again
* Generated view specs use different IDs for each attribute.

### 2.8.1 / 2012-01-04

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.8.0...v2.8.1)

NOTE: there was a change in rails-3.2.0.rc2 which broke compatibility with
stub_model in rspec-rails. This release fixes that issue, but it means that
you'll have to upgrade to rspec-rails-2.8.1 when you upgrade to rails >=
3.2.0.rc2.

* Bug fixes
    * Explicitly stub valid? in stub_model. Fixes stub_model for rails versions
      >= 3.2.0.rc2.

### 2.8.0 / 2012-01-04

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.8.0.rc2...v2.8.0)

* Enhancements
    * Eliminate deprecation warnings in generated view specs in Rails 3.2
    * Ensure namespaced helpers are included automatically (Evgeniy Dolzhenko)
    * Added cuke scenario documenting which routes are generated for anonymous
      controllers (Alan Shields)

### 2.8.0.rc2 / 2011-12-19

[Full Changelog](https://github.com/rspec/rspec-mocks/compare/v2.8.0.rc1...v2.8.0.rc2)

* Enhancements
    * Add session hash to generated controller specs (Thiago Almeida)
    * Eliminate deprecation warnings about InstanceMethods modules in Rails 3.2

* Bug fixes
    * Stub attribute accessor after `respond_to?` call on mocked model (Igor
      Afonov)

### 2.8.0.rc1 / 2011-11-06

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.7.0...v2.8.0.rc1)

* Enhancements
    * Removed unnecessary "config.mock_with :rspec" from spec_helper.rb (Paul
      Annesley)

* Changes
    * No API changes for rspec-rails in this release, but some internals
      changed to align with rspec-core-2.8

* [rspec-core](https://github.com/rspec/rspec-core/blob/master/Changelog.md)
* [rspec-expectations](https://github.com/rspec/rspec-expectations/blob/master/Changelog.md)
* [rspec-mocks](https://github.com/rspec/rspec-mocks/blob/master/Changelog.md)

### 2.7.0 / 2011-10-16

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.6.1...v2.7.0)

* Enhancements
  * `ActiveRecord::Relation` can use the `=~` matcher (Andy Lindeman)
  * Make generated controller spec more consistent with regard to ids
    (Brent J. Nordquist)
  * Less restrictive autotest mapping between spec and implementation files
    (José Valim)
  * `require 'rspec/autorun'` from generated `spec_helper.rb` (David Chelimsky)
  * add `bypass_rescue` (Lenny Marks)
  * `route_to` accepts query string (Marc Weil)

* Internal
  * Added specs for generators using ammeter (Alex Rothenberg)

* Bug fixes
  * Fix configuration/integration bug with rails 3.0 (fixed in 3.1) in which
    `fixure_file_upload` reads from `ActiveSupport::TestCase.fixture_path` and
    misses RSpec's configuration (David Chelimsky)
  * Support nested resource in view spec generator (David Chelimsky)
  * Define `primary_key` on class generated by `mock_model("WithAString")`
    (David Chelimsky)

### 2.6.1 / 2011-05-25

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.6.0...v2.6.1)

This release is compatible with rails-3.1.0.rc1, but not rails-3.1.0.beta1

* Bug fixes
  * fix controller specs with anonymous controllers with around filters
  * exclude spec directory from rcov metrics (Rodrigo Navarro)
  * guard against calling prerequisites on nil default rake task (Jack Dempsey)

### 2.6.0 / 2011-05-12

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.5.0...v2.6.0)

* Enhancements
  * rails 3 shortcuts for routing specs (Joe Fiorini)
  * support nested resources in generators (Tim McEwan)
  * require 'rspec/rails/mocks' to use `mock_model` without requiring the whole
    rails framework
  * Update the controller spec generated by the rails scaffold generator:
    * Add documentation to the generated spec
    * Use `any_instance` to avoid stubbing finders
    * Use real objects instead of `mock_model`
  * Update capybara integration to work with capy 0.4 and 1.0.0.beta
  * Decorate paths passed to `[append|prepend]_view_paths` with empty templates
    unless rendering views. (Mark Turner)

* Bug fixes
  * fix typo in "rake spec:statsetup" (Curtis Schofield)
  * expose named routes in anonymous controller specs (Andy Lindeman)
  * error when generating namespaced scaffold resources (Andy Lindeman)
  * Fix load order issue w/ Capybara (oleg dashevskii)
  * Fix monkey patches that broke due to internal changes in rails-3.1.0.beta1

### 2.5.0 / 2011-02-05

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.4.1...v2.5.0)

* Enhancements
  * use index_helper instead of table_name when generating specs (Reza
    Primardiansyah)

* Bug fixes
  * fixed bug in which `render_views` in a nested group set the value in its
    parent group.
  * only include MailerExampleGroup when it is defined (Steve Sloan)
  * mock_model.as_null_object.attribute.blank? returns false (Randy Schmidt)
  * fix typo in request specs (Paco Guzman)

### 2.4.1 / 2011-01-03

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.4.0...v2.4.1)

* Bug fixes
  * fixed bug caused by including some Rails modules before RSpec's
    RailsExampleGroup

### 2.4.0 / 2011-01-02

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.3.1...v2.4.0)

* Enhancements
  * include ApplicationHelper in helper object in helper specs
  * include request spec extensions in files in spec/integration
  * include controller spec extensions in groups that use type: :controller
    * same for :model, :view, :helper, :mailer, :request, :routing

* Bug fixes
  * restore global config.render_views so you only need to say it once
  * support overriding render_views in nested groups
  * matchers that delegate to Rails' assertions capture
    ActiveSupport::TestCase::Assertion (so they work properly now with
    should_not in Ruby 1.8.7 and 1.9.1)

* Deprecations
  * include_self_when_dir_matches

### 2.3.1 / 2010-12-16

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.3.0...v2.3.1)

* Bug fixes
  * respond_to? correctly handles 2 args
  * scaffold generator no longer fails on autotest directory

### 2.3.0 / 2010-12-12

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.2.1...v2.3.0)

* Changes
  * Generator no longer generates autotest/autodiscover.rb, as it is no longer
    needed (as of rspec-core-2.3.0)

### 2.2.1 / 2010-12-01

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.2.0...v2.2.1)

* Bug fixes
  * Depend on railties, activesupport, and actionpack instead of rails (Piotr
    Solnica)
  * Got webrat integration working properly across different types of specs

* Deprecations
  * --webrat-matchers flag for generators is deprecated. use --webrat instead.

### 2.2.0 / 2010-11-28

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.1.0...v2.2.0)

* Enhancements
  * Added stub_template in view specs

* Bug fixes
  * Properly include helpers in views (Jonathan del Strother)
  * Fix bug in which method missing led to a stack overflow
  * Fix stack overflow in request specs with open_session
  * Fix stack overflow in any spec when method_missing was invoked
  * Add gem dependency on rails ~> 3.0.0 (ensures bundler won't install
    rspec-rails-2 with rails-2 apps).

### 2.1.0 / 2010-11-07

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.0.1...v2.1.0)

* Enhancements
  * Move errors_on to ActiveModel to support other AM-compliant ORMs

* Bug fixes
  * Check for presence of ActiveRecord instead of checking Rails config
    (gets rspec out of the way of multiple ORMs in the same app)

### 2.0.1 / 2010-10-15

[Full Changelog](https://github.com/rspec/rspec-rails/compare/v2.0.0...v2.0.1)

* Enhancements
  * Add option to not generate request spec (--skip-request-specs)

* Bug fixes
  * Updated the mock_[model] method generated in controller specs so it adds
    any stubs submitted each time it is called.
  * Fixed bug where view assigns weren't making it to the view in view specs in Rails-3.0.1.
    (Emanuele Vicentini)

### 2.0.0 / 2010-10-10

[Full Changelog](https://github.com/rspec/rspec-rails/compare/ea6bdef...v2.0.0)

* Enhancements
  * ControllerExampleGroup uses controller as the implicit subject by default (Paul Rosania)
  * autotest mapping improvements (Andreas Neuhaus)
  * more cucumber features (Justin Ko)
  * clean up spec helper (Andre Arko)
  * add assign(name, value) to helper specs (Justin Ko)
  * stub_model supports primary keys other than id (Justin Ko)
  * support choice between Webrat/Capybara (Justin Ko)
  * support specs for 'abstract' subclasses of ActionController::Base (Mike Gehard)
  * be_a_new matcher supports args (Justin Ko)

* Bug fixes
  * support T::U components in mailer and request specs (Brasten Sager)
