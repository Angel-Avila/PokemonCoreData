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
import PinLayout

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

class PokemonViewController: UITableViewController {
    
    // MARK: Vars
    
    var presenter: PokemonPresenter!
    var fetchedPokemon = [PokemonViewModel]()
    
    var stack: DataStack!
    var items: ListMonitor<Pokemon>!
    let cellId = "id"

    // MARK: Init & deinit
    
    deinit {
        items.removeObserver(self)
    }
    
    init(withPresenter presenter: PokemonPresenter) {
        super.init(style: .plain)
        initStack()
        self.presenter = presenter
        downloadPokemon()
        fetchPokemonCache()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initStack() {
        stack = DataStack(
            CoreStoreSchema(
                modelVersion: "1",
                entities: [Entity<Pokemon>("Pokemon")],
                versionLock: [
                    "Pokemon": [0x66847b324e4dfba6, 0x9697d801baf94f4e, 0xdcb90630e0504805, 0xbace52c12f3cb343]])
        )
        
        try! stack.addStorageAndWait(
            SQLiteStore(
                fileName: "PokemonData.sqlite",
                localStorageOptions: .none))
        
        items = stack.monitorList(From<Pokemon>().orderBy(.ascending(\.number)))
        
        deleteAll()
        
        items.addObserver(self)
    }
    
    private func downloadPokemon() {
        presenter.getPokemon { result in
            switch result {
                
            case .success(let pokemon):
                self.saveContext(pokemonArray: pokemon)
                break
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    // MARK: View funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PokemonCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        
        tableView.pin.all(view.pin.safeArea)
    }
    
    // MARK: TableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.numberOfObjects()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PokemonCell
        
        let pokemon = items[indexPath]
        cell.item = pokemon
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            
        case .delete:
            let pokemon = items[indexPath]
            
            stack.perform(
                asynchronous: { (transaction) in
                    
                    transaction.delete(pokemon)
            },
                completion: { _ in }
            )
            
        default:
            break
        }
    }
    
}

// MARK: ListObserver

extension PokemonViewController: ListObserver {
    func listMonitorWillChange(_ monitor: ListMonitor<Pokemon>) {
        self.tableView.beginUpdates()
    }
    
    func listMonitorDidChange(_ monitor: ListMonitor<Pokemon>) {
        self.tableView.endUpdates()
    }
    
    func listMonitorWillRefetch(_ monitor: ListMonitor<Pokemon>) {
        
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Pokemon>) {
        self.tableView.reloadData()
    }

}

// MARK: ListObjectObserver

extension PokemonViewController: ListObjectObserver {
    func listMonitor(_ monitor: ListMonitor<Pokemon>, didInsertObject object: Pokemon, toIndexPath indexPath: IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func listMonitor(_ monitor: ListMonitor<Pokemon>, didDeleteObject object: Pokemon, fromIndexPath indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func listMonitor(_ monitor: ListMonitor<Pokemon>, didUpdateObject object: Pokemon, atIndexPath indexPath: IndexPath) {
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? PokemonCell {
            
            let pokemon = items[indexPath]
            cell.item = pokemon
        }
    }
    
    func listMonitor(_ monitor: ListMonitor<Pokemon>, didMoveObject object: Pokemon, fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        self.tableView.deleteRows(at: [fromIndexPath], with: .automatic)
        self.tableView.insertRows(at: [toIndexPath], with: .automatic)
    }
}
