extends RefCounted
class_name TBaseType

## Base class for generated types

func to_object() -> Dictionary:
	var r = {}
	for p in get_property_list():
		if p.name == "script" or not p.type:
			# Base stuff like script, refcounted, etc.
			continue
		if p.type in [TYPE_INT, TYPE_STRING]:
			r[p.name] = self[p.name]
		if p.type == TYPE_ARRAY:
			# Object array or object string
			r[p.name] = self[p.name].map(func (o): return o if typeof(o) == TYPE_STRING else o.to_object())
			
		if p.type == TYPE_OBJECT:
			r[p.name] = self[p.name].to_object() if self[p.name] else null

	return r
