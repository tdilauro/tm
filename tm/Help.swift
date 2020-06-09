//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

struct Help {
    private init() {}
    
    static let abstract = [
        "Tm": tmabstract,
        "Info": infoabstract,
        "List": listabstract,
        "Ls": lsabstract,
        "Cp": cpabstract,
        "Diff": diffabstract,
    ]
    
    static let tmabstract = "Time Machine helper"
    static let tmdiscussion = """
    """
    
    static let listabstract = "List backup dates"
    static let listdiscussion = """
    """

    static let lsabstract = "Perform a time machine ls"
    static let lsdiscussion = """
    """
    
    static let infoabstract = "Time machine info"
    static let infodiscussion = """
    """
    
    static let cpabstract = "Perform a time machine cp to working directory"
    static let cpdiscussion = """
    """
    
    static let diffabstract = "Perform a time machine diff"
    static let diffdiscussion = """
    """
}
