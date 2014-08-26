observe = (object, bindings, bind) ->
  Object.observe object, (changes) ->
    for change in changes
      {type, name, oldValue} = change
      newValue = obj[name]

      if (fn = bindings["#{name}:#{type}"])?
        switch type
          when 'add'
            fn.call bind, object, newValue
          when 'update'
            fn.call bind, object, newValue, oldValue
          when 'delete'
            fn.call bind, object, oldValue

      if (fn = bindings[name + ':*'])?
          fn.call bind, object,
            type:     type
            newValue: newValue
            oldValue: oldValue

module.exports = observe
