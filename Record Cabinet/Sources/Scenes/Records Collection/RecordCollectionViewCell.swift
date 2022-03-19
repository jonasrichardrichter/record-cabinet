//
//  RecordCollectionViewCell.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 19.03.22.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let recordImage = UIImageView()
    let recordLabel = UILabel()
    let artistLabel = UILabel()
    
    static let reuseIdentifier = "record-cell-reuse-identifier"
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
}

extension RecordCollectionViewCell {
    func configure() {
        
        // recordImage
        self.recordImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.recordImage)
        
        let imageConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "music.note.list")?.withConfiguration(imageConfig)
        self.recordImage.image = image
        self.recordImage.backgroundColor = .secondarySystemBackground
        self.recordImage.layer.cornerRadius = 10
        self.recordImage.contentMode = .scaleAspectFit
        self.recordImage.layer.borderWidth = 0.25
        self.recordImage.layer.borderColor = UIColor.gray.cgColor
        
        
        // recordLabel
        self.recordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.recordLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.recordLabel)
        
        self.recordLabel.font = .preferredFont(forTextStyle: .headline)
        self.recordLabel.textColor = .label
        
        // artistLabel
        self.artistLabel.translatesAutoresizingMaskIntoConstraints = false
        self.artistLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.artistLabel)
        
        self.artistLabel.font = .preferredFont(forTextStyle: .subheadline)
        self.artistLabel.textColor = .secondaryLabel
        
        // Constraints
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            self.recordImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: inset),
            self.recordImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: inset),
            self.recordImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: inset),
            
            self.recordLabel.topAnchor.constraint(equalTo: self.recordImage.bottomAnchor, constant: inset),
            self.recordLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: inset),
            self.recordLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -inset),
            
            self.artistLabel.topAnchor.constraint(equalTo: self.recordLabel.bottomAnchor, constant: inset/2),
            self.artistLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: inset),
            self.artistLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -inset),
            self.artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -inset)
        ])
        
    }
}
