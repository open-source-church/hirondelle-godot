extends Node

enum Side { INPUT, OUTPUT, BOTH, NONE }



## Connexion types
enum CONNECTION_TYPES {
	FLOW,
	TEXT,
	INT,
	FLOAT,
	COLOR,
	VEC2,
	BOOL,
	VARIANT,
	VARIANT_ARRAY
}

const connection_colors = {
	CONNECTION_TYPES.FLOW: Color.GREEN,
	CONNECTION_TYPES.TEXT: Color.PURPLE,
	CONNECTION_TYPES.INT: Color.YELLOW,
	CONNECTION_TYPES.COLOR: Color.BLUE,
	CONNECTION_TYPES.FLOAT: Color.ORANGE,
	CONNECTION_TYPES.BOOL: Color.CYAN,
	CONNECTION_TYPES.VEC2: Color.BROWN,
	CONNECTION_TYPES.VARIANT: Color.GRAY,
	CONNECTION_TYPES.VARIANT_ARRAY: Color.DIM_GRAY,
}
