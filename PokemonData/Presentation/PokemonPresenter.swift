//
//  PokemonPresenter.swift
//  CoreData
//
//  Created by Angel Avila on 4/5/19.
//  Copyright © 2019 Regiztra. All rights reserved.
//

import Foundation

protocol PokemonPresenter {
    func getPokemon(completion: @escaping ((Result<[PokemonViewModel], Error>) -> ()))
}

class PokemonPresenterImpl: PokemonPresenter {
    
    var networkLayer: NetworkLayer!
    
    init(withNetworkLayer networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    func getPokemon(completion: @escaping ((Result<[PokemonViewModel], Error>) -> ())) {
        networkLayer.getPokemon { result in
            completion(result)
        }
    }
    
}
