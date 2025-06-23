import Foundation

extension Templates {
    static let staticGenericParameter = "_CUCKOO$$GENERIC"
    static let typeErasureClassName = "DefaultImplCaller"
    static let typeErasureGenericParameterPrefix = "\(staticGenericParameter)_"
    static let mock = """
{% for container in containers %}
{% if debug %}
// {{ container }}
{% endif %}
{% for attribute in container.attributes %}
{{ attribute }}
{% endfor %}
{% if container.hasParent %}
extension {{ container.parentFullyQualifiedName }} {
{% endif %}
{{ container.accessibility|withSpace }}class {{ container.mockName }}{{ container.genericParameters }}:{% if container.isNSObjectProtocol %} NSObject,{% endif %} {{ container.name }}{% if container.isImplementation %}{{ container.genericArguments }}{% endif %},{% if container.isImplementation %} Cuckoo.ClassMock{% else %} Cuckoo.ProtocolMock{% endif %}, @unchecked Sendable {
    {% if container.isGeneric and not container.isImplementation %}
    {{ container.accessibility|withSpace }}typealias MocksType = \(typeErasureClassName)
    {% else %}
    {{ container.accessibility|withSpace }}typealias MocksType = {{ container.name }}{{ container.genericArguments }}
    {% endif %}
    {{ container.accessibility|withSpace }}typealias Stubbing = __StubbingProxy_{{ container.name }}
    {{ container.accessibility|withSpace }}typealias Verification = __VerificationProxy_{{ container.name }}

    // Original typealiases
    {% for typealias in container.typealiases %}
    {{ container.accessibility|withSpace }}{{ typealias }}
    {% endfor %}

    {{ container.accessibility|withSpace }}let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: {{ container.isImplementation }})

    {% if container.isGeneric and not container.isImplementation %}
\(Templates.typeErasure.indented())

    private var __defaultImplStub: \(typeErasureClassName)?

    {{ container.accessibility|withSpace }}func enableDefaultImplementation<\(staticGenericParameter): {{ container.name }}>(_ stub: \(staticGenericParameter)) where {{ container.genericProtocolIdentity }} {
        var mutableStub = stub
        __defaultImplStub = \(typeErasureClassName)(from: &mutableStub, keeping: mutableStub)
        cuckoo_manager.enableDefaultStubImplementation()
    }

    {{ container.accessibility|withSpace }}func enableDefaultImplementation<\(staticGenericParameter): {{ container.name }}>(mutating stub: UnsafeMutablePointer<\(staticGenericParameter)>) where {{ container.genericProtocolIdentity }} {
        __defaultImplStub = \(typeErasureClassName)(from: stub, keeping: nil)
        cuckoo_manager.enableDefaultStubImplementation()
    }
    {% else %}
    {% if container.isImplementation %}
    private var __defaultImplStub: {{ container.name }}{{ container.genericArguments }}?
    {% else %}
    private var __defaultImplStub: (any {{ container.name }}{{ container.genericArguments }})?
    {% endif %}

    {{ container.accessibility|withSpace }}func enableDefaultImplementation(_ stub: {%+ if not container.isImplementation %}any {%+ endif %}{{ container.name }}{{ container.genericArguments }}) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    {% endif -%}

    {% for property in container.properties %}
    
    {% if debug %}
    // {{ property }}
    {% endif %}
    {% for docString in property.documentation %}
    /// {{ docString }}
    {% endfor %}
    {% for attribute in property.attributes %}
    {{ attribute }}
    {% endfor %}
    {{ property.accessibility|withSpace }}{% if property.isOverriding %}override {%+ endif %}var {{ property.name|escapeReservedKeywords }}: {{ property.type }} {
        get {%+ if property.isAsync %}async {%+ endif %}{% if property.isThrowing %}throws {%+ endif %}{
            return {%+ if property.isThrowing %}try {%+ endif %}{% if property.isAsync %}await {%+ endif %}cuckoo_manager.getter{% if property.isThrowing %}Throws{% endif %}(
                "{{ property.name }}",
                superclassCall: {%+ if container.isImplementation -%}
                    {% if property.isThrowing %}try {%+ endif %}{% if property.isAsync %}await {%+ endif %}super.{{ property.name }}
                    {%- else -%}
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    {%- endif -%},
                defaultCall: {%+ if property.isThrowing %}try {%+ endif %}{% if property.isAsync %}await {%+ endif %}__defaultImplStub!.{{property.name}}
            )
        }
        {% ifnot property.isReadOnly %}
        set {
            cuckoo_manager.setter(
                "{{ property.name }}",
                value: newValue,
                superclassCall: {%+ if container.isImplementation -%}
                    super.{{ property.name }} = newValue
                    {%- else -%}
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    {%- endif -%},
                defaultCall: __defaultImplStub!.{{property.name}} = newValue
            )
        }
        {% endif %}
    }
    {% endfor %}

    {% for initializer in container.initializers %}
    {% if debug %}
    // {{ initializer }}
    {% endif %}
    {% for docString in initializer.documentation %}
    /// {{ docString }}
    {% endfor %}
    {{ initializer.accessibility|withSpace }}required init{{initializer.signature}} {}
    {% endfor %}
    {% for method in container.methods %}
    
    {% if debug %}
    // {{method}}
    {% endif %}
    {% for docString in method.documentation %}
    /// {{ docString }}
    {% endfor %}
    {% for attribute in method.attributes %}
    {{ attribute }}
    {% endfor %}
    {{ method.accessibility|withSpace }}{% if method.isOverriding %}override {%+ endif %}func {{ method.name|escapeReservedKeywords }}{{ method.signature }} {
        {{ method.self|openNestedClosure }}return{% if method.isThrowing %} try{% endif %}{% if method.isAsync %} await{% endif %} cuckoo_manager.call{% if method.isThrowing %}{{ method.throwType|capitalize }}{% endif %}(
            "{{method.fullyQualifiedName}}",
            parameters: ({{method.parameterNames}}),
            escapingParameters: ({{method.escapingParameterNames}}),
            {% if method.throwsOnly %}errorType: {{ method.throwTypeError }}.self,{% endif %}
            superclassCall: {%+ if container.isImplementation %}{% if method.isAsync %}await {%+ endif %}super.{{method.name}}({{method.call}}){% else %}Cuckoo.MockManager.crashOnProtocolSuperclassCall(){% endif %},
            defaultCall: {%+ if method.isAsync %}await {%+ endif %}__defaultImplStub!.{{method.name}}{%if method.isOptional %}!{%endif%}({{method.call}})
        ){{ method.parameters|closeNestedClosure }}
    }
    {% endfor %}

\(Templates.stubbingProxy.indented())

\(Templates.verificationProxy.indented())
}

\(Templates.noImplStub)

{% if container.hasParent %}
}
{% endif %}

{% endfor %}
"""
}
