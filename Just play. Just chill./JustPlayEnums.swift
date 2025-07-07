import Foundation

// MARK: - Базовые игровые сущности



/// Инвентарь игрока
struct Inventory {
    var items: [Item]
    var capacity: Int
}

/// Предмет в инвентаре
struct Item {
    var id: UUID
    var name: String
    var rarity: Rarity
    var itemType: ItemType
    var power: Int
}

/// Тип предмета
enum ItemType {
    case weapon
    case armor
    case potion
    case questItem
}

/// Редкость предмета
enum Rarity: String {
    case common = "Обычный"
    case rare = "Редкий"
    case epic = "Эпический"
    case legendary = "Легендарный"
}

/// Статы игрока
struct Stats {
    var strength: Int
    var agility: Int
    var intelligence: Int
    var vitality: Int
}

// MARK: - Локации и миры

/// Игровая локация
struct Location {
    var name: String
    var enemies: [Enemy]
    var treasures: [Treasure]
    var difficulty: Difficulty
}

/// Уровень сложности локации
enum Difficulty: Int {
    case easy = 1
    case medium = 5
    case hard = 10
}

/// Враг в локации
struct Enemy {
    var name: String
    var health: Int
    var attackPower: Int
    var reward: Reward
}

/// Награда за победу над врагом
struct Reward {
    var gold: Int
    var items: [Item]
    var experience: Int
}

/// Сундук с сокровищами
struct Treasure {
    var content: [Item]
    var gold: Int
    var isLocked: Bool
    var lockLevel: Int?
}

// MARK: - Квесты

/// Описание квеста
struct Quest {
    var title: String
    var description: String
    var objectives: [QuestObjective]
    var rewards: [Reward]
    var isCompleted: Bool
}

/// Цель квеста
struct QuestObjective {
    var description: String
    var completed: Bool
}

// MARK: - Пример использования (закомментирован)

/*
let sword = Item(id: UUID(), name: "Меч героя", rarity: .epic, itemType: .weapon, power: 50)
let player = Player(
    id: UUID(),
    name: "Артур",
    level: 10,
    experience: 1200,
    inventory: Inventory(items: [sword], capacity: 20),
    stats: Stats(strength: 80, agility: 60, intelligence: 40, vitality: 70)
)
*/

