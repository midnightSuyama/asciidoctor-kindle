require 'asciidoctor/extensions'

include Asciidoctor

class KindlePostprocessor < Extensions::Postprocessor
  TocName = 'kindle-toc.html'
  OpfName = 'kindle-package.opf'

  def process(doc, output)
    generate_toc(doc)
    generate_opf(doc)

    content_type = %(<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">)
    style_type   = %(<style type="text/css">)
    output.sub(/<head>(.*)<\/head>/m) do
      "<head>#{content_type}#{$1.gsub(/<style>/m, style_type)}</head>"
    end
  end

  def generate_toc(doc)
    params = {
      sectnumlevels: doc.attr('sectnumlevels', '3').to_i,
      toclevels:     doc.attr('toclevels', '2').to_i,
      outfile:       doc.attr('outfile')
    }

    toc = ['<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8"></head><body><nav epub:type="toc">']
    toc << orderedlist(doc, params)
    toc << '</nav></body></html>'
    str = toc * LF

    File.write(File.join(doc.attr('outdir'), TocName), str)
  end

  def generate_opf(doc)
    uid          = doc.attr('kindle-uid', 'asciidoctor-kindle')
    title        = doc.attr('doctitle')
    creator      = doc.attr('author')
    description  = doc.attr('kindle-description')
    publisher    = doc.attr('kindle-publisher', doc.attr('author'))
    date         = doc.attr('docdate')
    language     = doc.attr('lang', 'en')
    content_path = doc.attr('outfile')
    toc_path     = File.join(doc.attr('outdir'), TocName)
    cover_path   = doc.attr('kindle-cover')

    str = %(<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://www.idpf.org/2007/opf" version="2.0" unique-identifier="#{uid}">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
    <dc:title>#{title}</dc:title>
    <dc:creator>#{creator}</dc:creator>
    <dc:description>#{description}</dc:description>
    <dc:publisher>#{publisher}</dc:publisher>
    <dc:date>#{date}</dc:date>
    <dc:language>#{language}</dc:language>
  </metadata>
  <manifest>
    <item id="content" media-type="text/html" href="#{content_path}" />
    <item id="toc" media-type="text/html" href="#{toc_path}" properties="nav" />
    #{%(<item id="cover" media-type="image/jpeg" href="#{cover_path}" properties="cover-image" />) if cover_path}
  </manifest>
  <spine>
    <itemref idref="content" />
  </spine>
  <guide>
    #{%(<reference type="toc" title="Table of Contents" href="#{content_path}" />) if doc.attr?('toc')}
  </guide>
</package>)

    File.write(File.join(doc.attr('outdir'), OpfName), str)
  end

  def orderedlist(node, params)
    return unless node.sections?
    result = ['<ol>']
    node.sections.each do |section|
      title = section.title
      title = %(#{section.sectnum} #{title}) if section.numbered && section.level <= params[:sectnumlevels]
      if section.level < params[:toclevels] && (children = orderedlist(section, params))
        result << %(<li><a href="#{params[:outfile]}##{section.id}">#{title}</a>)
        result << children
        result << '</li>'
      else
        result << %(<li><a href="#{params[:outfile]}##{section.id}">#{title}</a></li>)
      end
    end
    result << '</ol>'
    result * LF
  end
end

Extensions.register do
  postprocessor KindlePostprocessor
end
