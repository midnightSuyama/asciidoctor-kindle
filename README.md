# asciidoctor-kindle

Asciidoctor extension for converting html to mobi

* Fix HTML file (ContentType and StyleType)
* Create TOC file (kindle-toc.html)
* Create OPF file (kindle-package.opf)

## Installation

    $ gem install asciidoctor-kindle

## Usage

    $ asciidoctor-kindle example.adoc

or

    $ asciidoctor -r asciidoctor-kindle example.adoc
    $ kindlegen -o kindle-published.mobi kindle-package.opf

## Document Attributes

* `kindle-uid` - unique-identifier in OPF
* `kindle-description` - dc:description in OPF
* `kindle-cover` - cover-image in OPF

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/midnightSuyama/asciidoctor-kindle.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
