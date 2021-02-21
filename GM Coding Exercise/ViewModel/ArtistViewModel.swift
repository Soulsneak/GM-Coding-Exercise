//
//  ArtistViewModel.swift
//  GM Coding Exercise
//
//  Created by Derek on 2/20/21.
//

import Foundation

struct ArtistViewModel {
    var artistName:String
    var trackName:String
    var releaseDate:String
    var primaryGenreName:String
    var trackPrice:Double?
    let df = DateFormatter()
    
    init(with model:MusicItem) {
        artistName = model.artistName
        trackName = model.trackName
        releaseDate = model.releaseDate
        primaryGenreName = model.primaryGenreName
        trackPrice = model.trackPrice
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = df.date(from: model.releaseDate){
            df.dateFormat = "MMM d, yyyy"
            releaseDate = df.string(from: date)
    }
}
}
