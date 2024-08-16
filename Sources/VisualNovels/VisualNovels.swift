//import SwiftUI
//
//// MARK: - Protocols
//
//protocol Command: Identifiable {}
//
//protocol SVNValue {
//    associatedtype T
//    var value: T { get }
//}
//
//// MARK: - SVN Value Types
//
//struct SVNString: SVNValue, Hashable {
//    var value: String
//}
//
//struct SVNDouble: SVNValue {
//    var value: Double
//}
//
//struct SVNInteger: SVNValue {
//    var value: Int
//}
//
//struct SVNBoolean: SVNValue {
//    var value: Bool
//}
//
//struct SVNCharacter: SVNValue {
//    var value: StoryCharacter
//}
//
//struct SVNMusic: SVNValue {
//    var value: String
//    
//    init(value: String) {
//        self.value = value
//    }
//}
//
//class SVNSFX: SVNValue {
//    var value: String
//    
//    init(value: String) {
//        self.value = value
//    }
//}
//
//// MARK: - Story Types
//
//struct StoryCharacter: Hashable {
//    let name: SVNString
//    let fullBodyModels: [String]
//    let halfBodyModels: [String]
//}
//
//struct StoryCharacterInfo: Hashable {
//    
//}
//
//// MARK: - Command Types
//
//struct RemoveCommand: Command {
//    let id = UUID()
//    let itemToRemove: LangDetails.Commands
//}
//
//struct MutableDeclaration: Command {
//    let id = UUID()
//    let name: String
//    let value: any SVNValue
//}
//
//struct ImmutableDeclaration: Command {
//    let id = UUID()
//    let name: String
//    let value: any SVNValue
//}
//
//struct UpdateCommand: Command {
//    let id = UUID()
//}
//
//struct CharacterCommand: Command {
//    let id = UUID()
//}
//
//struct SetMusicCommand: Command {
//    let id = UUID()
//    let song: String
//}
//
//// MARK: - Language Details
//
//struct LangDetails {
//    enum Commands: String, CaseIterable {
//        case remove, character, music, background, transition, sfx, button, text, speaker, route, update, `var`, `let`, `const`
//    }
//    
//    enum NewCommandOptions: String, CaseIterable {
//        case character, music, sfx
//    }
//}
//
//// MARK: - Variable Store
//
//struct VariableStore {
//    private var variables: [String: Any] = [:]
//    
//    mutating func setVariable(_ name: String, value: Any) {
//        variables[name] = value
//    }
//    
//    func getVariable(_ name: String) -> Any? {
//        return variables[name]
//    }
//}
//
//// MARK: - Helper Functions
//
//func fetchTextData(from url: URL) async -> String? {
//    do {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return String(data: data, encoding: .utf8)
//    } catch {
//        print("Error fetching data: \(error)")
//        return nil
//    }
//}
//
//func removeComments(_ script: String) -> String {
//    var result = ""
//    var lastChar: String.Element?
//    var isInString = false
//    var isInSingleLineComment = false
//    var isInMultiLineComment = false
//    
//    for char in script {
//        if char == "\"" && lastChar != "\\" {
//            isInString.toggle()
//        }
//        
//        if isInString {
//            result.append(char)
//            continue
//        }
//        
//        if isInMultiLineComment {
//            if lastChar == "*" && char == "/" {
//                isInMultiLineComment = false
//            }
//            lastChar = char
//            continue
//        }
//        
//        if isInSingleLineComment {
//            if char == "\n" {
//                isInSingleLineComment = false
//            }
//            lastChar = char
//            continue
//        }
//        
//        if lastChar == "/" && char == "/" {
//            isInSingleLineComment = true
//            lastChar = nil
//            continue
//        }
//        
//        if lastChar == "/" && char == "*" {
//            isInMultiLineComment = true
//            lastChar = nil
//            continue
//        }
//        
//        result.append(char)
//        lastChar = char
//    }
//    
//    return result
//}
//
//// MARK: - Command Creation Functions
//
//func removeCommand(_ line: String) -> RemoveCommand {
//    for command in LangDetails.Commands.allCases {
//        guard line.hasPrefix(command.rawValue) else { continue }
//        return RemoveCommand(itemToRemove: command)
//    }
//    fatalError("Command not recognized")
//}
//
//func createNewCharacter(_ line: String) -> SVNCharacter {
//    // Remove the "new character" keyword and trim leading/trailing whitespace
//    let lineWithoutKeyword = line.trimmingCharacters(in: .whitespaces)
//    
//    // Split the string into components
//    let components = lineWithoutKeyword.split(separator: "]")
//    
//    guard components.count == 3 else {
//        fatalError("Invalid character creation syntax")
//    }
//    
//    // Extract name, fullBodyModels, and halfBodyModels from components
//    let nameComponent = components[0].trimmingCharacters(in: .whitespaces)
//    let fullBodyModelsComponent = components[1].trimmingCharacters(in: .whitespaces).dropFirst().trimmingCharacters(in: .whitespaces)
//    let halfBodyModelsComponent = components[2].trimmingCharacters(in: .whitespaces).dropFirst().trimmingCharacters(in: .whitespaces)
//    
//    // Extract name
//    let name = nameComponent.replacingOccurrences(of: "\"", with: "")
//    
//    // Extract fullBodyModels
//    let fullBodyModels = fullBodyModelsComponent
//        .replacingOccurrences(of: "[", with: "")
//        .replacingOccurrences(of: "]", with: "")
//        .split(separator: ",")
//        .map { $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "") }
//    
//    // Extract halfBodyModels
//    let halfBodyModels = halfBodyModelsComponent
//        .replacingOccurrences(of: "[", with: "")
//        .replacingOccurrences(of: "]", with: "")
//        .split(separator: ",")
//        .map { $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "") }
//    
//    // Return SVNCharacter
//    return SVNCharacter(value: StoryCharacter(
//        name: SVNString(value: name),
//        fullBodyModels: fullBodyModels,
//        halfBodyModels: halfBodyModels
//    ))
//}
//
//func createNewMusic(_ line: String) -> SVNMusic {
//    // Remove the "new character" keyword and trim leading/trailing whitespace
//    let lineWithoutKeyword = line.trimmingCharacters(in: .whitespaces)
//    
//    // Split the string into components
//    let name = lineWithoutKeyword.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "")
//    
//    // Return SVNCharacter
//    return SVNMusic(value: name)
//}
//
//func createNewSFX(_ line: String) -> SVNSFX {
//    // Remove the "new character" keyword and trim leading/trailing whitespace
//    let lineWithoutKeyword = line.trimmingCharacters(in: .whitespaces)
//    
//    // Split the string into components
//    let name = lineWithoutKeyword.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "")
//    
//    // Return SVNCharacter
//    return SVNSFX(value: name)
//}
//
//func parseValue(_ value: String, variableStore: VariableStore) -> any SVNValue {
//    if let intValue = Int(value) {
//        return SVNInteger(value: intValue)
//    } else if let doubleValue = Double(value) {
//        return SVNDouble(value: doubleValue)
//    } else if value == "true" {
//        return SVNBoolean(value: true)
//    } else if value == "false" {
//        return SVNBoolean(value: false)
//    } else if let storedValue = variableStore.getVariable(value) as? any SVNValue {
//        return storedValue
//    } else {
//        return SVNString(value: value)
//    }
//}
//
//func mutableDeclaration(_ line: String, variableStore: inout VariableStore) -> MutableDeclaration {
//    guard let nameEndIndex = line.firstIndex(of: " "),
//          let valueStartIndex = line.lastIndex(of: "=") else {
//        fatalError("Invalid declaration")
//    }
//    
//    let name: String = line[line.startIndex..<nameEndIndex].trimmingCharacters(in: .whitespaces)
//    let value: String = line[line.index(after: valueStartIndex)...].trimmingCharacters(in: .whitespaces)
//    
//    let parsedValue: any SVNValue
//    if value.hasPrefix("new") {
//        var passThroughLine = value
//        passThroughLine.removeFirst(4)
//        parsedValue = newCommand(passThroughLine)
//    } else {
//        parsedValue = parseValue(value, variableStore: variableStore)
//    }
//    
//    variableStore.setVariable(name, value: parsedValue)
//    return MutableDeclaration(name: name, value: parsedValue)
//}
//
//func immutableDeclaration(_ line: String, variableStore: inout VariableStore) -> ImmutableDeclaration {
//    let components = line.split(separator: " ")
//    guard components.count >= 2 else { fatalError("Invalid immutable declaration") }
//    let name = String(components[0])
//    let value = parseValue(String(components[1]), variableStore: variableStore)
//    return ImmutableDeclaration(name: name, value: value)
//}
//func newCommand(_ line: String) -> any SVNValue {
//    for commandType in LangDetails.NewCommandOptions.allCases {
//        let command = commandType.rawValue
//        guard line.hasPrefix(command) else { continue }
//        
//        var lineWithoutSecondCommand = line
//        lineWithoutSecondCommand.removeFirst(command.count)
//        
//        switch commandType {
//        case .character:
//            return createNewCharacter(lineWithoutSecondCommand)
//        case .music:
//            return createNewMusic(lineWithoutSecondCommand)
//        case .sfx:
//            return createNewSFX(lineWithoutSecondCommand)
//        }
//    }
//    fatalError("Command type not recognized: \(line)")
//}
//
//func updateCommand(_ line: String) -> UpdateCommand {
//    return UpdateCommand()
//}
//
//func characterCommand(_ line: String) -> CharacterCommand {
//    return CharacterCommand()
//}
//
//func setMusic(_ line: String) -> SetMusicCommand {
//    let lineWithoutKeyword = line.trimmingCharacters(in: .whitespaces)
//    
//    // Split the string into components
//    let name = lineWithoutKeyword.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "")
//    
//    return SetMusicCommand(song: name)
//}
//
//func returnCommand(line: String, command: LangDetails.Commands, variableStore: inout VariableStore) -> any Command {
//    switch command {
//    case .update:
//        return updateCommand(line)
//    case .var:
//        return mutableDeclaration(line, variableStore: &variableStore)
//    case .let:
//        return mutableDeclaration(line, variableStore: &variableStore)
//    case .const:
//        return immutableDeclaration(line, variableStore: &variableStore)
//    case .character:
//        return characterCommand(line)
//    case .remove:
//        return removeCommand(line)
//    case .music:
//        return setMusic(line)
//    case .background, .transition, .sfx, .button, .text, .speaker, .route:
//        return removeCommand(line)
//    }
//}
//
//// MARK: - Script Parsing
//
//public struct Story {
//    let commands: [any Command]
//}
//
//public func scriptToStory(scriptURL: URL) async -> Story {
//    var commands: [any Command] = []
//    var variableStore = VariableStore()
//    
//    guard let script = await fetchTextData(from: scriptURL) else {
//        print("No script data")
//        return Story(commands: commands)
//    }
//    
//    let lines = removeComments(script).split(separator: ";")
//        .map { $0.trimmingCharacters(in: .whitespaces) }
//    
//    for line in lines {
//        guard !line.isEmpty else { continue }
//        let lowerLine = line.lowercased()
//        
//        for commandType in LangDetails.Commands.allCases {
//            let command = commandType.rawValue
//            guard lowerLine.hasPrefix(command) else { continue }
//            
//            var lineWithoutKeyword = line
//            lineWithoutKeyword.removeFirst(command.count)
//            
//            let cmd = returnCommand(line: lineWithoutKeyword, command: commandType, variableStore: &variableStore)
//            
//            if let mutableDecl = cmd as? MutableDeclaration {
//                variableStore.setVariable(mutableDecl.name, value: mutableDecl.value)
//            } else if let immutableDecl = cmd as? ImmutableDeclaration {
//                variableStore.setVariable(immutableDecl.name, value: immutableDecl.value)
//            }
//            
//            print("Command processed: \(cmd)") // Debug print
//            
//            commands.append(cmd)
//        }
//    }
//    
//    print("Commands array: \(commands)") // Debug print
//    return Story(commands: commands)
//}
//
//func urlValidator(_ url: String) -> URL {
//    return URL(string: url)!
//}
//
//public class SceneInfo: ObservableObject {
//    let characters = [StoryCharacter : StoryCharacterInfo]()
//    let text = ""
//}
//
//public struct VSNCanvas: View {
//    @State private var story: Story?
//    @StateObject private var sceneInfo = SceneInfo()
//    
//    let url: String?
//    
//    init(story: Story?) {
//        self.story = story
//        self.url = nil
//    }
//    
//    init(url: String) {
//        self.url = url
//    }
//    
//    public var body: some View {
//        ZStack {
//            if let story = story {
//                VStack {
//                    ForEach(story.commands, id: \.id) { command in
//                        castToTypeAndProvideCommand(command) { (command: UpdateCommand) in
//                            Text("Test")
//                        }
//                        
//                        castToTypeAndProvideCommand(command) { (command: CharacterCommand) in
//                            Text("Test")
//                        }
//                    }
//                }
//                .onAppear {
//                    print("Printing comands")
//                    
//                    for command in story.commands {
//                        print(command)
//                        
//                        castToType(command, to: UpdateCommand.self) {
//                            redraw()
//                        }
//                    }
//                }
//            }
//        }
//        .taskWrapper {
//            if let url = url {
//                self.story = await scriptToStory(scriptURL: urlValidator(url))
//            }
//        }
//    }
//}
//
//private extension VSNCanvas {
//    func redraw() {
//        
//    }
//}
//
//private extension VSNCanvas {
//    func castToType<CommandType: Command>(_ command: any Command, to commandType: CommandType.Type, execute closure: () -> Void) {
//        if command is CommandType {
//            closure()
//        }
//    }
//    
//        func castToType<CommandType: Command>(_ command: any Command, execute closure: () -> some View) -> some View {
//            if command is CommandType {
//                return AnyView(closure())
//            } else {
//                return AnyView(EmptyView()) // Or another default value of `View` if necessary
//            }
//        }
//    
//    func castToTypeAndProvideCommand<CommandType: Command>(
//        _ command: any Command,
//        execute closure: (_ command: CommandType) -> some View
//    ) -> some View {
//        if let command = command as? CommandType {
//            return AnyView(closure(command))
//        } else {
//            return AnyView(EmptyView())  // Or another default value of `View` if necessary
//        }
//    }
//    
//    func castToTypeAndProvideCommand<CommandType: Command>(
//        _ command: any Command,
//        execute closure: (CommandType) -> Void
//    ) {
//        if let command = command as? CommandType {
//            closure(command)
//        }
//    }
//}
//
//#Preview {
//    VSNCanvas(url: "http://127.0.0.1/test.svn")
//}
//
//struct TaskWrapper: ViewModifier {
//    let taskContent: () async -> Void
//
//    func body(content: Content) -> some View {
//        if #available(iOS 15, *) {
//            return content
//                .task {
//                    await taskContent()
//                }
//        } else {
//            return content
//        }
//    }
//}
//
//extension View {
//    func taskWrapper(_ taskContent: @escaping () async -> Void) -> some View {
//        modifier(TaskWrapper(taskContent: taskContent))
//    }
//}
//
//extension Command {
//    var id: UUID {
//        UUID()
//    }
//}
