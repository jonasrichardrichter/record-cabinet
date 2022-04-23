//
//  CategoryCollectionViewCell.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 23.04.22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var categoryLabel: UILabel!
    var categoryImageView: UIImageView!
    
    static let reuseIdentifier = "category-cell-reuse-identifier"
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    // MARK: - View Setup
    
    func setupView() {
        
        // categoryImage
        
        self.categoryImageView = UIImageView()
        self.categoryImageView.image = UIImage(systemName: "questionmark.square")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withConfiguration(UIImage.SymbolConfiguration(hierarchicalColor: .systemRed))
        self.categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        self.categoryImageView.backgroundColor = .secondarySystemFill
        self.categoryImageView.layer.cornerRadius = 10
        self.categoryImageView.contentMode = .center
        self.categoryImageView.layer.borderWidth = 0.25
        self.categoryImageView.layer.borderColor = UIColor.gray.cgColor
        
        // categoryLabel
        
        self.categoryLabel = UILabel()
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.categoryLabel.adjustsFontForContentSizeCategory = true
        self.categoryLabel.text = "Category"
        self.categoryLabel.font = .preferredFont(forTextStyle: .headline)
        self.categoryLabel.numberOfLines = 1
        self.categoryLabel.lineBreakMode = .byTruncatingTail
        
        
        self.contentView.addSubview(self.categoryImageView)
        self.contentView.addSubview(self.categoryLabel)
        
        NSLayoutConstraint.activate([
            self.categoryImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.categoryImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.categoryImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.categoryImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.categoryLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.contentView.trailingAnchor.constraint(greaterThanOrEqualTo: self.categoryLabel.trailingAnchor, constant: 10),
            self.contentView.bottomAnchor.constraint(equalTo: self.categoryLabel.bottomAnchor, constant: 10)
        ])
        
    }
    
}
