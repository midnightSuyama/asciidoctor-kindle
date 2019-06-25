require 'minitest/autorun'
require 'minitest/hooks/test'
require 'asciidoctor'
require 'asciidoctor/cli'
require 'tmpdir'

class TestAsciidoctorKindle < Minitest::Test
  include Minitest::Hooks

  def before_all
    super
    @tmpdir = Dir.mktmpdir

    options = Asciidoctor::Cli::Options.new
    options[:requires]    = [File.expand_path('../../lib/asciidoctor-kindle', __FILE__)]
    options[:output_file] = File.join(@tmpdir, 'kindle-content.html')
    options.parse! [File.expand_path('../fixtures/content.adoc', __FILE__)]

    invoker = Asciidoctor::Cli::Invoker.new options
    invoker.invoke!
  end

  def after_all
    FileUtils.rm_rf(@tmpdir)
    super
  end

  def test_html
    assert File.exist? File.join(@tmpdir, 'kindle-content.html')
  end

  def test_toc
    assert File.exist? File.join(@tmpdir, 'kindle-toc.html')
  end

  def test_opf
    assert File.exist? File.join(@tmpdir, 'kindle-package.opf')
  end
end
