extension Templates {
    static let noImplStub = """
{% for attribute in container.attributes %}
{{ attribute }}
{% endfor %}
{{container.accessibility|withSpace}}{% if container.isActorRequirement %}actor{% else %}class{% endif %} {{ container.name }}Stub{{ container.genericParameters }}: {% if container.isNSObjectProtocol %}NSObject, {% endif %}{{ container.name }}{% if container.isImplementation %}{{ container.genericArguments }}{% endif %}{% if not container.isActorRequirement %}, @unchecked Sendable{% endif %} {
    {% for property in container.properties %}
    {{ property.unavailablePlatformsCheck }}
    {% if debug %}
    // {{property}}
    {% endif %}
    {% for attribute in property.attributes %}
    {{ attribute }}
    {% endfor %}
    {{ property.accessibility|withSpace }}{% if property.isOverriding %}override {%+ endif %}var {{ property.name }}: {{ property.type }} {
        get {
            return DefaultValueRegistry.defaultValue(for: ({{property.type|genericSafe|removeClosureArgumentNames}}).self)
        }
        {% ifnot property.isReadOnly %}
        set {}
        {% endif %}
    }
    {% if property.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}

    {% for initializer in container.initializers %}
    {{ initializer.unavailablePlatformsCheck }}
    {{ initializer.accessibility|withSpace }}{% if not container.isActorRequirement %}required {%+ endif %}init{{initializer.signature}} {}
    {% if initializer.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}

    {% for method in container.methods %}
    {{ method.unavailablePlatformsCheck }}
    {% if debug %}
    // {{method}}
    {% endif %}
    {% for attribute in method.attributes %}
    {{ attribute }}
    {% endfor %}
    {{ method.accessibility|withSpace }}{% if method.isOverriding %}override {%+ endif %}func {{ method.name|escapeReservedKeywords }}{{ method.signature }} {
        return DefaultValueRegistry.defaultValue(for: ({{method.returnType|genericSafe}}).self)
    }
    {% if method.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}
}
"""
}
