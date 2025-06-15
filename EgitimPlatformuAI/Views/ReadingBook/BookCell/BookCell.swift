//
//  BookCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit

final class BookCell: UICollectionViewCell {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    static let identifier = "BookCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "BookCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with book: Books) {
        titleLabel.text = book.title
        
        let baseUrl = "http://localhost:5001/media/"
        if let url = URL(string: baseUrl + book.coverName) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(systemName: "book")
                    }
                }
            }
        } else {
            imageView.image = UIImage(systemName: "book")
        }
    }

}
