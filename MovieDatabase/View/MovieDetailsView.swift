//
//  MovieDetailsView.swift
//  MovieDatabase
//
//  Created by Simonas Kytra on 23/11/2023.
//

import UIKit

protocol MovieDetailsViewDelegate: AnyObject {
    func didTapOpenLinkButton()
}

class MovieDetailsView: UIView {
    let scrollView = UIScrollView()
    
    let imageView = UIImageView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let contentStackView = UIStackView()
    let taglineLabel = UILabel()
    let genreLabel = UILabel()
    let runtimeLabel = UILabel()
    let overviewLabel = UILabel()
    let releaseLabel = UILabel()
    
    weak var delegate: MovieDetailsViewDelegate?
    let openLinkButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        runtimeLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        openLinkButton.translatesAutoresizingMaskIntoConstraints = false
        
        taglineLabel.font = UIFont.boldSystemFont(ofSize: 18)
        taglineLabel.textAlignment = .center
        taglineLabel.numberOfLines = 0
        taglineLabel.lineBreakMode = .byWordWrapping
        
        releaseLabel.font = UIFont.boldSystemFont(ofSize: 14)
        releaseLabel.textAlignment = .center
        
        genreLabel.font = UIFont.boldSystemFont(ofSize: 14)
        genreLabel.textAlignment = .center
        
        runtimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        runtimeLabel.textAlignment = .center
        
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        
        // button set up
        openLinkButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 11
        contentStackView.addArrangedSubview(taglineLabel)
        contentStackView.addArrangedSubview(releaseLabel)
        contentStackView.addArrangedSubview(genreLabel)
        contentStackView.addArrangedSubview(runtimeLabel)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        spacer.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .vertical)

        contentStackView.addArrangedSubview(spacer)
        
        contentStackView.addArrangedSubview(overviewLabel)
        contentStackView.addArrangedSubview(openLinkButton)
        scrollView.addSubview(imageView)
        scrollView.addSubview(contentStackView)
        
        addSubview(scrollView)
        
        // scrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // imageView constraints
        let aspectRatioConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 320.0/225.0)
        aspectRatioConstraint.priority = .defaultHigh
        
        let widthConstraint = imageView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor, multiplier: 0.6)
        let heightConstraint = imageView.heightAnchor.constraint(lessThanOrEqualTo: scrollView.heightAnchor, multiplier: 0.6)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            widthConstraint,
            heightConstraint,
            aspectRatioConstraint
        ])
        
        // contentStackView constraints
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            contentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func updateImage(_ image: UIImage?) {
        activityIndicator.stopAnimating()
        imageView.image = image
    }
    
    func updateUI(withDataFrom: MovieDetails) {
        taglineLabel.text = withDataFrom.tagline != nil && !withDataFrom.tagline!.isEmpty ? "\"\(withDataFrom.tagline!)\"" : ""
        
        if let genres = withDataFrom.genres {
            let genreNames = genres.compactMap { $0.name }
            let genreText = genreNames.joined(separator: ", ")
            genreLabel.text = genreText
        } else {
            genreLabel.text = "No genres available"
        }
        
        releaseLabel.text = withDataFrom.releaseDate
        
        if let runtime = withDataFrom.runtime {
            let hours = runtime / 60
            let minutes = runtime % 60

            if hours > 0 {
                runtimeLabel.text = "\(hours)h \(minutes)m"
            } else {
                runtimeLabel.text = "\(minutes)m"
            }
        } else {
            runtimeLabel.text = "Unknown runtime"
        }
        
        overviewLabel.text = withDataFrom.overview
        
        openLinkButton.setTitle("Open the movie's webpage...", for: .normal)
    }
    
    @objc func openLink() {
        delegate?.didTapOpenLinkButton()
    }
}
