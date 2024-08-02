//
//  Launch.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 30/07/2024.
//

import Foundation
import SwiftData

@Model
final class Launch: Codable {
    @Attribute(.unique) let id: String
    let name: String
    let date: Date
    let success: Bool?
    let upcoming: Bool
    let details: String?
    let article: String?
    let wikipedia: String?
    let presskit: String?
    var patchImageSmall: String?
    var patchImageLarge: String?
    var flickrImages: [String]
    
    init(
        id: String,
        name: String,
        date: Date,
        success: Bool?,
        upcoming: Bool,
        details: String?,
        article: String?,
        wikipedia: String?,
        presskit: String?,
        patchImageSmall: String?,
        patchImageLarge: String?,
        flickrImages: [String]
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.success = success
        self.upcoming = upcoming
        self.details = details
        self.article = article
        self.wikipedia = wikipedia
        self.presskit = presskit
        self.patchImageSmall = patchImageSmall
        self.patchImageLarge = patchImageLarge
        self.flickrImages = flickrImages
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        let dateUnix = try values.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: dateUnix)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        upcoming = try values.decode(Bool.self, forKey: .upcoming)
        details = try values.decodeIfPresent(String.self, forKey: .details)
        
        let links = try values.nestedContainer(keyedBy: LinkKeys.self, forKey: .links)
        article = try links.decodeIfPresent(String.self, forKey: .article)
        wikipedia = try links.decodeIfPresent(String.self, forKey: .wikipedia)
        presskit = try links.decodeIfPresent(String.self, forKey: .presskit)
        
        let patch = try links.nestedContainer(keyedBy: PatchKeys.self, forKey: .patch)
        patchImageSmall = try patch.decodeIfPresent(String.self, forKey: .small)
        patchImageLarge = try patch.decodeIfPresent(String.self, forKey: .large)
        
        let flickr = try links.nestedContainer(keyedBy: FlickrKeys.self, forKey: .flickr)
        flickrImages = try flickr.decode([String].self, forKey: .original)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(date.timeIntervalSince1970, forKey: .date)
        try container.encode(success, forKey: .success)
        try container.encode(upcoming, forKey: .upcoming)
        try container.encode(details, forKey: .details)
        
        var links = container.nestedContainer(keyedBy: LinkKeys.self, forKey: .links)
        try links.encode(article, forKey: .article)
        try links.encode(wikipedia, forKey: .wikipedia)
        try links.encode(presskit, forKey: .presskit)
        
        var patch = links.nestedContainer(keyedBy: PatchKeys.self, forKey: .patch)
        try patch.encode(patchImageSmall, forKey: .small)
        try patch.encode(patchImageLarge, forKey: .large)
        
        var flickr = links.nestedContainer(keyedBy: FlickrKeys.self, forKey: .flickr)
        try flickr.encode(flickrImages, forKey: .original)
    }
}

extension Launch {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date = "date_unix"
        case links
        case success
        case upcoming
        case details
    }
    
    enum LinkKeys: String, CodingKey {
        case patch
        case flickr
        case article
        case wikipedia
        case presskit
    }
    
    enum PatchKeys: String, CodingKey {
        case small
        case large
    }
    
    enum FlickrKeys: String, CodingKey {
        case original
    }
}

extension Launch {
    func hasLinks() -> Bool {
        ![article, wikipedia, presskit].contains(nil)
    }
}

extension Launch: Equatable {
    static func ==(lhs: Launch, rhs: Launch) -> Bool {
        return (
            lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.date == rhs.date
            && lhs.success == rhs.success
            && lhs.upcoming == rhs.upcoming
            && lhs.details == rhs.details
            && lhs.article == rhs.article
            && lhs.wikipedia == rhs.wikipedia
            && lhs.presskit == rhs.presskit
            && lhs.patchImageSmall == rhs.patchImageSmall
            && lhs.patchImageLarge == rhs.patchImageLarge
            && lhs.flickrImages == rhs.flickrImages
        )
    }
}

extension Launch {
    static let sampleLaunches: [Launch] = [
        Launch(
            id: "5eb87d42ffd86e000604b384",
            name: "CRS-20",
            date: Date(timeIntervalSince1970: 1583556631),
            success: true,
            upcoming: false,
            details: "SpaceX's 20th and final Crew Resupply Mission under the original NASA CRS contract, this mission brings essential supplies to the International Space Station using SpaceX's reusable Dragon spacecraft. It is the last scheduled flight of a Dragon 1 capsule. (CRS-21 and up under the new Commercial Resupply Services 2 contract will use Dragon 2.) The external payload for this mission is the Bartolomeo ISS external payload hosting platform. Falcon 9 and Dragon will launch from SLC-40, Cape Canaveral Air Force Station and the booster will land at LZ-1. The mission will be complete with return and recovery of the Dragon capsule and down cargo.",
            article: "https://spaceflightnow.com/2020/03/07/late-night-launch-of-spacex-cargo-ship-marks-end-of-an-era/",
            wikipedia: "https://en.wikipedia.org/wiki/SpaceX_CRS-20",
            presskit: "https://www.spacex.com/sites/spacex/files/crs-20_mission_press_kit.pdf",
            patchImageSmall: "https://images2.imgbox.com/53/22/dh0XSLXO_o.png",
            patchImageLarge: "https://images2.imgbox.com/15/2b/NAcsTEB6_o.png",
            flickrImages: ["https://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg"]
        ),
        Launch(
            id: "5eb87cfbffd86e000604b34b",
            name: "Amos-6",
            date: Date(timeIntervalSince1970: 1472735220),
            success: nil,
            upcoming: true,
            details: nil,
            article: nil,
            wikipedia: nil,
            presskit: nil,
            patchImageSmall: nil,
            patchImageLarge: "https://images2.imgbox.com/15/2b/NAcsTEB6_o.png",
            flickrImages: []
        ),
        Launch(
            id: "5eb87cfdffd86e000604b34c",
            name: "Iridium NEXT Mission 1",
            date: Date(timeIntervalSince1970: 1484416440),
            success: false,
            upcoming: false,
            details: nil,
            article: nil,
            wikipedia: nil,
            presskit: nil,
            patchImageSmall: nil,
            patchImageLarge: nil,
            flickrImages: []
        )
    ]
}

