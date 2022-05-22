/*
 By defining this contract, the manager developed to store data locally can be easily changed from a UserDefaults to a
 CoreData manager for example without affecting the repositories that use it
 */

protocol LocalStorageManagerContract {
    func storeId(id: UInt, collectionKey: String)
    func removeId(id: UInt, collectionKey: String)
    func idContainedInCollection(id: UInt, collectionKey: String) -> Bool
}
