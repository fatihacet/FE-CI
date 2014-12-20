describe 'Box', ->

  beforeEach ->
    box      = new Box
      top    : 200
      right  : 400
      bottom : 400
      left   : 100


  it 'should have 0 values by default', ->
    box = new Box

    expect(box.top).toBe    0
    expect(box.right).toBe  0
    expect(box.bottom).toBe 0
    expect(box.left).toBe   0


  it 'should have correct values', ->
    expect(box.top).toBe    200
    expect(box.right).toBe  400
    expect(box.bottom).toBe 400
    expect(box.left).toBe   100


  it 'should return correct width', ->
    expect(box.getWidth()).toBe 300


  it 'should return correct height', ->
    expect(box.getHeight()).toBe 200


  it 'should scale the box correctly', ->
    box.scale 2

    expect(box.top).toBe    400
    expect(box.right).toBe  800
    expect(box.bottom).toBe 800
    expect(box.left).toBe   200


  it 'should return correct width and height after box scaled', ->
    box.scale 2

    expect(box.getWidth()).toBe  600
    expect(box.getHeight()).toBe 400
