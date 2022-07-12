//
//  Extensions.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 11/07/2022.
//

import Foundation
import UIKit

enum Sections: Int {
    case Popular = 0
    case TrendingMovies = 1
    case TrendingTVShows = 2
    case Upcoming = 3
    case TopRated = 4
}

extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        }
        
        return image.withRenderingMode(self.renderingMode)
    }
}
