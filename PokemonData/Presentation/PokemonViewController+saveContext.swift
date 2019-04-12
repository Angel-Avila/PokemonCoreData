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
    func saveContext(pokemonArray: [PokemonViewModel]) {
        var count = 500
        pokemonArray.forEach { pokemon in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(count), execute: {
                self.savePokemon(pokemon)
            })
            count += 500
        }
        
        deleteOldRecords()
        tableView.reloadData()
        
        saveChanges()
    }
    
    func saveChanges() {

    }
    
    private func savePokemon(_ pokemon: PokemonViewModel) {
        
        let prefetchedPokemon = fetchedPokemon.filter { $0 == pokemon }.first
        
        if let prefetched = prefetchedPokemon {
            if prefetched.shouldUpdateFrom(pokemon) {
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
    
    func updatePokemon(_ pokemon: PokemonViewModel) {
//        guard let managedContext = managedContext else { return }
        
//        let fetchRequest = request(fromPokemon: pokemon)
//
//        do {
//            let model = try managedContext.fetch(fetchRequest)
//
//            guard let pokemonToUpdate = model.first else { return }
//
//            print("Updating:", pokemon.name)
//            pokemonToUpdate.setValue(pokemon.name, forKey: "name")
//            pokemonToUpdate.setValue(pokemon.type.rawValue, forKey: "type")
//
//            model.forEach { pokemonModel in
//                let name = pokemonModel.name ?? "?"
//                let number = Int(pokemonModel.number)
//                let type = Type.resolve(pokemonModel.type?.lowercased() ?? "")
//
//                let pokemon = PokemonViewModel(name: name, number: number, type: type)
//
//                if let index = items.firstIndex(of: pokemon), items.contains(pokemon) {
//                    items[index] = pokemon
//                }
//            }
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
    
    func deleteAll() {
        _ = try? stack.perform(
            synchronous: { (transaction) in
                
                try transaction.deleteAll(From<Pokemon>())
            }
        )
    }
    
    private func deleteOldRecords() {
//        let pokemonToDelete = Set(items).subtracting(fetchedPokemon)
//        pokemonToDelete.forEach { deletePokemon($0) }
//        saveChanges()
    }
    
    func deletePokemon(_ pokemon: PokemonViewModel)  {
//        guard let managedContext = managedContext else { return }
        
//        let fetchRequest = request(fromPokemon: pokemon)
//
//        do {
//            let model = try managedContext.fetch(fetchRequest)
//
//            guard let pokemonToDelete = model.first else { return }
//
//            print("Deleting:", pokemon.name)
//            managedContext.delete(pokemonToDelete)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
    
//    private func request(fromPokemon pokemon: PokemonViewModel) -> NSFetchRequest<Pokemon> {
//        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
//        fetchRequest.predicate = NSPredicate(format: "number == %@", NSNumber(value: pokemon.number))
//        return fetchRequest
//    }
}
