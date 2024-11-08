//
//  Pokemon.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/5.
//
import SwiftUI

struct Pokemon: Identifiable {
    var id = UUID()
    var name: String
    var hp: Int
    var move: String
    var damage: Int
    var description: String
    var rarity: Int
    var price: Double
    var image: Image
    init(name: String, hp: Int, move: String, damage: Int, description: String, rarity: Int, image: Image) {
            self.name = name
            self.hp = hp
            self.move = move
            self.damage = damage
            self.description = description
            self.rarity = rarity
            self.image = image
            self.price = Double(rarity * 300) // 初始價錢為稀有度 * 300 台幣
        }
}

let firPokemon: [Pokemon] = [
    Pokemon(
        name: "Charmander",
        hp: 60,
        move: "Ember",
        damage: 30,
        description: "Discard a Fire Energy from this Pokémon.",
        rarity: 1,
        image: Image("charmander_image") // 此處需將圖片加入資源
    ),
    Pokemon(
        name: "Charmeleon",
        hp: 90,
        move: "Fire Claws",
        damage: 60,
        description: "",
        rarity: 2,
        image: Image("charmeleon_image") // 此處需將圖片加入資源
    ),
    Pokemon(
        name: "Charizard",
        hp: 150,
        move: "Fire Spin",
        damage: 150,
        description: "Discard 2 Fire Energy from this Pokémon.",
        rarity: 3,
        image: Image("charizard_image") // 此處需將圖片加入資源
    ),
    Pokemon(
        name: "Charizard EX",
        hp: 180,
        move: "Crimson Storm",
        damage: 200,
        description: "Discard 2 Fire Energy from this Pokémon.",
        rarity: 4,
        image: Image("charizard_ex_image") // 確保此圖片存在於資源中
    ),
    Pokemon(
        name: "Moltres",
        hp: 100,
        move: "Sky Attack",
        damage: 130,
        description: "Flip a coin. If tails, this attack does nothing.",
        rarity: 3,
        image: Image("moltres_image")
    ),
    Pokemon(
        name: "Moltres EX",
        hp: 140,
        move: "Inferno Dance",
        damage: 70,
        description: "Flip 3 coins. Take an amount of Fire Energy from your Energy Zone equal to the number of heads and attach it to your Benched Pokémon in any way you like.",
        rarity: 4,
        image: Image("moltres_ex_image")
    )
]

let waterPokemon: [Pokemon] = [
    Pokemon(
        name: "Omanyte",
        hp: 90,
        move: "Water Gun",
        damage: 40,
        description: "Because some Omanyte manage to escape after being restored or are released into the wild by people, this species is becoming a problem.",
        rarity: 2,
        image: Image("Omanyte") // Replace with actual image reference
    ),
    Pokemon(
        name: "Omastar",
        hp: 140,
        move: "Ancient Whirlpool",
        damage: 70,
        description: "Overawed though by a large and heavy shell, Omastar couldn’t move very fast. Some say it went extinct because it was unable to catch food.",
        rarity: 3,
        image: Image("Omastar")
    ),
    Pokemon(
        name: "Articuno",
        hp: 100,
        move: "Ice Beam",
        damage: 60,
        description: "It is said that the Pokémon's beautiful blue wings are made of ice. It flies over snowy mountains, its long tail fluttering along behind it.",
        rarity: 5,
        image: Image("Articuno")
    ),
    Pokemon(
        name: "Articuno EX",
        hp: 140,
        move: "Blizzard",
        damage: 80,
        description: "This attack also does 10 damage to each of your opponent’s Benched Pokémon.",
        rarity: 6,
        image: Image("ArticunoEX")
    ),
    Pokemon(
        name: "Ducklett",
        hp: 50,
        move: "Flap",
        damage: 30,
        description: "When attacked, it uses its feathers to splash water, escaping under cover of the spray.",
        rarity: 1,
        image: Image("Ducklett")
    ),
    Pokemon(
        name: "Swanna",
        hp: 90,
        move: "Wing Attack",
        damage: 70,
        description: "Despite their elegant appearance, they can flap their wings strongly and fly for thousands of miles.",
        rarity: 2,
        image: Image("Swanna")
    ),
    Pokemon(
        name: "Froakie",
        hp: 60,
        move: "Flop",
        damage: 10,
        description: "It secretes flexible bubbles from its chest and back. The bubbles reduce the damage it would otherwise take when attacked.",
        rarity: 1,
        image: Image("Froakie")
    ),
    Pokemon(
        name: "Frogadier",
        hp: 80,
        move: "Water Drip",
        damage: 30,
        description: "It can throw bubble-covered pebbles with precise control, leaving empty areas up to a hundred feet away.",
        rarity: 3,
        image: Image("Frogadier")
    )
]

let electricPokemon: [Pokemon] = [
    Pokemon(
        name: "Magneton",
        hp: 80,
        move: "Spinning Attack",
        damage: 60,
        description: "Three Magnemite are linked by a strong magnetic force. Earaches will occur if you get too close.",
        rarity: 3,
        image: Image("Magneton") // Replace with actual image reference
    ),
    Pokemon(
        name: "Voltorb",
        hp: 60,
        move: "Tackle",
        damage: 20,
        description: "It rolls to move. If the ground is uneven, a sudden jolt from hitting a bump can cause it to explode.",
        rarity: 1,
        image: Image("Voltorb")
    ),
    Pokemon(
        name: "Electrode",
        hp: 80,
        move: "Electro Ball",
        damage: 70,
        description: "The more energy it charges up, the faster it gets. But this also makes it more likely to explode.",
        rarity: 2,
        image: Image("Electrode")
    ),
    Pokemon(
        name: "Jolteon",
        hp: 90,
        move: "Pin Missile",
        damage: 40,
        description: "It concentrates the weak electric charges emitted by its cells and launches wicked lightning bolts.",
        rarity: 4,
        image: Image("Jolteon")
    ),
    Pokemon(
        name: "Zapdos",
        hp: 100,
        move: "Raging Thunder",
        damage: 100,
        description: "This Pokémon has complete control over electricity. There are tales of Zapdos nesting in the dark depths of pitch-black thunderclouds.",
        rarity: 5,
        image: Image("Zapdos")
    ),
    Pokemon(
        name: "Zapdos EX",
        hp: 130,
        move: "Thundering Hurricane",
        damage: 50,
        description: "Flip 4 coins. This attack does 50 damage for each heads.",
        rarity: 6,
        image: Image("ZapdosEX")
    )
]

let steelPokemon: [Pokemon] = [
    Pokemon(
        name: "Mawile",
        hp: 70,
        move: "Crunch",
        damage: 20,
        description: "It has two docile-looking faces. It fools foes into complacency, then bites with its huge, relentless jaws.",
        rarity: 3,
        image: Image("Mawile") // Replace with actual image reference
    ),
    Pokemon(
        name: "Pawniard",
        hp: 50,
        move: "Pierce",
        damage: 30,
        description: "Pawniard will ruthlessly challenge even powerful foes. In a pinch, it will cling to opponents and pierce them with the blades all over its body.",
        rarity: 2,
        image: Image("Pawniard")
    ),
    Pokemon(
        name: "Bisharp",
        hp: 90,
        move: "Metal Claw",
        damage: 70,
        description: "This Pokémon commands a group of several Pawniard. Groups that are defeated in territorial disputes are absorbed by the winning side.",
        rarity: 4,
        image: Image("Bisharp")
    ),
    Pokemon(
        name: "Meltan",
        hp: 60,
        move: "Amass",
        damage: 0, // This move adds energy, no damage
        description: "It dissolves and eats metal. Circulating liquid metal within its body is how it generates energy.",
        rarity: 2,
        image: Image("Meltan")
    ),
    Pokemon(
        name: "Melmetal",
        hp: 130,
        move: "Heavy Impact",
        damage: 120,
        description: "At the end of its life-span, Melmetal will rust and fall apart. The small shards left behind will eventually be reborn as Meltan.",
        rarity: 5,
        image: Image("Melmetal")
    )
]

let psyPokemon: [Pokemon] = [
    Pokemon(
        name: "Mewtwo",
        hp: 120,
        move: "Power Blast",
        damage: 120,
        description: "It was created by a scientist after years of horrific gene-splicing and DNA-engineering experiments.",
        rarity: 5,
        image: Image("mewtwo") // replace with actual image reference
    ),

    Pokemon(
        name: "Mewtwo EX",
        hp: 150,
        move: "Psydrive",
        damage: 150,
        description: "EX rule: When your Pokémon EX is Knocked Out, your opponent gets 2 points.",
        rarity: 6,
        image: Image("mewtwoEX") // replace with actual image reference
    ),

    Pokemon(
        name: "Ralts",
        hp: 60,
        move: "Ram",
        damage: 10,
        description: "The horns on its head provide a strong power that enables it to sense people's emotions.",
        rarity: 2,
        image: Image("ralts") // replace with actual image reference
    ),

    Pokemon(
        name: "Kirlia",
        hp: 80,
        move: "Smack",
        damage: 30,
        description: "It has a psychic power that enables it to distort the space around it and see into the future.",
        rarity: 3,
        image: Image("kirlia") // replace with actual image reference
    ),

    Pokemon(
        name: "Gardevoir",
        hp: 110,
        move: "Psyshot",
        damage: 60,
        description: "To protect its Trainer, it will expend all its psychic power to create a small black hole.",
        rarity: 4,
        image: Image("gardevoir") // replace with actual image reference
    )
]
