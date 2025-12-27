//
//  type.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/5.
//

import SwiftUI

struct type: Identifiable {
    var id = UUID() // 自動生成唯一 ID
    var ele: String
    var pic1 : ImageResource
    var pic2 : ImageResource
    var pic3 : ImageResource = .fireback
    var pokemons : [Pokemon] = firPokemon
}

let typelist : [type] = [type(ele:"Fire", pic1:.fire, pic2: .firePoke, pic3: .fireback, pokemons: firPokemon), type(ele: "Water", pic1: .water, pic2: .watPoke, pic3:.waterback, pokemons: waterPokemon), type(ele: "Eletric", pic1: .electric, pic2: .elePoke, pic3:.eleback, pokemons: electricPokemon), type(ele: "iron", pic1: .iron, pic2: .ironPoke, pic3:.ironback, pokemons: steelPokemon), type(ele: "Psychic", pic1: .psy, pic2: .psyPoke, pic3:.psyback, pokemons: psyPokemon)]
