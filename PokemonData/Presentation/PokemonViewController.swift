//
//  ContactsViewController.swift
//  CoreDataTests
//
//  Created by Angel Avila on 4/5/19.
//  Copyright © 2019 Regiztra. All rights reserved.
//

import UIKit
import CoreData

class PokemonCell: GenericCell<PokemonViewModel> {
    override var item: PokemonViewModel! {
        didSet {
            guard let label = textLabel, let item = item else { return }
            label.font = UIFont.regular
            label.textColor = .darkGray
            label.text = "\(item.number) - \(item.name) | Type: \(item.type.rawValue.capitalized)"
        }
    }
}

class PokemonViewController: GenericTableViewController<PokemonCell, PokemonViewModel> {
    
    var presenter: PokemonPresenter!
    var fetchedPokemon = [PokemonViewModel]()
    var managedContext: NSManagedObjectContext?
    
    init(withPresenter presenter: PokemonPresenter) {
        super.init(nibName: nil, bundle: nil)
        
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
        if indexPath.row < items.count, editingStyle == .delete {
            deletePokemon(items[indexPath.row])
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
}
