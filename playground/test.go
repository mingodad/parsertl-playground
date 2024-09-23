package main;

/*
 * A libjit wrapper for Golang
 *
 * Copyright (c) 2013 Chanwit Kaewkasi
 * Suranaree University of Technology
 *
 */
import "fmt";
import . "github.com/chanwit/jit";

/*
 *    Example #1 mul_add
 *
 *    Builds and compiles the function:
 *
 *    int mul_add(int x, int y, int z) {
 *        return x * y + z;
 *    }
 */
func main() {

	// Create a context to hold the JIT's primary state
	// defer to Destroy the context at the end of func main()
	ctx := NewContext();
	defer ctx.Destroy();

	// Lock the context while we build and compile the function
	ctx.BuildStart();

	// Create the function object
	f := ctx.NewFunction(Int(), []Type{Int(), Int(), Int()});

	// Construct the function body
	x, y, z := f.Param3();
	t1 := f.Mul(x, y);
	t2 := f.Add(t1, z);
	f.Return(t2);

	// Compile the function
	f.Compile();

	// Dump the result to standard output
	f.Dump("mul_add");

	// Unlock the context
	ctx.BuildEnd();

	// Execute the function
	fmt.Printf("mul_add(3, 5, 2): result = %d\n", f.Run(3, 5, 2).(int));
	fmt.Printf("mul_add(5, 5, 5): result = %d\n", f.Run(5, 5, 5).(int));
};
