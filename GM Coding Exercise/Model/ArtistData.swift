//
//  ArtistData.swift
//  GM Coding Exercise
//
//  Created by Derek on 2/19/21.
//

import Foundation

struct MediaResponse:Codable,Hashable {
    var results:[MusicItem]
}
struct MusicItem:Codable,Hashable {
    var artistName:String
    var trackName:String
    var releaseDate:String
    var primaryGenreName:String
    var trackPrice:Double?
    
    init(artistName:String,
         trackName:String,
         releaseDate:String,
         primaryGenreName:String,
         trackPrice:Double?) {
        self.artistName = artistName
        self.trackName = trackName
        self.releaseDate = releaseDate
        self.primaryGenreName = primaryGenreName
        self.trackPrice = trackPrice
    }
}
