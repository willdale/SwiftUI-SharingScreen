//
//  ContentView.swift
//  SwiftUI-SharingScreen
//
//  Created by Will Dale on 19/11/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State var isSharePresented : Bool = false
    
    var body: some View {
        Button(action: {
            isSharePresented.toggle()
        }, label: {
            Text("Test Sharing")
        })
            .padding()
        .sheet(isPresented: $isSharePresented, onDismiss: {
            isSharePresented = false
        }, content: {
                ActivityViewController(itemsToShare: [createTestFile()!])
                    .edgesIgnoringSafeArea(.bottom)
            })
    }
    
    func createTestFile() -> NSURL? {
        let fileName = "Test Export"
        let ext = ".txt"
        let saveName = "\(fileName)\(ext)"
        guard let path = try? FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: false).appendingPathComponent(saveName) as NSURL else { return nil }
        
        let textFile = "Hello World"
        
        do {
            try textFile.write(to: path as URL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var itemsToShare            : [Any]
    var applicationActivities   : [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
    typealias UIViewControllerType = UIActivityViewController
}
