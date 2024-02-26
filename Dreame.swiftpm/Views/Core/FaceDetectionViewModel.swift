import AVFoundation
import UIKit
import Vision
import AVFoundation

class FaceDetectionViewModel: NSObject, ObservableObject {
  @Published var points: [CGPoint] = []
  @Published var isEyeClosed: Bool = false
  @Published var isMainOn: Bool = false
  
  let session = AVCaptureSession()
  let videoDataOutput = AVCaptureVideoDataOutput()
  
  override init() {
    super.init()
    videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
  }
  
  
  
  func mainOn() {
    isMainOn = true
  }
  
  
  func startSession() {
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
    
    do {
      let input = try AVCaptureDeviceInput(device: device)
      session.addInput(input)
    } catch {
      print("Error creating input: \(error)")
      return
    }
    session.addOutput(videoDataOutput)
    session.startRunning()
  }
  
  func stopSession() {
    session.stopRunning()
  }
}

extension FaceDetectionViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    
    let request = VNDetectFaceLandmarksRequest { [weak self] (request, error) in
      if let error = error {
        print("Failed to detect face landmarks: \(error)")
        return
      }
      
      guard let results = request.results as? [VNFaceObservation] else { return }
      
      DispatchQueue.main.async {
        guard let self = self else { return }
        for observation in results {
          let leftEyePoints = self.normalizedPoints(in: observation.landmarks?.leftEye)
          let rightEyePoints = self.normalizedPoints(in: observation.landmarks?.rightEye)
          self.points = leftEyePoints + rightEyePoints
          self.isEyeClosed = self.isEyeClosed(landmark: observation.landmarks?.leftEye) || self.isEyeClosed(landmark: observation.landmarks?.rightEye)
        }
      }
    }
    
    let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
    try? handler.perform([request])
  }
  
  func normalizedPoints(in landmark: VNFaceLandmarkRegion2D?) -> [CGPoint] {
    guard let landmark = landmark else { return [] }
    let points = landmark.normalizedPoints
    return points.map { CGPoint(x: $0.y * UIScreen.main.bounds.width, y: (1 - $0.x) * UIScreen.main.bounds.height) }
  }
  
  func calculateArea(points: [CGPoint]) -> CGFloat {
    var area: CGFloat = 0
    for i in 0..<points.count {
      let p1 = points[i]
      let p2 = points[(i + 1) % points.count]
      area += (p1.x * p2.y) - (p1.y * p2.x)
    }
    return abs(area / 2)
  }
  
  func isEyeClosed(landmark: VNFaceLandmarkRegion2D?) -> Bool {
    guard let landmark = landmark else { return false }
    let points = landmark.normalizedPoints
    
    let area = calculateArea(points: points)
    
    return area < 0.002
  }
}
