Humanable = require './humanable'

h = Humanable(['ms', 1000, 'second, s, sec', 60, 'min, m, minute',60, 'hour,h',24, 'day,d'])
h.parse('12hour','day')