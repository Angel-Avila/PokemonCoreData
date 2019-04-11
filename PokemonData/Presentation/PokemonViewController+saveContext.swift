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
        pokemonArray.forEach { pokemon in
            self.savePokemon(pokemon)
        }
        
        deleteOldRecords()
        tableView.reloadData()
        
        saveChanges()
    }
    
    func saveChanges() {
        guard let managedContext = managedContext else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func savePokemon(_ pokemon: PokemonViewModel) {
        guard let managedContext = managedContext else { return }
        
        let prefetchedPokemon = fetchedPokemon.filter { $0 == pokemon }.first
        
        if let prefetched = prefetchedPokemon {
            if prefetched.shouldUpdateFrom(pokemon) {
                updatePokemon(pokemon)
            }
            return
        }

        let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: managedContext)!
        
        let pokemonObject = NSManagedObject(entity: entity, insertInto: managedContext)
         
        pokemonObject.setValue(pokemon.name, forKeyPath: "name")
        pokemonObject.setValue(pokemon.number, forKeyPath: "number")
        pokemonObject.setValue(pokemon.type.rawValue, forKey: "type")
        
        stack.perform(asynchronous: { transaction in
            let poke = transaction.create(Into<Pokemon>())
            
            poke.name .= pokemon.name
            poke.number .= pokemon.number
            poke.type .= pokemon.type.rawValue
            
        }, completion: { _ in })
        
        fetchedPokemon.append(pokemon)
        print("Saving:", pokemon.name)
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
