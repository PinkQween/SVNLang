import Testing
@testable import VisualNovels

@Test func example() async throws {
    func testRemoveComments() {
        let testCases = [
            // Test case with single-line comments
            (input: """
                let x = 5 // This is a single-line comment
                let y = 10 // Another single-line comment
                """, expected: """
                let x = 5
                let y = 10
                """),
            
            // Test case with multi-line comments
            (input: """
                let a = 1 /* This is a multi-line comment
                It spans multiple lines */
                let b = 2
                """, expected: """
                let a = 1
                let b = 2
                """),
            
            // Test case with mixed comments
            (input: """
                let x = 5 // single-line comment
                let y = 10 /* multi-line comment */
                let z = 15 # hash comment
                """, expected: """
                let x = 5
                let y = 10
                let z = 15
                """),
            
            // Test case with comments inside strings
            (input: """
                let str = "This is a string with // comment" // comment
                let anotherStr = "Another string /* with comment */"
                """, expected: """
                let str = "This is a string with // comment"
                let anotherStr = "Another string /* with comment */"
                """),
            
            // Test case with nested comments
            (input: """
                let x = 5 /* Start comment /* nested comment */ End comment */
                """, expected: """
                let x = 5
                """),
            
            // Edge case with no comments
            (input: """
                let x = 5
                let y = 10
                """, expected: """
                let x = 5
                let y = 10
                """),
            
            // Edge case with empty input
            (input: "", expected: "")
        ]
        
        for (index, testCase) in testCases.enumerated() {
            let result = removeComments(testCase.input)
            #expect(result == testCase.expected, "Test case \(index + 1) failed. Input: \(testCase.input)")
        }
    }
}
