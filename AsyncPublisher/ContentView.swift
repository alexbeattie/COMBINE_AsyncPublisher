//
//  ContentView.swift
//  AsyncPublisher
//
//  Created by Alex Beattie on 5/13/23.
//

import SwiftUI
import Combine

class AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async{
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Grape")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    private func addSubscribers() {
        manager.$myData
            .receive(on: DispatchQueue.main, options: nil)
            .sink { dataArray in
                self.dataArray = dataArray
            }
            .store(in: &cancellables)
    }
    
    
    func start() async {
        await manager.addData()
    }
}
struct AsyncPublisherBootcamp: View {
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0).font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
