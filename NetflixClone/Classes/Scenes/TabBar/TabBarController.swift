//
//  TabBarController.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-08.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = makeViewController(controller: HomeViewController(), title: "Home", systemName: "house", tag: 0)
        let searchViewController = makeViewController(controller: SearchViewController(), title: "Search", systemName: "magnifyingglass", tag: 1)
        let favouritesVieController = makeViewController(controller: FavouritesViewController(), title: "Favourites", systemName: "star", tag: 2)
        let options = makeViewController(controller: MoreViewController(), title: "More", systemName: "square.and.arrow.up", tag: 3)
        viewControllers = [homeViewController, searchViewController, favouritesVieController, options]
        viewControllers = [homeViewController, favouritesVieController, options]

    }
    func makeViewController(
        controller: UIViewController,
        title: String,
        systemName: String,
        tag: Int
    ) -> UINavigationController {
        controller.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: systemName),
            tag: tag
        )
        return UINavigationController(rootViewController: controller)
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
