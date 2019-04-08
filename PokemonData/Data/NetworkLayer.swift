//
//  NetworkLayer.swift
//  PokemonData
//
//  Created by Angel Avila on 4/8/19.
//  Copyright © 2019 Angel Avila. All rights reserved.
//

import Foundation

protocol NetworkLayer {
    func getPokemon(completion: @escaping ((Result<[PokemonViewModel], Error>) -> ()))
}

class NetworkManager: NetworkLayer {
    func getPokemon(completion: @escaping ((Result<[PokemonViewModel], Error>) -> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
            
            let pokemon = [PokemonViewModel(name: "Bulbasaur", number: 1, type: .grass),
                           PokemonViewModel(name: "Charmander", number: 4, type: .fire),
                           PokemonViewModel(name: "Squirtle", number: 7, type: .water)]
            completion(.success(pokemon))
            
        }
    }
}
