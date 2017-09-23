//
//  JsonFileRevisionServer.swift
//  JsonFileRevisionServer
//
//  Created by Bernardo Breder on 10/01/17.
//
//

import Foundation
#if SWIFT_PACKAGE
import FileSystem
import Literal
import Json
import DataStore
import JsonFileChange
import JsonFileRevisionBase
#endif

public class JsonFileRevisionServer: JsonFileRevisionBase {
    
    var revisionId: Int
    
    public init(reader: DataStoreReader) throws {
        self.revisionId = try reader.sequence(name: JsonFileRevisionTable)
    }
        
    class func page(_ id: Int) -> Int {
        return id / 32
    }
    
}

public enum JsonFileRevisionServerError: Error {
    case readRevisionType
    case branchAlreadyExist(String)
    case branchNotExist(String)
    case revisionNeedToBeUpdated(Int, Int)
}
