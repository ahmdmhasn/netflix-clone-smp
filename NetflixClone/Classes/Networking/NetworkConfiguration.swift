//
//  NetworkConfiguration.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-09-19.
//

import Foundation

class NetworkConfiguration {
    static let baseURL: String = "https://api.themoviedb.org/3/"
    static let apiKey: String = "6e902ca7ab53142340b3b09e3746bfcc"
    enum Paths: String {
        case discover = "discover/"
        case trending = "trending/"
    }
}
