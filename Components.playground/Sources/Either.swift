import Foundation

public enum Either <A, B> {
	case Left (A)
	case Right (B)
	
	public var left: A? {
		switch self {
		case .Left(let a): return a
		default: return nil
		}
	}
	public var right: B? {
		switch self {
		case .Right(let b): return b
		default: return nil
		}
	}
}
