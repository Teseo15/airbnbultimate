//
//  VenueViewModel.swift
//  semana7-b
//
//  Created by Linder Hassinger on 6/10/21.
//

import Foundation

class VenueViewModel {
    
    let urlAPI = "https://615ccfdcc29813001773631d.mockapi.io/api/v1/places"
    
    var refreshData = {
        () -> () in
    }
    
    var arrayVenues: [Place] = [] {
        didSet {
            refreshData()
        }
    }
    
    func getVenues() {
        guard let url = URL(string: urlAPI) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard let dataJSON = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                self.arrayVenues = try decoder.decode([Place].self, from: dataJSON)
                print("array")
                print(self.arrayVenues)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
}
