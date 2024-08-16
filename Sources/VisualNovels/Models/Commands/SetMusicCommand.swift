//
//  SetMusicCommand.swift
//
//
//  Created by Hanna Skairipa on 8/16/24.
//

import Foundation

struct SetMusicCommand: Command {
    let id = UUID()
    let song: String
}
