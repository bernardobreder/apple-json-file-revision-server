//
//  JsonFileRevisionServerCommit.swift
//  JsonFileRevision
//
//  Created by Bernardo Breder on 02/02/17.
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

extension JsonFileRevisionServer {
    
    public func commit(writer: DataStoreWriter, revisionId: Int, branch: String, changes: [JsonFileChangeProtocol]) throws -> Bool {
        guard revisionId == self.revisionId else { return false }
        
        self.revisionId = try writer.sequence(name: JsonFileRevisionTable)
        
        let revision = JsonFileRevisionCommitBranch(id: self.revisionId, branch: branch, changes: changes)
        writer.insert(name: JsonFileRevisionTable, page: JsonFileRevisionServer.page(self.revisionId), id: self.revisionId, record: try revision.encode())
        
        return true
    }
    
    public func update(reader: DataStoreReader, revisionId: Int) throws -> [JsonFileRevision] {
        var array: [JsonFileRevision] = []
        var rev = revisionId + 1; while rev <= self.revisionId {
            array.append(try reader.get(name: JsonFileRevisionTable, page: JsonFileRevisionServer.page(rev), id: rev, decode: JsonFileRevisionDecoder.decode))
            rev += 1
        }
        return array
    }
        
}
