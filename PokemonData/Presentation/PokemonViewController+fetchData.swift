//
//  PokemonViewController+fetchData.swift
//  PokemonData
//
//  Created by Angel Avila on 4/8/19.
//  Copyright © 2019 Angel Avila. All rights reserved.
//

import UIKit
import CoreData

extension PokemonViewController {
    func fetchPokemonCache() {
        guard let managedContext = managedContext else { return }
        
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        
        do {
            let model = try managedContext.fetch(fetchRequest)
            
            model.forEach { pokemonModel in
                let pokemon = PokemonViewModel(name: pokemonModel.name ?? "?", number: Int(pokemonModel.number), type: Type.resolve(pokemonModel.type?.lowercased() ?? ""))
                print("Fetched:", pokemon.name)
                fetchedPokemon.append(pokemon)
                items.append(pokemon)
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
