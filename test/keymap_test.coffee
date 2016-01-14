assert = require 'assert'
KeyMap = require '../app/assets/coffee/keymap'

describe 'KeyMap', ->

  testOps = {val: "returnvalue" ,op: -> @val}
  KeyMap.linkOps testOps

  it 'should map correctly', ->
    km = new KeyMap
    km.map 'c', 'op'
    assert km._mapping.c() is testOps.op()

  it 'should return the right fn', ->
    km = new KeyMap
    km.map 'c', 'op'
    assert (km.fnFromKey 'c')() is testOps.op()
