//
//  MovieDetailsViewController.swift
//  MovieDatabase
//
//  Created by Simonas Kytra on 23/11/2023.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController, MovieDetailsViewDelegate {
    var movie: Movie?
    var movieDetails: MovieDetails?
    private let movieDetailsView = MovieDetailsView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        movieDetailsView.delegate = self
        setupView()
        getMovieDetails()
    }
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        
        title = movie?.title
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(movieDetailsView)
        
        movieDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieDetailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func getMovieDetails() {
        guard let movieId = movie?.id else {
            return
        }
        
        NetworkManager.fetchMovieDetails(movieId: String(movieId)) { movieDetails in
            DispatchQueue.main.sync {
                let urlString = Constants.API.posterUrl.appending(movieDetails.posterPath ?? "")
                if let url = URL(string: urlString) {
                    self.loadImage(from: url)
                }
                self.movieDetailsView.updateUI(withDataFrom: movieDetails)
                self.movieDetails = movieDetails
            }
        }
    }
    
    func loadImage(from url: URL) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { [weak self] (image, data, error, cacheType, finished, imageURL) in
            DispatchQueue.main.async {
                if let image = image {
                    self?.movieDetailsView.updateImage(image)
                } else {
                    self?.movieDetailsView.updateImage(UIImage(named: "notfound.jpg"))
                }
            }
        }
    }
    
    func didTapOpenLinkButton() {
        if let urlString = movieDetails?.homepage, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
