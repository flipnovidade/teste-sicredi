
import Foundation

struct Track: Codable {
    let id, name, artist, trackArtWork: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "description"
        case trackArtWork = "image"
        case artist = "title"
    }
}
extension Track {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Track.self, from: data)
            self = me
        }
        catch {
            print(":::transform json error: \(error)")
            return nil
        }
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let name = json["description"] as? String,
            let artist = json["title"] as? String,
            let trackArtWork = json["image"] as? String
        else {
            return nil
        }

         self.id = id
         self.name = name
         self.artist = artist
         self.trackArtWork = trackArtWork
    }
    
}
