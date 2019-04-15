//
//  PokemonViewController+saveContext.swift
//  PokemonData
//
//  Created by Angel Avila on 4/8/19.
//  Copyright © 2019 Angel Avila. All rights reserved.
//

import UIKit
import CoreData
import CoreStore

extension PokemonViewController {
    func saveContext(fetchedPokemon: [PokemonViewModel]) {
        
        let cachedPokemon = items.objectsInAllSections().map { PokemonViewModel(fromPokemon: $0) }
        
        var count = 500
        fetchedPokemon.forEach { pokemon in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(count), execute: {
                self.savePokemon(pokemon, cachedPokemon: cachedPokemon)
            })
            count += 500
        }
        
        deleteOldRecords(fetchedPokemon: fetchedPokemon, cachedPokemon: cachedPokemon)
        tableView.reloadData()
        
        saveChanges()
    }
    
    func saveChanges() {

    }
    
    private func savePokemon(_ pokemon: PokemonViewModel, cachedPokemon: [PokemonViewModel] = [PokemonViewModel]()) {
        
        let pokemonFromCache = cachedPokemon.filter { $0 == pokemon }.first
        
        if let cacheMon = pokemonFromCache {
            if cacheMon.shouldUpdateFrom(pokemon) {
                updatePokemon(pokemon)
            }
            return
        }
        
        stack.perform(asynchronous: { transaction in
            let poke = transaction.create(Into<Pokemon>())
            
            poke.name .= pokemon.name
            poke.number .= pokemon.number
            poke.type .= pokemon.type.rawValue
            print("Saving:", pokemon.name)
            
        }, completion: { _ in })
        
        
    }
    
    func updatePokemon(_ updatedPokemon: PokemonViewModel) {
        stack.perform(asynchronous: { transaction in
            
            let existingPoke = try transaction.fetchOne(
                From<Pokemon>()
                    .where(\.number == updatedPokemon.number))
            
            existingPoke?.name .= updatedPokemon.name
            existingPoke?.type .= updatedPokemon.type.rawValue
            
        }, completion: { _ in })
    }
    
    func deleteAll() {
        _ = try? stack.perform(
            synchronous: { (transaction) in
                
                try transaction.deleteAll(From<Pokemon>())
            }
        )
    }
    
    private func deleteOldRecords(fetchedPokemon: [PokemonViewModel], cachedPokemon: [PokemonViewModel]) {
        let pokemonToDelete = Set(cachedPokemon).subtracting(fetchedPokemon)
        pokemonToDelete.forEach { deletePokemon($0) }
        saveChanges()
    }
    
    func deletePokemon(_ pokemon: PokemonViewModel)  {
        stack.perform(
            asynchronous: { (transaction) in
                let pokemonToDelete = try transaction.fetchOne(
                    From<Pokemon>()
                        .where(\.number == pokemon.number))
                
                transaction.delete(pokemonToDelete)
        },
            completion: { _ in }
        )
    }
    
//    private func request(fromPokemon pokemon: PokemonViewModel) -> NSFetchRequest<Pokemon> {
//        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
//        fetchRequest.predicate = NSPredicate(format: "number == %@", NSNumber(value: pokemon.number))
//        return fetchRequest
//    }
}
