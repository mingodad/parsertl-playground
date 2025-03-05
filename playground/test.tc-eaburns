class R {
  int iField, iArrayField[];
  Object oField, oArrayField[];
  S sField, sArrayField[];
  T tField, tArrayField[];
  R rField, rArrayField[];

  int method(R r[]) {}
  int method(R r) {}

  int blah() {
    iField = method(tField);
    iField = method(sField);
    iField = method(rField);
    iField = method(tArrayField);
    iField = method(sArrayField);
    iField = method(rArrayField);

    iField = this.method(tField);
    iField = this.method(sField);
    iField = this.method(rField);
    iField = this.method(tArrayField);
    iField = this.method(sArrayField);
    iField = this.method(rArrayField);
  }
}

class S extends R {

  int blah() {
    iField = method(tField);
    iField = method(sField);
    iField = method(rField);
    iField = method(tArrayField);
    iField = method(sArrayField);
    iField = method(rArrayField);

    iField = this.method(tField);
    iField = this.method(sField);
    iField = this.method(rField);
    iField = this.method(tArrayField);
    iField = this.method(sArrayField);
    iField = this.method(rArrayField);

    iField = super.method(tField);
    iField = super.method(sField);
    iField = super.method(rField);
    iField = super.method(tArrayField);
    iField = super.method(sArrayField);
    iField = super.method(rArrayField);
  }
}

class T extends S {

  int blah() {
    iField = method(tField);
    iField = method(sField);
    iField = method(rField);
    iField = method(tArrayField);
    iField = method(sArrayField);
    iField = method(rArrayField);

    iField = this.method(tField);
    iField = this.method(sField);
    iField = this.method(rField);
    iField = this.method(tArrayField);
    iField = this.method(sArrayField);
    iField = this.method(rArrayField);

    iField = super.method(tField);
    iField = super.method(sField);
    iField = super.method(rField);
    iField = super.method(tArrayField);
    iField = super.method(sArrayField);
    iField = super.method(rArrayField);
  }
}

int main()
{
  int i, iArray[];
  Object o, oArray[];
  T t, tArray[];
  S s, sArray[];
  R r, rArray[];

  i = t.method(t);
  i = t.method(s);
  i = t.method(r);
  i = t.method(tArray);
  i = t.method(sArray);
  i = t.method(rArray);

  i = s.method(t);
  i = s.method(s);
  i = s.method(r);
  i = s.method(tArray);
  i = s.method(sArray);
  i = s.method(rArray);

  i = r.method(t);
  i = r.method(s);
  i = r.method(r);
  i = r.method(tArray);
  i = r.method(sArray);
  i = r.method(rArray);

  return 0;
}
