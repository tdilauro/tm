//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import ArgumentParser

struct Diff: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: Help.abstract["\(Self.self)", default: ""]
    )
    
    @Option(default: 0, help: "Offset count.")
    var offset: Int
    
    @Option(default: 1, help: "Count.")
    var count: Int

    @OptionGroup()
    var paths: Paths

    func run() throws {
        guard
            offset >= 0,
            offset < Utility.tmlist.count,
            count >= 0,
            (offset + count) < Utility.tmlist.count
            else { throw RuntimeError("Offset or count invalid or too high (max \(Utility.tmlist.count))") }

        for path in paths.paths {
            guard manager.fileExists(atPath: path) else {
                print("Cannot find file: \(path)")
                continue
            }
            
            var found = false
            for offset in offset ..< offset + count {
                if let cmppath = try? Utility.tmPath(for: path, offset: offset) {
                    guard manager.fileExists(atPath: cmppath) else {
                        print("Not found.")
                        continue
                    }
                    found = true
                    let tmPath = try Utility.corePath(offset: offset)
                    print("\(tmPath.lastPathComponent):")
                    let diff = try Utility.execute(commandPath: "/usr/bin/diff", arguments: [path, cmppath])
                    if diff.trimmed().isEmpty { print("No change.") }
                }
            }
            if !found {
                print("No backups matching \(path) in that range of snapshots")
            }
        }
    }

}
