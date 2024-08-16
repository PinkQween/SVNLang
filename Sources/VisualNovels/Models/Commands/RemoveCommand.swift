//
//  RemoveCommand.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

import Foundation

struct RemoveCommand: Command {
    let id = UUID()
    let itemToRemove: LangDetails.Commands
}
