//
//  Pokemon.swift
//  PokemonData
//
//  Created by Angel Avila on 4/10/19.
//  Copyright © 2019 Angel Avila. All rights reserved.
//

import Foundation
import CoreStore

final class Pokemon: CoreStoreObject {
    let name = Value.Required<String>("name", initial: "")
    let number = Value.Required<Int>("number", initial: 0)
    let type = Value.Required<String>("type", initial: "")
}
