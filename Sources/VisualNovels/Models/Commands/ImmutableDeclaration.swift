//
//  ImmutableDeclaration.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

import Foundation

struct ImmutableDeclaration: Command {
    let id = UUID()
    let name: String
    let value: any SVNValue
}
