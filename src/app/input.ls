import
  \./collection : {
    update-model
    collection-state, collection-props, field-state
  }
  '../utils': {local-date, input-datetime-string, server-date}

function wrap-target-value handler, wrap => (e) ->
  handler target: value: wrap e.target.value

function date-input-factory h, type=\date wrap-value=local-date =>
  ({value, on-change, on-input, ...props}) ->
    h \input Object.assign {type} props,
      value: wrap-value value
      if on-change then on-change: wrap-target-value on-change, server-date
      if on-input then on-input: wrap-target-value on-input, server-date

function datetime-input-factory h
  date-input-factory h, \datetime-local input-datetime-string

function input-actions dispatch, {model, id, field=\value}
  on-change: ->
    dispatch update-model {model, id, values: (field): it}

function field-props {
  own-props: {type, children, class-name, class: styles=class-name, default-value},
  value=default-value
}
  {value, type, children, class: styles}

function input-props {own-props, dispatch}: state
  Object.assign {},
    field-props state
    input-actions dispatch, own-props

function have-options {field, type=field.type || ''}
  type.starts-with \select

function select-source {field}: props
  config = if field.key then field else Object.assign key: field, props
  {key} = config
  collection = config.select || config.collection || key.replace /Id$/ ''
  model = config.model || collection
  request = {collection, model, fetch: \lazy}
  {...props, requests: [request]}

function model-options {models}
  options: models.map ({id, name}) -> value: id, label: name

export {field-props, input-props}
export {have-options, select-source, model-options}
export {date-input-factory, datetime-input-factory}
