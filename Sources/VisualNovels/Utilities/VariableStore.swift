//
//  VariableStore.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

struct VariableStore {
    private var variables: [String: Any] = [:]
    
    mutating func setVariable(_ name: String, value: Any) {
        variables[name] = value
    }
    
    func getVariable(_ name: String) -> Any? {
        return variables[name]
    }
}
