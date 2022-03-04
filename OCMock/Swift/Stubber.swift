//
//  Stubber.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 06/09/2019.
//

public class Stubber<MOCK> {
    public func when<OUT>(_ invocation: @autoclosure () -> OUT) -> StubRecorder<OUT> {
        OCMMacroState.beginStubMacro()
        _ = invocation()

        let recorder = OCMMacroState.endStubMacro()
        return StubRecorder(recorder: recorder!)
    }
}
