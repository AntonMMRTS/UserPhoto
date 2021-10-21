//
//  PhotosCell.swift
//  Gora
//
//  Created by Антон Усов on 19.10.2021.
//

import UIKit


class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotosCell"
    
    private let networkManager = PhotoManager()
    
    private let cornerRadius: CGFloat = 10
    
    private let containerView = UIView()
    
    private let activityView = UIView()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let photoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setContentHuggingPriority(.defaultLow, for: .vertical)
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        autolayoutSetup()
        setupShadow()
    }
    
    override func prepareForReuse() {
        activityIndicator.startAnimating()
    }
    
    func download(image: Data?, title: String) {
        
        nameLabel.text = title
        
        guard image != nil else { return }
        
        photoImage.image = UIImage(data: image!)
        
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func config() {
      
        addSubview(containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(activityView)
        
        activityView.addSubview(activityIndicator)
        activityView.addSubview(photoImage)
        
        backgroundColor = .white
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.layer.cornerRadius = cornerRadius
        containerView.clipsToBounds = true
        
        activityIndicator.startAnimating()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.7
        
        layer.cornerRadius = cornerRadius
    }

    private func autolayoutSetup() {
        containerView.frame = contentView.bounds
        photoImage.frame = activityView.bounds
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: activityView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityView.centerYAnchor),
            
            activityView.topAnchor.constraint(equalTo: containerView.topAnchor),
            activityView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            activityView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            activityView.heightAnchor.constraint(equalTo: activityView.widthAnchor),
            
            photoImage.topAnchor.constraint(equalTo: activityView.topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: activityView.leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: activityView.trailingAnchor),
            photoImage.bottomAnchor.constraint(equalTo: activityView.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
}
