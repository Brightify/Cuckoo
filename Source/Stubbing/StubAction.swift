enum StubAction<IN, OUT, ERROR: Error> {
    case callImplementation((IN) throws(ERROR) -> OUT)
    case returnValue(OUT)
    case throwError(ERROR)
    case callRealImplementation
}
