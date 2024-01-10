import AVKit
import CoreImage
import Foundation

struct SampleBufferTransformer {
    private let filterName = "CIColorInvert"
    
    func transform(videoSampleBuffer: CMSampleBuffer) -> CMSampleBuffer {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) else {
            print("failed to get pixel buffer")
            fatalError()
        }
        
        #warning("Implementation to invert colors in pixel buffer")
        pixelBuffer.applyFilter(with: filterName)
        
        guard let result = try? pixelBuffer.mapToSampleBuffer(timestamp: videoSampleBuffer.presentationTimeStamp) else {
            print("failed to mapToSampleBuffer")
            fatalError()
        }
        
        return result
    }
}

extension CVImageBuffer {
    func applyFilter(with name: String) {
        let image = CIImage(cvImageBuffer: self)
        
        guard let filter = CIFilter(name: name, parameters: [kCIInputImageKey: image]),
              let filteredImage = filter.outputImage else {
                  print("failed to apply filter")
                  fatalError()
              }
        
        CIContext().render(filteredImage, to: self)
    }
}
