###
Twitter Bootstrap 2.1 compatible form controller, that:
- prevents default submit event
- auto-serializes to given Spine.Model
- flags errorneus fields if model validation fails

Usage:
    new FormController
      el: $ '#some-rendered-form'
      model: MySpineModel
###
class FormController extends Spine.Controller
  events:
    '.submit': 'submit'

  elements:
    ':input': 'inputs'

  constructor: ->
    super

    @fields   = []
    @$inputs  = {}
    for input in @inputs
      $input = $ input
      name = $input.attr 'name'

      if name in @model.attributes
        @fields.push name
        @$inputs[name] = $input

  submit: (e) ->
    e.preventDefault()

    model = @model.fromForm @el
    if model.save()
      @unerrorize field for field in @fields
    else
      invalidFields = model.validate()
      @errorize field, invalidFields[field] for field of invalidFields

  errorize: (field, message) ->
    $input = @$inputs[field]
    $input.parents('.control-group').addClass 'error'
    $input.addClass 'error'
    $input.siblings('.help-inline').text message

  unerrorize: (field) ->
    $input = @$inputs[field]
    $input.parents('.control-group').removeClass 'error'
    $input.removeClass 'error'
    $input.siblings('.help-inline').text ''
