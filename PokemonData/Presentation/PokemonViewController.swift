//
//  ContactsViewController.swift
//  CoreDataTests
//
//  Created by Angel Avila on 4/5/19.
//  Copyright © 2019 Regiztra. All rights reserved.
//

import UIKit
import CoreData
import CoreStore

class PokemonCell: GenericCell<Pokemon> {
    override var item: Pokemon! {
        didSet {
            guard let label = textLabel, let item = item else { return }
            label.font = UIFont.regular
            label.textColor = .darkGray
            label.text = "\(item.number.value) - \(item.name.value) | Type: \(item.type.value.capitalized)"
        }
    }
}

class PokemonViewController: GenericTableViewController<PokemonCell, Pokemon> {
    
    var presenter: PokemonPresenter!
    var fetchedPokemon = [PokemonViewModel]()
    var managedContext: NSManagedObjectContext?
    
    init(withPresenter presenter: PokemonPresenter) {
        super.init(entityId: "Pokemon")
        
        
        
        stack = DataStack(
            CoreStoreSchema(
                modelVersion: "1",
                entities: [Entity<Pokemon>("Pokemon")],
                versionLock: [
                    "Pokemon": [0xa6, 0x0, 0x0, 0x0]])
        )
        
        try! stack.addStorageAndWait(
            SQLiteStore(
                fileName: "PokemonData.sqlite",
                localStorageOptions: .none))
        
        items = stack.monitorList(From<Pokemon>().orderBy(.ascending(\.number)))
        
        self.presenter = presenter
        
        getManagedContext()
        
        presenter.getPokemon { result in
            switch result {
                
            case .success(let pokemon):
                self.saveContext(pokemonArray: pokemon)
                break
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        fetchPokemonCache()
    }
    
    private func getManagedContext() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        tableView.clipsToBounds = true
        view.backgroundColor = .white
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < items.numberOfObjects(), editingStyle == .delete {
            
            stack.perform(asynchronous: { transaction in
                transaction.delete(self.items[indexPath])
            }, completion: { _ in })
            
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
}
