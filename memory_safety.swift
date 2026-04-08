import Foundation

var stepSize = 1
@MainActor
func increment(_ number: inout Int) {
    number += stepSize
}
//increment(&stepSize)
// error coz stepsize memory is passed and it is also being read
var copyOfStepSize = stepSize
increment(&copyOfStepSize)
stepSize = copyOfStepSize

func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)
//balance(&playerOneScore, &playerOneScore) - error

struct Player {
    var name: String
    var health: Int
    var energy: Int
    static let maxHealth = 10
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)

//  Conflict: same instance used
//oscar.shareHealth(with: &oscar)

var playerInformation = (health: 10, energy: 20)
//  Conflict: whole tuple treated as one memory location
//balance(&playerInformation.health, &playerInformation.energy)

var holly = Player(name: "Holly", health: 10, energy: 10)
//  Conflict
//balance(&holly.health, &holly.energy)

func someFunction() {
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    // Allowed (compiler can guarantee safety)
    balance(&oscar.health, &oscar.energy)
}
someFunction()
