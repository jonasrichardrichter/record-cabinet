//
//  RecordCollectionViewCell.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 19.03.22.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let recordLabel = UILabel()
    
    static let reuseIdentifier = "record-cell-reuse-identifier"
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

extension RecordCollectionViewCell {
    func configure() {
        
        // recordLabel
        self.recordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.recordLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.recordLabel)
        
        self.recordLabel.font = .preferredFont(forTextStyle: .headline)
        
        
        // Constraints
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            self.recordLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: inset),
            self.recordLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -inset),
            self.recordLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: inset),
            self.recordLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -inset)
        ])
        
    }
}
