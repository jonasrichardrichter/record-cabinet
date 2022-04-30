//
//  RecordListCellView.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 23.04.22.
//

import SwiftUI

struct RecordListCellView: View {
    
    public var name: String
    public var artist: String
    public var image: Image?
    
    var body: some View {
        HStack {
            Image(systemName: "music.note.list")
                .foregroundColor(Color.accentColor)
                .frame(width: 80, height: 80, alignment: .center)
                .background(Color.init(uiColor: UIColor.systemGroupedBackground))
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(artist)
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
            }.padding(.leading)
        }
    }
}

struct RecordListCellView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListCellView(name: "Name des Albums", artist: "Künstler:in des Albums")
            .previewLayout(.sizeThatFits)
    }
}
