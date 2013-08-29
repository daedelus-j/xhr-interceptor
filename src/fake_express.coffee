class FakeRequest
  constructor: ->

class FakeResponse
  constructor: (@xhr) ->
    @statusCode = 200
    @headers =
      'Content-Type': 'application/json'

  status: (code) ->
    @statusCode code
    @

  set: (field,value) ->
    if value and typeof field is 'string'
      this[field] = value
    else if typeof field is 'object'
      for header, value of field
        this[header] = value

  get: (field) ->
    this[field]

  send: (statusCode,body) ->
    if typeof status is 'number'
      return xhr.respond statusCode, @headers, body

    if typeof statusCode is 'string' and not body
      return xhr.respond @statusCode, @headers, statusCode

  json: (status,body) ->
    @set 'Content-Type', 'application/json'
    @send status, body

  type: (type) ->
    @headers['Content-Type'] = type

  links: (links) ->
    header = []
    for uri, link of links
      header.push "<#{link}>; rel=\"#{uri}\""
    @set 'Link', header.join ','

class FakeExpress
  constructor: (@server) ->
    @server.autoRespond = true
  get: (url, callback) ->
    @server.respondWith url, (xhr) ->
      callback(new FakeRequest(xhr),new FakeResponse)
      xhr.respond 200,
        'Content-Type': 'application/json'

module = FakeExpress

if typeof define is 'function' and define?.amd
  define -> module
else
  window.FakeExpress = module