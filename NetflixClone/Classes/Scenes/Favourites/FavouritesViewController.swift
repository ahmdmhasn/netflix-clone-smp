//
//  FavouritesViewController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-11.
//

import UIKit

class FavouritesViewController: UIViewController {
    @IBOutlet weak var favouritesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        let nibName = "\(FavouritesTableViewCell.self)"
        favouritesTableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }

}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let favouriteCellView = tableView.dequeueReusableCell(
            withIdentifier: "\(FavouritesTableViewCell.self)",
            for: indexPath) as? FavouritesTableViewCell else { fatalError("Cannot create cell.") }

        return favouriteCellView
    }
}
