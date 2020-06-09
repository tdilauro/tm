//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import ArgumentParser

struct Info: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: Help.abstract["\(Self.self)", default: ""]
    )
    
    func run() throws {
        print("\(Utility.tmlist.count) snapshots taken.")
        try print("Latest backup: \(Utility.corePath())")
    }
}
