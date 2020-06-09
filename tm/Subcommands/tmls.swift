//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import ArgumentParser

struct Ls: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: Help.abstract["\(Self.self)", default: ""]
    )
        
    @Option(default: 0, help: "Offset count.")
    var offset: Int
    
    @Option(default: 1, help: "Count.")
    var count: Int
    
    @Option(name: .shortAndLong, default: "", help: "Specify ls options. You may also use any of a1lrRt directly without using `--option`, e.g. tm ls -al.")
    var options: String
    
    @Flag(name: [.customShort("a")], help: .hidden)
    var showAll: Bool
    
    @Flag(name: [.customShort("1")], help: .hidden)
    var showOneLine: Bool

    @Flag(name: [.customShort("l")], help: .hidden)
    var showLong: Bool
    
    @Flag(name: [.customShort("r")], help: .hidden)
    var showReversed: Bool
    
    @Flag(name: [.customShort("R")], help: .hidden)
    var showRecursive: Bool

    @Flag(name: [.customShort("t")], help: .hidden)
    var showTimeSorted: Bool

    @OptionGroup()
    var paths: Paths
    
    func run() throws {
        guard
            offset >= 0,
            offset < Utility.tmlist.count,
            count >= 0,
            (offset + count) < Utility.tmlist.count
            else { throw RuntimeError("Offset or count invalid or too high (max \(Utility.tmlist.count))") }

        let oneline = showOneLine || options.contains("1")
        var optionString = options + (oneline ? "F" : "FC")
        if showAll { optionString += "a" }
        if showLong { optionString += "l" }
        if showReversed { optionString += "r" }
        if showRecursive { optionString += "R" }
        if showTimeSorted { optionString += "t" }
        let optionArray = ["-\(optionString)"]
        
        for offset in offset ..< offset + count {
            print("\(Utility.tmlist[offset]):")
            let cwd = manager.currentDirectoryPath
            let tmpath = try Utility.corePath(offset: offset)
            manager.changeCurrentDirectoryPath(tmpath)
            try print(Utility.execute(commandPath: "/bin/ls", arguments: optionArray + paths.paths))
            manager.changeCurrentDirectoryPath(cwd)
        }
    }
}
