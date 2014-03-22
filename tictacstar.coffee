@Cells = new Meteor.Collection 'cells'

getWinner = ->

  winningCombos = [
    [0,1,2]
    [3,4,5]
    [6,7,8]
    [0,3,6]
    [1,4,7]
    [2,5,8]
    [6,4,2]
    [0,4,8]
  ]

  board = Cells.find().map (c) -> c.piece

  winner = undefined
  for combo in winningCombos
    if board[combo[0]] == board[combo[1]] == board[combo[2]] != undefined
      winner = board[combo[0]]
      break
  winner


if Meteor.isClient
  turn = ->
    if (Cells.find({piece:{$exists:true}}).count()) % 2 == 0 then 'X' else 'O'

  Template.board.helpers
    cells: -> Cells.find()
    turn: -> turn()
    winner: -> getWinner()

  Template.board.events
    'click .cell': ->
      Cells.update { _id: @_id }, { $set: { piece: getWinner() || turn() } }

    'click #reset': ->
      Meteor.call 'resetGame'

if Meteor.isServer

  Meteor.methods
    'resetGame': ->
      Cells.update {}, { $unset: { piece: true } }, { multi: true }

  Meteor.startup ->
    if Cells.find().count() == 0
      for i in [0..8]
        Cells.insert { _id: "#{i}" }