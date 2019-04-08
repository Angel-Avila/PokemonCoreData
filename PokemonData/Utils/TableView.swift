//
//  TableView.swift
//  PokemonData
//
//  Created by Angel Avila on 4/8/19.
//  Copyright © 2019 Angel Avila. All rights reserved.
//

import Foundation
import UIKit

class TableView: UITableView {
    
    init(rowHeight: CGFloat) {
        super.init(frame: .zero, style: .plain)
        
        clipsToBounds = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        let bottomOffset = rowHeight * 2 + 64
        
        self.rowHeight = rowHeight
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomOffset, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
