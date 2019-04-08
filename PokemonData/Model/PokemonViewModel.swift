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
    
    func shouldUpdateFrom(_ pokemon: PokemonViewModel) -> Bool {
        return self.name != pokemon.name
    }
}

extension PokemonViewModel: Equatable {
    static func == (lhs: PokemonViewModel, rhs: PokemonViewModel) -> Bool {
        return lhs.number == rhs.number
    }
}

extension PokemonViewModel: Hashable {
}
