import SwiftUI
import MapKit

extension ContentView {
   @MainActor class ViewModel: ObservableObject {
       @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
       
       @Published var selectedPlace: Location?
       @Published private(set) var locations: [Location]
       
       let savePath = FileManager.documnentsDirectory.appendingPathComponent("SavedPlaces")
       
       init() {
           do {
               let data = try Data(contentsOf: savePath)
               locations = try JSONDecoder().decode([Location].self, from: data)
           } catch {
               locations = []
           }
       }
       
       func save() {
           do {
               let data = try JSONEncoder().encode(locations)
               try data.write(to: savePath, options: [.atomic, .completeFileProtection])
           } catch {
               print("Unable to save data.")
           }
       }
       
       func addLocation() {
           let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
           locations.append(newLocation)
           save()
       }
       
       func update(location: Location) {
           guard let selectedPlace else { return }
           
           if let index = locations.firstIndex(of: selectedPlace) {
               locations[index] = location
               save()
           }
       }
       
    }
}
