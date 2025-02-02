//
//  ModelData.swift
//  CircularCarousel Demo
//
//  Created by Piotr Suwara on 4/2/19.
//  Copyright © 2019 Piotr Suwara. All rights reserved.
//

import UIKit

struct DataCrausel {
    static let buttonViewModels: [ButtonCarouselModel] = [
        ButtonCarouselModel(selectedImage: UIImage(named: "emoji_1")!,
                                 unselectedImage: UIImage(named: "emoji_1")!,
                                 text: "Parking"),
        ButtonCarouselModel(selectedImage: UIImage(named: "emoji_2")!,
                                 unselectedImage: UIImage(named: "emoji_2")!,
                                 text: "Clothing"),
        ButtonCarouselModel(selectedImage: UIImage(named: "emoji_3")!,
                                 unselectedImage: UIImage(named: "emoji_3")!,
                                 text: "Food"),
        ButtonCarouselModel(selectedImage: UIImage(named: "emoji_4")!,
                                 unselectedImage: UIImage(named: "emoji_4")!,
                                 text: "Lodging"),
        ButtonCarouselModel(selectedImage: UIImage(named: "emoji_5")!,
                                 unselectedImage: UIImage(named: "emoji_5")!,
                                 text: "Map")
//        ButtonCarouselModel(selectedImage: UIImage(named: "ButtonImageWhite1")!,
//                            unselectedImage: UIImage(named: "ButtonImageGray1")!,
//                            text: "Lodging"),
//        ButtonCarouselModel(selectedImage: UIImage(named: "ButtonImageWhite2")!,
//                            unselectedImage: UIImage(named: "ButtonImageGray2")!,
//                            text: "Map")
    ]
    
    static let imageCellSelection: [ImageCellViewModel] = [
        ImageCellViewModel(imageName: "PageImage1", title: "First", description: "This is a short description"),
        ImageCellViewModel(imageName: "PageImage2", title: "Second", description: "This is a short description"),
        ImageCellViewModel(imageName: "PageImage3", title: "Third", description: "This is a short description"),
        ImageCellViewModel(imageName: "PageImage4", title: "Fourth", description: "This is a short description")
    ]
}
