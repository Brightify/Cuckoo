enum StubAction<IN, OUT> {
    case callImplementation((IN) throws -> OUT)
    case returnValue(OUT)
    case throwError(Error)
    case callRealImplementation
}
