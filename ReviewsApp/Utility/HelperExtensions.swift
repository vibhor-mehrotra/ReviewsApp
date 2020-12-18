//
//  HelperExtensions.swift
//  ReviewsApp
//
//

import UIKit

//MARK: - UITableView deque
extension UITableView {
    func deque<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
}

//MARK:- Image download and caching
extension UIImageView{
    func fetchImage(_ path: String?, placeHolder: UIImage?){
        guard let _path = path, let url = URL(string: _path) else{
            self.image = placeHolder
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let cache = URLCache.shared
            let request = URLRequest(url: url)
            if let imageData = cache.cachedResponse(for: request)?.data, let image = UIImage(data: imageData){
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let _data = data, let _response = response, let image = UIImage(data: _data){
                        cache.storeCachedResponse(CachedURLResponse(response: _response, data: _data), for: request)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }.resume()
            }
            
        }
    }
}

//MARK: - UIAertController to highlight current selection
extension UIAlertController {
    static func actionSheetWithItems(items : [String], currentSelection : String? = nil, action : @escaping (String) -> Void) -> UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for option in items {
            var title: String!
            if let selection = currentSelection, option == selection {
                title = "✔︎ " + option
            } else {
                title = option
            }
            controller.addAction(
                UIAlertAction(title: title, style: .default) {_ in
                    action(option)
                }
            )
        }
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        return controller
    }
}
