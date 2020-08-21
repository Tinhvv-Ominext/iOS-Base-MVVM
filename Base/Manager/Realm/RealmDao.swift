//
//  RealmDao.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/11/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmVersion: UInt64 {
    case origin = 1
}

class RealmDao<T: Object> {

    class func realmInit() {

        let config = Realm.Configuration(schemaVersion: RealmVersion.origin.rawValue, migrationBlock: { migration, oldSchemaVersion in
        })
        Realm.Configuration.defaultConfiguration = config
        print("Realm File: \(config.fileURL?.absoluteString ?? "")")
    }

    func findAll(_ type: T.Type) throws -> Results<T>? {
        let realm = try Realm()
        return realm.objects(type)
    }

    func findById(_ type: T.Type, id: Any) throws -> T? {
        let realm = try Realm()
        return realm.object(ofType: type, forPrimaryKey: id)
    }

    func find(_ type: T.Type) throws -> T? {
        let realm = try Realm()
        return realm.objects(type).first
    }

    func create(_ val: T) throws {
        let realm = try Realm()
        try realm.safeWrite {
            realm.add(val)
        }
    }

    func createOrUpdate(_ val: T) throws {
        let realm = try Realm()
        try realm.safeWrite {
            realm.add(val, update: .all)
        }
    }

    func createObjects(_ val: [T]) throws {
        let realm = try Realm()
        try realm.safeWrite {
            realm.add(val, update: .all)
        }
    }

    func delete() throws {
        let realm = try Realm()
        let realmObj = realm.objects(T.self)
        try realm.safeWrite {
            realm.delete(realmObj)
        }
    }

    /**
     * @note: Delete all object, Only calling when logout
     */
    func deleteAll() throws {
        let realm = try Realm()
        try realm.safeWrite {
            realm.deleteAll()
        }
    }

    func delete(_ type: T.Type, id: Any) throws {
        let realm = try Realm()
        if let realmObj = try self.findById(type, id: id) {
            try realm.safeWrite {
                realm.delete(realmObj)
            }
        }
    }

    func deleteObjects(_ type: T.Type, _ predicateFormat: String, _ args: Any...)throws {
        let realm = try Realm()
        let predicate = NSPredicate(format: predicateFormat, argumentArray: args)
        if let objects = try self.filter(type, predicate: predicate) {
            try realm.safeWrite {
                realm.delete(objects)
            }
        }
    }

    func deleteObjects(_ type: T.Type, _ predicate: NSPredicate) throws {
        let realm = try Realm()
        let objects = realm.objects(type).filter(predicate)
        try realm.write {
            realm.delete(objects)
        }
    }

    func filter(_ type: T.Type, predicate: NSPredicate)throws -> Results<T>? {
        let realm = try Realm()
        return realm.objects(type).filter(predicate)
    }

    func filter(_ type: T.Type, _ predicateFormat: String, _ args: Any...)throws -> Results<T>? {
        let realm = try Realm()
        return realm.objects(type).filter(NSPredicate(format: predicateFormat, argumentArray: args))
    }

    func filter(_ type: T.Type, _ predicateFormat: String, _ args: Any..., orderBy: String, ascending: Bool)throws -> Results<T>? {
        let realm = try Realm()
        return realm.objects(type).filter(NSPredicate(format: predicateFormat, argumentArray: args)).sorted(byKeyPath: orderBy, ascending: ascending)
    }

    func sorted(_ type: T.Type, byKeyPath keyPath: String, ascending: Bool) throws -> Results<T>? {
        let realm = try Realm()
        return realm.objects(type).sorted(byKeyPath: keyPath, ascending: ascending)
    }

}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
            do {
                try self.commitWrite()
            } catch {
                print("Realm error: - isInWriteTransaction")
            }
        } else {
            do {
                try self.write(block)
            } catch {
                print("Realm error: - Begin write transaction")
            }
        }
    }
}

extension Results {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    public func safeObserve(_ block: @escaping (RealmCollectionChange<Results>) -> Void, completion: @escaping (NotificationToken) -> Void) {

        let realm = try! Realm()
        if (!realm.isInWriteTransaction) {
            let token = self.observe(block)
            completion(token)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.safeObserve(block, completion: completion)
            }
        }
    }
}
