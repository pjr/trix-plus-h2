id = 0

class Trix.Attachment
  @attachments: {}

  @get: (id) ->
    @attachments[id]

  @forFile: (file) ->
    attachment = new this { contentType: file.type }
    attachment.file = file
    attachment

  constructor: (@attributes = {}) ->

  save: ->
    return this if @id
    @id = ++id
    @constructor.attachments[@id] = this
    this

  remove: ->
    delete @constructor.attachments[@id]
    @notifyHostDelegateOfFileRemoved()

  setAttributes: (attributes) =>
    for key, value of attributes
      @attributes[key] = value

    delete @file if @attributes.url

    @delegate?.attachmentDidChange(this)

  isPending: ->
    @file and not @attributes.url

  isImage: ->
    /image/.test(@attributes.contentType)

  toJSON: ->
    @attributes

  # Host delegate

  notifyHostDelegateOfFileRemoved: ->
    Trix.delegate?.fileRemoved?(@toJSON())

  notifyHostDelegateOfFileAdded: (targetElement) ->
    Trix.delegate?.fileAdded?.call(targetElement, @file, @setAttributes)