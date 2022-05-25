//
//  LazyStack.swift
//  SwiftUITest
//
//  Created by Ngoc Vũ on 25/05/2022.
//

import Foundation
import SwiftUI
import Combine


private final class TestViewModel: ObservableObject {
    @Published var searchChanged: String = ""
    @Published var allNotes: [Int] = [1,2,3,4,5]
    @Published var currentNotes: [Int] = [1,2,3,4,5]
    private var cancelables: [AnyCancellable] = []
    init() {
        self.$searchChanged
            .throttle(for: 2, scheduler: RunLoop.main, latest: true)
            .sink { value in
                let searchResult = self.allNotes.filter { id in
                    guard let searchId = Int(value) else {
                        return false
                    }
                    return searchId == id
                }
                if searchResult.isEmpty {
                    self.currentNotes = self.allNotes
                    return
                }
                self.currentNotes = searchResult
            }.store(in: &cancelables)
    }
}
struct TestLazyStack: View {
    @State private var isSearchSelected: Bool = false
    @State private var searchSize: CGFloat = 24
    
    @ObservedObject private var viewModel = TestViewModel()
    init() {
    }
    
    var body: some View {
        return GeometryReader { geo in
            let paddingLR: CGFloat = 20
            let parentWidth = geo.size.width - paddingLR
            VStack(spacing: 8) {
                HStack(spacing: 24) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                self.onSearchTap()
                                print("Search")
                            }
                        TextField("...",text: $viewModel.searchChanged)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: self.searchSize, height: 24)
                    .animation(Animation.spring(), value: self.searchSize)
                    
                    Image(systemName: "folder")
                        .frame(width: 24, height: 24)
                    Image(systemName: "info.circle")
                        .frame(width: 24, height: 24)
                }
                ScrollView {
                    Spacer()
                    LazyVStack(alignment:.leading) {
                        ForEach(viewModel.currentNotes, id: \.self) { id in
                            SimpleRow(title: "\(id)",
                                      size: CGSize(width: parentWidth, height: 100),
                                      paddingLR: paddingLR) {
                                print("Row tapped at: \(id)")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color.blue)
            }
        }
    }
    
    private func onSearchTap() {
        self.isSearchSelected.toggle()
        if self.isSearchSelected {
            self.searchSize = 200
        } else {
            self.searchSize = 24
        }
    }
}

struct SimpleRow: View {
    private let paddingLR: CGFloat
    private var onRowTap: () -> Void
    private let size: CGSize
    private let title: String
    @State private var width: CGFloat
    @State private var inputWidth: CGFloat = 0
    @State private var backgroundColor: Color = Color.white
    @State private var titleColor: Color = Color.black
    @State private var isSelected: Bool = false
    @State private var noteTitle: String
    @State private var inputText: String = ""
    @State private var shadowColor: Color = Color.black
    
    init(title: String,
         size: CGSize,
         paddingLR: CGFloat,
         onRowTap: @escaping () -> Void ) {
        self.size = size
        self.paddingLR = paddingLR
        self.onRowTap = onRowTap
        
        self.width = size.width
        self.title = title
        self.noteTitle = "Note number \(title)"
    
    }
    var body: some View {
        
        return HStack(spacing: 0) {
            VStack {
                Text("\(self.noteTitle)")
                    .foregroundColor(self.titleColor)
                    .fontWeight(.bold)
            }
            .frame(width: width, height: size.height)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
            .shadow(color: shadowColor, radius: 1, x: 4, y: 4)
            .padding([.leading, .trailing], paddingLR / 2)
            .onTapGesture {
                self.onRowTap()
                self.updateState()
            }
            .animation(Animation.spring(), value: AnimateAttr(self.backgroundColor,
                                                              self.titleColor,
                                                              self.width))
            
            HStack() {
                TextField("Note detail ...", text: $inputText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding([.leading, .trailing, .top, .bottom], 8)
            }
            .frame(width: self.inputWidth, height: size.height)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
            .animation(Animation.spring(), value: self.inputWidth)
        }
    }
    
    private struct AnimateAttr: Equatable {
        private let size: CGFloat
        private let backgroundColor: Color
        private let titleColor: Color
        init(_ a1: Color, _ a2: Color, _ a3: CGFloat) {
            self.backgroundColor = a1
            self.titleColor = a2
            self.size = a3
        }
    }
    private func updateState() {
        self.isSelected.toggle()
        if isSelected {
            self.backgroundColor = .black
            self.titleColor = .white
            self.width = 100
            self.inputWidth = self.size.width - 100 - paddingLR / 2
            self.noteTitle = "Finish"
            self.shadowColor = .clear
        } else {
            print("My note: \(self.inputText)")
            self.backgroundColor = .white
            self.titleColor = .black
            self.width = size.width
            self.inputWidth = 0
            self.noteTitle = "Note number \(title)"
            self.shadowColor = .black
        }
    }
}

struct TestLazy_Previews: PreviewProvider {
    static var previews: some View {
        return TestLazyStack()
    }
}
