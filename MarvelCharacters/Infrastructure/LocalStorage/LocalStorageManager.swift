import Foundation

protocol LocalStorageManagerContract {
    func storeId(id: UInt, collectionKey: String)
    func removeId(id: UInt, collectionKey: String)
    func idContainedInCollection(id: UInt, collectionKey: String) -> Bool
}

class LocalStorageManager: LocalStorageManagerContract {
    let userDefaults = UserDefaults.standard
    
    func storeId(id: UInt, collectionKey: String) {
        var collection = getCollectionFor(key: collectionKey)
        collection.insert(id)
        store(collection: collection, collectionKey: collectionKey)
    }
    
    func removeId(id: UInt, collectionKey: String) {
        var collection = getCollectionFor(key: collectionKey)
        collection.remove(id)
        store(collection: collection, collectionKey: collectionKey)
    }
    
    func idContainedInCollection(id: UInt, collectionKey: String) -> Bool {
        let collection = getCollectionFor(key: collectionKey)
        return collection.contains(id)
    }
    
    private func getCollectionFor(key: String) -> Set<UInt> {
        guard let array = userDefaults.value(forKey: key) as? Array<UInt> else {
            return Set<UInt>()
        }
        
        return Set(array)
    }
    
    private func store(collection: Set<UInt>, collectionKey: String) {
        let array = Array(collection)
        userDefaults.set(array, forKey: collectionKey)
    }
}
