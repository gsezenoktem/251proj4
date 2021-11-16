Name: []

## Question 1

In the following code-snippet from `Num2Bits`, it looks like `sum_of_bits`
might be a sum of products of signals, making the subsequent constraint not
rank-1. Explain why `sum_of_bits` is actually a _linear combination_ of
signals.

```
        sum_of_bits += (2 ** i) * bits[i];
```

## Answer 1
Sum of bits is assigned by multiplying each value in the bits array by a 
specific power of 2 and then summing. This means that each signal is being
multiplied by a constant and then added together, which is the definition
of a linear combination. In addition, the exponent operator is essentially
a repeated mutiplication of constant values, so the sum of bits is a sum
of a set of products.


## Question 2

Explain, in your own words, the meaning of the `<==` operator.

## Answer 2
The '<==' operator is a combination of two separate operators, the '<--' and
'===' operators. The arrow operator gives a variable a certain value, while
the equal operator makes sure that the variable is constrained by the other 
side of the equation. The '<==' operator thus assigns a value to a variable
and makes sure that this variable is constrained to be only this value.


## Question 3

Suppose you're reading a `circom` program and you see the following:

```
    signal input a;
    signal input b;
    signal input c;
    (a & 1) * b === c;
```

Explain why this is invalid.

## Answer 3
A constrain operation can only by assigned by a linear combination of signals. In this case, we have a bitwise operator ('&') that is acting
upon both a and 1. Because bitwise AND is not addition or multiplication,
using it as part of a constraint is invalid.

