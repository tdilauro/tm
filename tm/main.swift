//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import ArgumentParser

struct Paths: ParsableArguments {
    @Argument(parsing: .remaining,
              help: "Paths. (Default: cwd).")
    var paths: [String]
}

struct Tm: ParsableCommand {
    static let configuration =  CommandConfiguration(
        abstract: Help.abstract["\(Self.self)", default: ""],
        version: "0.1",
        subcommands: [Info.self, List.self, Ls.self, Diff.self, Cp.self]
    )
        
    func run() throws {
        guard
            CommandLine.argc > 1
            else { throw CleanExit.helpRequest() }
    }
}

Tm.main()

