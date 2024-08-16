//
//  CommandCreationFunctions.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

import Foundation

func createCommand(from line: String) -> (any Command)? {
    let parts = line.split(separator: " ")
    guard let commandName = parts.first else {
        return nil
    }

    switch commandName {
    case "remove":
        return createRemoveCommand(from: line)
    case "mut":
        return createMutableDeclaration(from: line)
    case "imm":
        return createImmutableDeclaration(from: line)
    case "update":
        return UpdateCommand()
    case "character":
        return CharacterCommand()
    case "setMusic":
        return createSetMusicCommand(from: line)
    default:
        return nil
    }
}

private func createRemoveCommand(from line: String) -> RemoveCommand? {
    let parts = line.split(separator: " ")
    guard parts.count >= 2 else { return nil }
    
    let itemToRemove = LangDetails.Commands(rawValue: String(parts[1]))!
    return RemoveCommand(itemToRemove: itemToRemove)
}

private func createMutableDeclaration(from line: String) -> MutableDeclaration? {
    let parts = line.split(separator: " ")
    guard parts.count >= 3 else { return nil }
    
    let name = String(parts[1])
    let value = SVNString(value: String(parts[2])) // Assume value is a string for simplicity
    return MutableDeclaration(name: name, value: value)
}

private func createImmutableDeclaration(from line: String) -> ImmutableDeclaration? {
    let parts = line.split(separator: " ")
    guard parts.count >= 3 else { return nil }
    
    let name = String(parts[1])
    let value = SVNString(value: String(parts[2])) // Assume value is a string for simplicity
    return ImmutableDeclaration(name: name, value: value)
}

private func createSetMusicCommand(from line: String) -> SetMusicCommand? {
    let parts = line.split(separator: " ")
    guard parts.count >= 2 else { return nil }
    
    let song = String(parts[1])
    return SetMusicCommand(song: song)
}
