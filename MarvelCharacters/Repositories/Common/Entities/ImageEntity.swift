struct ImageEntity: Codable {
    enum CodingKeys: String, CodingKey {
        case path
        case extensionFile = "extension"
    }
    
    let path: String?
    let extensionFile: String?
}
