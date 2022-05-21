struct CharacterModel {
    let id: UInt
    let name: String
    let description: String?
    let thumbnail: String?
    
    init?(character: CharacterEntity) {
        guard let id  = character.id, let name = character.name else {
            return nil
        }
        
        self.id = id
        self.name = name
        description = character.description
        
        if let path = character.thumbnail?.path,
            let extensionFile = character.thumbnail?.extensionFile {
            thumbnail = "\(path).\(extensionFile)".replacingOccurrences(of: "http", with: "https")
        } else {
            thumbnail = nil
        }
    }
}
