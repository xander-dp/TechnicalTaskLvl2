//
//  Task+store.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import Combine

extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}
