Generate kusion spec (kusion-spec.yaml)

over kusion
```
kcl run -o kusion-spec.yaml
```
copy kusion-spec.yaml in kusion/test/default

to preview changes and apply them
over kusion/test/default execute:

```
 kusion preview --spec-file kusion-spec.yaml
 kusion apply --spec-file kusion-spec.yaml
```