//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

public let manager = FileManager.default
public let cwd = FileManager.default.currentDirectoryPath

extension Utility {
    public static let tmlist = try! _tmlist()
    
    /// The list of time machine snapshots
    private static func _tmlist() throws -> [String] {
        return try execute("/usr/bin/tmutil listbackups")
            .components(separatedBy: "\n")
            .reversed()
            .filter({ !$0.isEmpty })
            .map({ path in
                return path.pathComponents.suffix(2).joined(separator: "/")
            })
            .map({ $0.trimmed() })
    }
    
    /// The directory for the current machine
    static var machineDirectory = {
        try Utility.execute("/usr/bin/tmutil machineDirectory")
    }
    
    /// The time machine backup path offset by n snapshots
    public static func corePath(offset count: Int = 0) throws -> String {
        guard count >= 0, count < tmlist.count else {
            throw RuntimeError("Illegal backup offset")
        }
        
        let tmDirectory = try machineDirectory()
        let datedDirectory = count > 0
            ? tmDirectory.appendingComponent(tmlist[count].lastPathComponent)
            : tmDirectory.appendingComponent("Latest")
        return datedDirectory
    }
    
    /// The time machine path for a source offset by n snapshots
    public static func tmPath(for sourcePath: String, offset count: Int = 0, checked: Bool = false) throws -> String {
        let tmCorePath = try corePath(offset: count)
        guard let components = manager.componentsToDisplay(forPath: sourcePath)
            else { throw RuntimeError("Unable to resolve current path components") }
        guard !components.joined(separator: "/").contains("Library/Mobile Documents")
            else { throw RuntimeError("iCloud file system not supported or backed up by Time Machine") }
        let preCatalina = tmCorePath.appendingComponent(components.joined(separator: "/"))
        if manager.fileExists(atPath: preCatalina) { return preCatalina }
        var catalinaComponents = components
        catalinaComponents[0] = catalinaComponents[0] + " - Data"
        let catalina = tmCorePath.appendingComponent(catalinaComponents.joined(separator: "/"))
        if manager.fileExists(atPath: catalina) { return catalina }
        throw RuntimeError("Paths cannot be found on Time Machine:\n\t* \(preCatalina)\n\t* \(catalina)")
    }
    
    /// The time machine path for a source offset by n snapshots
    public static func tmRecoveryPath(for proposedPath: String, offset count: Int = 0, checked: Bool = false) throws -> String {
        guard !proposedPath.isEmpty
            else { throw RuntimeError("Cannot resolve empty path") }
        let tmCorePath = try corePath(offset: count)
        guard let components = manager.componentsToDisplay(forPath: cwd)
            else { throw RuntimeError("Unable to resolve working directory components") }
        var corePath = ""
        let preCatalina = tmCorePath.appendingComponent(components[0])
        if manager.fileExists(atPath: preCatalina) { corePath = preCatalina }
        let catalina = tmCorePath.appendingComponent(components[0] + " - Data")
        if manager.fileExists(atPath: catalina) { corePath = catalina }
        
        if corePath.isEmpty {
            throw RuntimeError("Core directory path cannot be found on Time Machine:\n\t* \(preCatalina)\n\t* \(catalina)")
        }
        
        // Path is either absolute or relative
        if proposedPath.hasPrefix("/") {
            let recoveryPath = corePath.appendingComponent(String(proposedPath.dropFirst()))
            guard manager.fileExists(atPath: recoveryPath)
                else { throw RuntimeError("Recovery path \(recoveryPath) does not exist.")}
            return recoveryPath
        }
        
        // Allow home dir relative
        if proposedPath.hasPrefix("~") {
            guard let components = manager.componentsToDisplay(forPath: proposedPath)
                else { throw RuntimeError("Unable to resolve requested path") }
            let recoveryPath = corePath.appendingComponent(components.joined(separator: "/"))
            guard manager.fileExists(atPath: recoveryPath)
                else { throw RuntimeError("Recovery path \(recoveryPath) does not exist.")}
            return recoveryPath
        }
        
        let recoveryPath = corePath
            .appendingComponent(String(cwd.dropFirst()))
            .appendingComponent(proposedPath)
        guard !recoveryPath.contains("Library/Mobile Documents")
            else { throw RuntimeError("You are trying to recover an iCloud file, which is not supported or backed up by Time Machine.") }
        guard manager.fileExists(atPath: recoveryPath)
            else { throw RuntimeError("Recovery path \(recoveryPath) does not exist.")}
        return recoveryPath
    }

}
