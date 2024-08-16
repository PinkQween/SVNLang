//
//  Command.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

import Foundation

protocol Command: Identifiable {}

extension Command {
    var id: UUID {
        UUID()
    }
}
