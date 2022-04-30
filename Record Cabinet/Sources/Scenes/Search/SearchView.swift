//
//  SearchView.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 23.04.22.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationView {
            SearchContent(queryString: searchTerm)
                .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
                .navigationTitle("SEARCH_TITLE")
        }
    }
}

struct SearchContent: View {
    var queryString: String
    @Environment(\.isSearching) var isSearching // 2
    
    var body: some View {
        
            if isSearching {
                List {
                    ForEach(0..<15) { number in
                        NavigationLink {
                            Text("Ergebnisseite")
                        } label: {
                            RecordListCellView(name: "Ergebnis \(number)", artist: "Künstler:in")
                        }
                    }
                }
            } else {
                List {
                    ForEach(0..<15) { number in
                        NavigationLink {
                            Text("Example")
                        } label: {
                            Label("Category", systemImage: "questionmark.app")
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
