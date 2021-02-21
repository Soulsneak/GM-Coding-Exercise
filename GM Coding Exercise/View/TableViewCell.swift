//
//  TableViewCell.swift
//  GM Coding Exercise
//
//  Created by Derek on 2/19/21.
//

import UIKit

class TableViewCell: UITableViewCell {
//MARK: - Properties
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var price: UILabel!
    static let reuseId = String(describing: TableViewCell.self)
    var viewModel:ArtistViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with viewModel:ArtistViewModel){
        self.viewModel = viewModel
        artistName.text = viewModel.artistName
        genre.text = viewModel.primaryGenreName
        trackName.text = viewModel.trackName
        releaseDate.text = viewModel.releaseDate
        price.text = String(viewModel.trackPrice ?? 0)
        
    }
}
