abstract class DartAnnotation {
  const DartAnnotation();
}

class XmlAttributeDartAnnotation extends DartAnnotation {
  final String? name;
  final String? namespace;

  const XmlAttributeDartAnnotation({
    this.name,
    this.namespace,
  });
}

class XmlCDATADartAnnotation extends DartAnnotation {
  const XmlCDATADartAnnotation();
}

class XmlElementDartAnnotation extends DartAnnotation {
  final String? name;
  final String? namespace;
  final bool? isSelfClosing;
  final bool? includeIfNull;

  const XmlElementDartAnnotation({
    this.name,
    this.namespace,
    this.isSelfClosing,
    this.includeIfNull,
  });
}

class XmlRootElementDartAnnotation extends DartAnnotation {
  final String? name;
  final String? namespace;
  final bool? isSelfClosing;

  const XmlRootElementDartAnnotation({
    this.name,
    this.namespace,
    this.isSelfClosing,
  });
}

class XmlSerializableDartAnnotation extends DartAnnotation {
  const XmlSerializableDartAnnotation();
}

class XmlTextDartAnnotation extends DartAnnotation {
  const XmlTextDartAnnotation();
}
