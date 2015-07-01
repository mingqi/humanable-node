assert = require 'assert'

to_float = (str) ->
  if /^\d+(\.\d*)?$/.test(str)
    return parseFloat str
  return null

###
crate a Humable by specified a scale, e.g 
['b,B',1024,'kb,KB',1024, 'm, M, mb, MB', 1024, 'g, G, gb, GB', 1024, 'T, TB']
###
module.exports = Humanable = (scale) ->
  assert.ok(scale.length % 2 == 1, 'scale list must be odd')
  scale_num = Math.floor(scale.length / 2) + 1
  _units = [0...scale_num].map (i) ->
    scale[i*2].split(',').map (item) -> item.trim()

  _scales = [1...scale_num].map (i) ->
    scale[i*2-1]
  _scales.unshift(1)

  _unit_index = (unit) ->
    for i in [0..._units.length]
      if _units[i].indexOf(unit) >=0
        return i

    return -1
  
  
  return {
    parse : (str, unit) ->
      if to_float(str)
        return to_float(str)
      unit ?= _units[0][0]
      m = /^(\d+(\.\d+)?)([A-Za-z]+)$/.exec str
      return null if not m
      num = parseFloat(m[1])
      from_unit = m[3]
      from_index = _unit_index(from_unit) 
      if from_index < 0
        throw new Error("#{from_unit} is not a illegal unit")
      to_index = _unit_index(unit)
      if to_index < 0
        throw new Error("#{unit} is not a illegal unit")

      if from_index == to_index
        return num
      else if from_index > to_index
        for scale in _scales[to_index+1..from_index] 
          num = num * scale
        return num
      else
        for scale in _scales[from_index+1..to_index] 
          num = num / scale
        return num 

    
    format : (str) ->
      # ...
    
    } 
