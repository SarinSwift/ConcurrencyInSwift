/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import UIKit

class TiltShiftOperation: Operation {
  
  // MARK: Properties
  
  // static since we don't want to create a new context with each instance of the operation. Thread safe!
  private static let context = CIContext()
  var inputImage: UIImage?
  var outputImage: UIImage?
  
  init(image: UIImage? = nil) {
    inputImage = image
    super.init()
  }
  
  override func main() {
    
    // check if the dependencies gives the image as output
    let dependencyImage = dependencies.compactMap{ ($0 as? ImageDataProvider)?.image }.first
    guard let inputImage = inputImage ?? dependencyImage else {
      return
    }
    
    // moved the longrunning tasks from cellForRowAt here
    guard let filter = TiltShiftFilter(image: inputImage, radius: 3), let output = filter.outputImage else {
      print("Failed to generate image")
      return
    }
    
    let fromRect = CGRect(origin: .zero, size: inputImage.size)
    guard let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect) else {
      print("Image generation failed")
      return
    }
    
    outputImage = UIImage(cgImage: cgImage) 
  }
}
