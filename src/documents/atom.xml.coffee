---
date: '2000-1-1'
---

###
encodeHtml = (doc) ->
  i = doc.length;
  aRet = []

  while (i--) {
    iC = str[i].charCodeAt();
    if (iC < 65 || iC > 127 || (iC>90 && iC<97)) {
      aRet[i] = '&#'+iC+';';
    } else {
      aRet[i] = str[i];
    }
  }

  aRet.join('');
###

renderContent = (doc, siteUrl) ->
  rendered = doc.contentRenderedWithoutLayouts

  rendered = rendered.replace('src="/articles', "src=\"#{siteUrl}/articles")

  text '<![CDATA[\n'
  text rendered
  text ']]>\n'

anEntry = (document) ->
  tag 'entry', ->
    title '<![CDATA[ ' + document.title + ' ]]>'
    tag 'link', href: "#{@site.url}#{document.url}"
    tag 'updated', document.date.toIsoDateString()
    tag 'id', "#{@site.url}#{document.url}"
    tag 'content', type: 'html', -> renderContent document, @site.url

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'feed', xmlns: 'http://www.w3.org/2005/Atom', ->
  title '<![CDATA[ ' + @site.title + ' ]]>'
  tag 'link', href: "#{@site.url}/atom.xml", rel: 'self'
  tag 'link', href: @site.url
  tag 'updated', @site.date.toIsoDateString()
  tag 'id', @site.url
  for document in @documents
    if 0 is document.url.indexOf '/authors'
      tag 'author', ->
        tag 'name', document.name
        tag 'email', document.email

  i=0
  for document in @documents
    if 0 is document.url.indexOf '/articles'
      i++
      if i < 10
        anEntry document 

