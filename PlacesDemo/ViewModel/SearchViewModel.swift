//
//  SearchViewModel.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation

class SearchViewModel: SearchViewModelProtocol {
    
    private let repo : PlacesRepositoryProtocol
     
    required init(repo: PlacesRepositoryProtocol){
        self.repo = repo
    }
    
}
