--- yaml
layout: 'default'
---

header ->
  h2 'Archives'
for document in @documents
  if 0 is document.url.indexOf '/article'
    dateWrapper = @tool.moment document.date
    div '.row', ->
      span '.span2', dateWrapper.format('YYYY MMM DD')

      div '.span9', ->
        a href: document.url, property: 'dc:title', ->
          strong "#{document.title}"
        div -> small ->
          text ' posted in '
          span @tags.render '/site/tagmap.html', document.tags
          text ' by '
          author = @authors[ document.author ]
          if author
            a href: "#{author.url}", "#{author.name}"
          else
            text "#{document.author}"
