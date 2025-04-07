//
//  File.swift
//  Combine_Study
//
//  Created by Jessica Rodrigues on 19/09/24.
//

import Foundation



class File {
    
    let items = ["apple", "banana", "apricot", "blueberry", "grape"]
    let unfinishedInput = "ap" // The prefix we want to filter by

    init(){
        let filteredItems = items.filter { $0.hasPrefix(unfinishedInput) }

        for i in filteredItems {
            print(i)
        }
    }
    
}
