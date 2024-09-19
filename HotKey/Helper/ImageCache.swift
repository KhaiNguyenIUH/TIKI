import Foundation
import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
