include "./mimc.circom";

/*
 * IfThenElse sets `out` to `true_value` if `condition` is 1 and `out` to
 * `false_value` if `condition` is 0.
 *
 * It enforces that `condition` is 0 or 1.
 *
 */
template IfThenElse() {
    signal input condition;
    signal input true_value;
    signal input false_value;
    signal output out;
    signal intermeda;
    signal intermedb;

    // TODO
    // Hint: You will need a helper signal...
    condition * (1 - condition) === 0;
    intermeda <== condition * true_value;
    intermedb <== (1 - condition) * false_value;
    out <== intermeda + intermedb;
}

/*
 * SelectiveSwitch takes two data inputs (`in0`, `in1`) and produces two ouputs.
 * If the "select" (`s`) input is 1, then it inverts the order of the inputs
 * in the ouput. If `s` is 0, then it preserves the order.
 *
 * It enforces that `s` is 0 or 1.
 */
template SelectiveSwitch() {
    signal input in0;
    signal input in1;
    signal input s;
    signal output out0;
    signal output out1;

    // TODO
    component checker1 = IfThenElse();
    component checker2 = IfThenElse();
    checker1.condition <== s;
    checker2.condition <== s;

    checker1.true_value <== in1;
    checker1.false_value <== in0;

    checker2.true_value <== in0;
    checker2.false_value <== in1;

    out0 <== checker1.out;
    out1 <== checker2.out;
    
}

/*
 * Verifies the presence of H(`nullifier`, `nonce`) in the tree of depth
 * `depth`, summarized by `digest`.
 * This presence is witnessed by a Merkle proof provided as
 * the additional inputs `sibling` and `direction`, 
 * which have the following meaning:
 *   sibling[i]: the sibling of the node on the path to this coin
 *               at the i'th level from the bottom.
 *   direction[i]: "0" or "1" indicating whether that sibling is on the left.
 *       The "sibling" hashes correspond directly to the siblings in the
 *       SparseMerkleTree path.
 *       The "direction" keys the boolean directions from the SparseMerkleTree
 *       path, casted to string-represented integers ("0" or "1").
 */
template Spend(depth) {
    signal input digest;
    signal input nullifier;
    signal private input nonce;
    signal private input sibling[depth];
    signal private input direction[depth];

    // TODO
    signal hashedval[depth + 1];
    component starthash = Mimc2();
    starthash.in0 <== nullifier;
    starthash.in1 <== nonce;
    hashedval[0] <== starthash.out;
    
    //make array of hashes and switches
    component hash[depth];
    component order[depth];
    for(var i = 0; i < depth; ++i) {

        order[i] = SelectiveSwitch();
        order[i].s <== direction[i];
        order[i].in0 <== hashedval[i];
        order[i].in1 <== sibling[i];

        hash[i] = Mimc2();
        hash[i].in0 <== order[i].out0;
        hash[i].in1 <== order[i].out1;
        hashedval[i + 1] <== hash[i].out;
    }

    hashedval[depth] === digest;

}
