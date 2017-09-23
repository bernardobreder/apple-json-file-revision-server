//
//  JsonFileRevisionServerBranch.swift
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
    
    public func updated(revisionId: Int) -> Bool {
        return self.revisionId == revisionId
    }
    
    public func branches(reader: DataStoreReader) throws -> [JsonFileRevisionBranch] {
        return try reader.list(name: JsonFileBranchTable, decode: JsonFileRevisionBranch.init(record:))
    }
    
    public func createBranch(writer: DataStoreWriter, revisionId: Int, name: String) throws {
        guard updated(revisionId: revisionId) else { throw JsonFileRevisionServerError.revisionNeedToBeUpdated(revisionId, self.revisionId) }
        
        guard try branches(reader: writer).filter({ b in b.name == name }).isEmpty else { throw JsonFileRevisionServerError.branchAlreadyExist(name) }
        
        let revisionId = try writer.sequence(name: JsonFileRevisionTable)
        let revision = JsonFileRevisionCreateBranch(id: revisionId, name: name)
        writer.insert(name: JsonFileRevisionTable, page: JsonFileRevisionServer.page(revision.id), id: revision.id, record: try revision.encode())
        
        let branchId = try writer.sequence(name: JsonFileBranchTable)
        let branchData = JsonFileRevisionBranch(id: branchId, name: name, createdId: revisionId, lastReintegratedId: revisionId)
        writer.insert(name: JsonFileBranchTable, page: JsonFileRevisionServer.page(branchData.id), id: branchData.id, record: branchData.encode())
        
        self.revisionId = revisionId
    }
    
    public func removeBranch(writer: DataStoreWriter, revisionId: Int, name: String) throws {
        guard updated(revisionId: revisionId) else { throw JsonFileRevisionServerError.revisionNeedToBeUpdated(revisionId, self.revisionId) }
        
        guard let branchData = try branches(reader: writer).filter({ b in b.name == name }).first else { throw JsonFileRevisionServerError.branchNotExist(name) }
        
        let revisionId = try writer.sequence(name: JsonFileRevisionTable)
        let revision = JsonFileRevisionRemoveBranch(id: revisionId, name: name)
        writer.insert(name: JsonFileRevisionTable, page: JsonFileRevisionServer.page(revision.id), id: revision.id, record: try revision.encode())
        
        writer.delete(name: JsonFileBranchTable, page: JsonFileRevisionServer.page(branchData.id), id: branchData.id)
        
        // Remover todos os commits
        
        self.revisionId = revisionId
    }
    
}
