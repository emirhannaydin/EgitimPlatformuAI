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
        imageView.image = UIImage(named: book.image ?? "")
    }
}
