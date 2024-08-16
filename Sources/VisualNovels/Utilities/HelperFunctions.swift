//
//  HelperFunctions.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

import Foundation

func fetchTextData(from url: URL) async -> String? {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(data: data, encoding: .utf8)
    } catch {
        print("Error fetching data: \(error)")
        return nil
    }
}

func removeComments(_ script: String) -> String {
    var result = ""
    var lastChar: String.Element?
    var isInString = false
    var isInSingleLineComment = false
    var isInMultiLineComment = false
    
    for char in script {
        if char == "\"" && lastChar != "\\" {
            isInString.toggle()
        }

        if !isInString {
            if char == "/" && lastChar == "/" {
                isInSingleLineComment = true
            } else if char == "\n" && isInSingleLineComment {
                isInSingleLineComment = false
            } else if char == "*" && lastChar == "/" {
                isInMultiLineComment = true
            } else if char == "/" && lastChar == "*" && isInMultiLineComment {
                isInMultiLineComment = false
                lastChar = nil
                continue
            }
        }

        if !isInSingleLineComment && !isInMultiLineComment {
            result.append(char)
        }

        lastChar = char
    }
    
    return result
}
