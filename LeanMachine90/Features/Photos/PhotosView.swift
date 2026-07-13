import SwiftUI

struct PhotosView: View {
    var body: some View {
        FeatureEmptyState(
            icon: "photo.on.rectangle",
            title: "No progress photos",
            message: "Private front, side, and back photos will remain on device unless you explicitly enable photo sync."
        )
        .navigationTitle("Photos")
    }
}
