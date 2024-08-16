//
//  LangDetails.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

public enum LangDetails {
    enum Commands: String, CaseIterable {
        case remove
        case mutable
        case immutable
        case update
        case character
        case setMusic
    }

    public static var validCommandNames: [String] {
        Commands.allCases.map { $0.rawValue }
    }
}
