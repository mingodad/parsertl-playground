{
// Calc is an example calculator program.
// You can build it from calc.peggy with
// 	peggy -o calc.go calc.peggy
package main

import (
	"bufio"
	"fmt"
	"math/big"
	"os"
	"unicode"
	"unicode/utf8"

	"github.com/eaburns/peggy/peg"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		line := scanner.Text()
		p, err := _NewParser(line)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		if pos, perr := _ExprAccepts(p, 0); pos < 0 {
			_, fail := _ExprFail(p, 0 ,perr)
			fmt.Println(peg.SimpleError(line, fail))
			continue
		}
		_, result := _ExprAction(p, 0)
		fmt.Println((*result).String())
	}
	if err := scanner.Err(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

type op func(*big.Float, *big.Float, *big.Float) *big.Float

type tail struct {
	op op
	r *big.Float
}

func evalTail(l big.Float, tail []tail) big.Float {
	for _, t := range tail {
		t.op(&l, &l, t.r)
	}
	return l
}

func isSpace(s string) bool {
	r, _ := utf8.DecodeRuneInString(s)
	return unicode.IsSpace(r)
}
}

Expr <- s:Sum EOF { return (*big.Float)(&s) }

Sum <- l:Product tail:SumTail* { return (big.Float)(evalTail(l, tail)) }

SumTail <- op:AddOp r:Product { return tail{op, &r} }

AddOp "operator" <-
	_ "+"  { return op((*big.Float).Add) } /
	_ "-" { return op((*big.Float).Sub) }

Product <- l:Value tail:ProductTail* { return (big.Float)(evalTail(l, tail)) }

ProductTail <- op:MulOp r:Value { return tail{op, &r} }

MulOp "operator" <-
	_ "*"  { return op((*big.Float).Mul) } /
	_ "/" { return op((*big.Float).Quo) }

Value <- Num / _ "(" e:Sum _ ")" { return (big.Float)(e) }

Num "number" <- _ n:( [0-9]+ ("." [0-9]+)? ) {
	var f big.Float
	 f.Parse(n, 10)
	 return (big.Float)(f)
}

_ "space" <- ( s:. &{ isSpace(s) } )*

EOF "end of file" <- !.