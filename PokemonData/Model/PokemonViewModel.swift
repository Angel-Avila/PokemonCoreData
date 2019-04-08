//
//  PokemonViewModel.swift
//  PokemonData
//
//  Created by Angel Avila on 4/5/19.
//  Copyright © 2019 Regiztra. All rights reserved.
//

import Foundation

struct PokemonViewModel {
    var name: String
    var number: Int
    var type: Type
    
    func shouldUpdateFrom(_ pokemon: PokemonViewModel) -> Bool {
        return self.name != pokemon.name || self.type != pokemon.type
    }
}

extension PokemonViewModel: Equatable {
    static func == (lhs: PokemonViewModel, rhs: PokemonViewModel) -> Bool {
        return lhs.number == rhs.number
    }
}

extension PokemonViewModel: Hashable {
}

enum Type: String, Hashable {
    case normal = "normal"
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case ice = "ice"
    case electric = "electric"
    case fighting = "fighting"
    case poison = "poison"
    case ground = "ground"
    case flying = "flying"
    case psychic = "psychic"
    case bug = "bug"
    case rock = "rock"
    case ghost = "ghost"
    case dark = "dark"
    case dragon = "dragon"
    case steel = "steel"
    case fairy = "fairy"
    
    static func resolve(_ type: String) -> Type {
        switch type {
        case "fire":
            return .fire
        case "water":
            return .water
        case "grass":
            return .grass
        case "ice":
            return .ice
        case "electric":
            return .electric
        case "fighting":
            return .fighting
        case "poison":
            return .poison
        case "ground":
            return .ground
        case "flying":
            return .flying
        case "psychic":
            return .psychic
        case "bug":
            return .bug
        case "rock":
            return .rock
        case "ghost":
            return .ghost
        case "dark":
            return .dark
        case "dragon":
            return .dragon
        case "steel":
            return .steel
        case "fairy":
            return .fairy
        default:
            return .normal
        }
    }
}
