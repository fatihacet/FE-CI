class Box

  ###*
    Class for representing a box. A box is specified as a top, right, bottom
    and left.

    @constructor
    @param {Object} options Options object to hold top, right, bottom
    and left values.
  ###
  constructor: (options = {}) ->

    @top    = options.top    or 0
    @right  = options.right  or 0
    @bottom = options.bottom or 0
    @left   = options.left   or 0


  ###*
    Returns box width.

    @return {number} Box width.
  ###
  getWidth: ->
    return @right - @left


  ###*
    Returns box height.

    @return {number} Box height.
  ###
  getHeight: ->
    return @bottom - @top


  ###*
    Creates a copy of the box with the same dimensions.

    @return {Box} Cloned box.
  ###
  clone: ->
    return new Box { @top, @right, @bottom, @left }


  ###*
    Scales the box with given ratio.

    @param {!number} ratio Ratio to scale all dimensions.
  ###
  scale: (ratio) ->
    @top    *= ratio
    @right  *= ratio
    @bottom *= ratio
    @left   *= ratio
