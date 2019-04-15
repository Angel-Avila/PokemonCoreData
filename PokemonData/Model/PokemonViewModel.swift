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
    
    init(name: String, number: Int, type: Type) {
        self.name = name
        self.number = number
        self.type = type
    }
    
    init(fromPokemon pokemon: Pokemon) {
        self.init(name: pokemon.name.value, number: pokemon.number.value, type: Type.resolve(pokemon.type.value))
    }
    
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
    case Normal
    case Fire
    case Water
    case Grass
    case Ice
    case Electric
    case Fighting
    case Poison
    case Ground
    case Flying
    case Psychic
    case Bug
    case Rock
    case Ghost
    case Dark
    case Dragon
    case Steel
    case Fairy
    
    static func resolve(_ type: String) -> Type {
        switch type.lowercased() {
        case "fire":
            return .Fire
        case "water":
            return .Water
        case "grass":
            return .Grass
        case "ice":
            return .Ice
        case "electric":
            return .Electric
        case "fighting":
            return .Fighting
        case "poison":
            return .Poison
        case "ground":
            return .Ground
        case "flying":
            return .Flying
        case "psychic":
            return .Psychic
        case "bug":
            return .Bug
        case "rock":
            return .Rock
        case "ghost":
            return .Ghost
        case "dark":
            return .Dark
        case "dragon":
            return .Dragon
        case "steel":
            return .Steel
        case "fairy":
            return .Fairy
        default:
            return .Normal
        }
    }
}
