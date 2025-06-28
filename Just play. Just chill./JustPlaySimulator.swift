import Foundation

// MARK: - Game Entities

struct Zombie {
    var id: UUID = UUID()
    var name: String = "Zombie_$Int.random(in: 100...999))"
    var health: Int = Int.random(in: 20...100)
    var isBurning: Bool = false
    var hasEatenBrainToday: Bool = false
    
    mutating func takeDamage(_ amount: Int) {
        health = max(0, health - amount)
        if health == 0 {
            print("$name) has been destroyed.")
        }
    }

    func speak() {
        print("Braaaains...")
    }
}

class Player {
    var name: String
    var inventory: [String] = ["Baseball Bat", "Empty Soda Can", "Map to nowhere"]
    
    init(name: String) {
        self.name = name
    }
    
    func lookAround() {
        let possibleEvents = [
            "You see a shadow.",
            "A squirrel runs by.",
            "It's quiet. Too quiet.",
            "There's a weird smell.",
            "Nothing here."
        ]
        print(possibleEvents.randomElement() ?? "Error: No nothing found.")
    }
}

// MARK: - Game Logic (Fake)

enum GameState {
    case running
    case paused
    case gameOver
    case loading
}

func startZombieSimulation() {
    let zombies = Array(repeating: Zombie(), count: 5)
    let player = Player(name: "Survivor_$UUID().uuidString.prefix(4))")

    print("Zombie Apocalypse Simulator v0.0.1")
    
    for zombie in zombies {
        zombie.speak()
        player.lookAround()
    }

    simulateBattle()
}

func simulateBattle() {
    let outcome = ["Player wins!", "Zombie wins!", "They both disappear mysteriously"].randomElement()!
    print("Battle result: $outcome)")
}

// MARK: - Dummy Data and Unused Functions

let brainImage = Data("fake_brain_texture_data".utf8)
let zombieNames = ["Grrr", "Muncher", "SlowWalker", "Zombo", "SleepyZ"]

func unusedFunctionThatDoesNothing() {
    let tempArray = (0...100).map { _ in "Useless String" }
    _ = tempArray.joined(separator: ", ")
}

// MARK: - Run the Simulation (But not really)

//startZombieSimulation()

//print("Simulation finished. Probably.")
