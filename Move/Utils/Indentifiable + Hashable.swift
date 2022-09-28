//
//  Indentifiable + Hashable.swift
//  Move
//
//  Created by Daria Andrioaie on 28.09.2022.
//

import Foundation

protocol IdentifiableHashable: Identifiable, Hashable {
    
}

extension IdentifiableHashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
