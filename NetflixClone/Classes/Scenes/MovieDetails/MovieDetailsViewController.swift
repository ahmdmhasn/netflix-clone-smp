//
//  MovieDetailsViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-27.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    let movie: Movie
    @IBOutlet weak var titleLabel: UILabel!
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie.title
        // Do any additional setup after loading the view.
    }
    @available(*, unavailable)
    func randomMethod() {

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
