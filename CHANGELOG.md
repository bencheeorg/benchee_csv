# unreleased

## Features

* raw run times are now also exported, so you can import them in your favorite tool. Thanks `@elpikel`
* use new csv library version (2.0+)

# 0.7.0 (2017-10-24)

## Features

* Benchee 0.10.0 compatibility
* All inputs and job name combination in one file again, so you can do whatever magic you desire with the CSV :)
* You can now specify the formatter as just `Benchee.Formatters.CSV`

# 0.6.0 (2017-05-07)

Benchee 0.8.0 compatibility and basic type specs.

# 0.5.0 (November 30, 2016)

Mainly Benchee 0.6.0 compatibility, support for multiple inputs and MOARE statistics.

## Features

* Benchee 0.6.0 compatibility with support for multiple inputs and accordingly generating multiple csv files
* Supply more statistics - minimum, maximum and sample_size
* print out information where the file was written to

## Bugfixes

* Remove 1.4.0-rc.0 warnings

# 0.4.0 (September 11, 2016)

Release to make usage with benchee 0.4.0 possible (also relax version requirement)

# 0.3.0 (July 11, 2016)

## Features
* `Benchee.Formatters.CSV.output/1` method that formats and writes to a configured file for you
* Compatibility with Benchee 0.3.0

# 0.2.0 (June 11, 2016)

## Features

* additionally consume the total standard deviation of iterations per second from Benchee 0.2.0 and dump it to CSV

# 0.1.0 (June 5, 2016)

Initial release
