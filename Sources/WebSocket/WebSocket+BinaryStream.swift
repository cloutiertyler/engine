import Core

final class BinaryStream : Core.Stream {
    /// Sends this binary data to the other party
    func inputStream(_ input: ByteBuffer) {
        do {
            let mask = self.masking ? randomMask() : nil
            
            let frame = try Frame(op: .binary, payload: input, mask: mask)
            
            if masking {
                frame.mask()
            }
            
            frameStream?.inputStream(frame)
        } catch {
            self.errorStream?(error)
        }
    }
    
    /// A stream of incoming binary data
    var outputStream: ((ByteBuffer) -> ())?
    
    internal weak var frameStream: Connection?
    
    /// A stream of errors
    ///
    /// Will only be called if there's a problem creating a frame for output
    var errorStream: ErrorHandler?
    
    typealias Input = ByteBuffer
    typealias Output = ByteBuffer
    
    /// Returns whether to add mask a mask to this message
    var masking: Bool {
        return frameStream?.serverSide == false
    }
    
    /// Creates a new BinaryStream that has yet to be linked up with other streams
    init() { }
}

