//
//  SVNCanvas.swift
//  
//
//  Created by Hanna Skairipa on 8/16/24.
//

import SwiftUI

public struct VSNCanvas: View {
    @State private var story: Story?
    @StateObject private var sceneInfo = SceneInfo()
    
    let url: String?
    
    init(story: Story?) {
        self.story = story
        self.url = nil
    }
    
    init(url: String) {
        self.url = url
    }
    
    public var body: some View {
        ZStack {
            if let story = story {
                VStack {
                    ForEach(story.commands, id: \.id) { command in
                        castToTypeAndProvideCommand(command) { (command: UpdateCommand) in
                            Text("Test")
                        }
                        
                        castToTypeAndProvideCommand(command) { (command: CharacterCommand) in
                            Text("Test")
                        }
                    }
                }
                .onAppear {
                    print("Printing comands")
                    
                    for command in story.commands {
                        print(command)
                        
                        castToType(command, to: UpdateCommand.self) {
                            redraw()
                        }
                    }
                }
            }
        }
        .taskWrapper {
            if let url = url {
                self.story = await scriptToStory(scriptURL: urlValidator(url))
            }
        }
    }
}

private extension VSNCanvas {
    func redraw() {}
}

private extension VSNCanvas {
    func castToType<CommandType: Command>(_ command: any Command, to commandType: CommandType.Type, execute closure: () -> Void) {
        if command is CommandType {
            closure()
        }
    }
    
        func castToType<CommandType: Command>(_ command: any Command, execute closure: () -> some View) -> some View {
            if command is CommandType {
                return AnyView(closure())
            } else {
                return AnyView(EmptyView()) // Or another default value of `View` if necessary
            }
        }
    
    func castToTypeAndProvideCommand<CommandType: Command>(
        _ command: any Command,
        execute closure: (_ command: CommandType) -> some View
    ) -> some View {
        if let command = command as? CommandType {
            return AnyView(closure(command))
        } else {
            return AnyView(EmptyView())  // Or another default value of `View` if necessary
        }
    }
    
    func castToTypeAndProvideCommand<CommandType: Command>(
        _ command: any Command,
        execute closure: (CommandType) -> Void
    ) {
        if let command = command as? CommandType {
            closure(command)
        }
    }
}

struct TaskWrapper: ViewModifier {
    let taskContent: () async -> Void

    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            return content
                .task {
                    await taskContent()
                }
        } else {
            return content
        }
    }
}

extension View {
    func taskWrapper(_ taskContent: @escaping () async -> Void) -> some View {
        modifier(TaskWrapper(taskContent: taskContent))
    }
}


func urlValidator(_ urlString: String) -> URL? {
    guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
        return nil
    }
    return url
}

func scriptToStory(scriptURL: URL?) async -> Story? {
    guard let url = scriptURL else { return nil }
    if let scriptText = await fetchTextData(from: url) {
        return processScript(scriptText)
    }
    return nil
}

func processScript(_ script: String) -> Story {
    return Story(commands: [])
}

#Preview {
    VSNCanvas(url: "localhost/test.svn")
}
