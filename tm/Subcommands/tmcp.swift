//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import ArgumentParser

struct Cp: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: Help.abstract["\(Self.self)", default: ""]
    )
    
    @Option(default: 0, help: "Offset count.")
    var offset: Int

    @Argument(help: "File path to recover, e.g. foo, subfolder/foo, /Absolute/path/to/foo")
    var path: String

    func run() throws {
        guard offset >= 0, offset < Utility.tmlist.count else {
            throw RuntimeError("Offset invalid or too high (max \(Utility.tmlist.count))")
        }

        let tmPath = try Utility.corePath(offset: offset)
        
        let sourcePath = try Utility.tmRecoveryPath(for: path, offset: offset)
        let destinationPath = cwd
            .appendingComponent(path.lastPathComponent)
            + "+" + tmPath.lastPathComponent
        print("Copying \(path.lastPathComponent) to \(destinationPath)")
        try print(Utility.execute(commandPath: "/bin/cp", arguments: [sourcePath, destinationPath]))
    }
}
