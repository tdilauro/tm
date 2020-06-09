//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import ArgumentParser

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: Help.abstract["\(Self.self)", default: ""]
    )
    
    @Option(default: 0, help: "Offset count.")
    var offset: Int
    
    @Option(default: 10, help: "Count.")
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

        Utility.tmlist.enumerated()
            .suffix(Utility.tmlist.count - offset)
            .prefix(upTo: count).forEach {
                print("\($0.0): \($0.1.lastPathComponent)")
        }
    }
}
