#!/bin/bash
set -xe

# These are the steps of the METAII metacompiler tutorial
# located at bayfronttechnologies.com/mc_tutorial.html
# To get started, we need the original METAII grammar
# as given in Fig. 5.2 of the original paper, i02.grammar,
# as well as it's implementation in the interpreter 
# language, c02.asm
../metaii.perl i02.grammar   c02.asm  >c01.asm
../metaii.perl i01.grammar   c01.asm  >c00.asm
../metaii.perl i03.grammar   c02.asm  >c02.asm.copy
../metaii.perl i04.grammar   c02.asm  >c03.asm
../metaii.perl i05.grammar   c03.asm  >c04.asm
../metaii.perl i06.grammar   c04.asm  >c04.asm.copy
../metaii.perl i07.grammar   c04.asm  >c05.asm
../metaii.perl i08.grammar   c05.asm  >c06.asm
../metaii.perl i09.grammar   c06.asm  >c07.asm
../metaii.perl i09.grammar   c07.asm  >c07.asm.copy
../metaii.perl i10.grammar   c07.asm  >c08.asm
../metaii.perl i10.grammar   c08.asm  >c07jf.js
# node          i10.grammar   c07jf.js >c07jf.js
# head -n 5 runJScompilersTemplate.html | cat - c07jf.js <(sed -n '6,$p' runJScompilersTemplate.html ) >c07jf.html
# node          i09.grammar   c07jf.js >t
# node          i09.grammar   t        >c07.asm

../metaii.perl i11.grammar   c07.asm >c09.asm
# node i11.grammar c07jf.js >c09jf.js
../metaii.perl i12.grammar   c09.asm >c10.asm
../metaii.perl i12.grammar   c10.asm >c10.asm.copy
# node          i12.grammar   c09jf.js >c10jf.js
../metaii.perl i13.grammar   c10.asm >c11.asm
# node          i13.grammar   c10jf.js >c11jf.js

# Step 11.3
../metaii.perl i14.grammar   c11.asm >c12.asm
../metaii.perl i14.grammar   c12.asm >c12.asm.copy
# node      i14.grammar   c11jf.js >c12jf.js
# node      i14jf.grammar c11jf.js >c12jf.js.copy

# Step 12.2 [ ]
# node      i14js.grammar c12jf.js >t
# node      i14js.grammar t >c12js.js
# node      i14js.grammar c12js.js >c12js.js.copy

# Step 13   [ ]
# node      i02a.grammar  c12js.js >c01ajs.js
# node      i01.grammar   c01ajs.js >c00.asm.copy
# node      i01a.grammar  c01ajs.js # Syntax error

# Step 13.3 [ ]
# node      i15js.grammar c12js.js > t
# node      i15js.grammar t > c13js.js
# node      i02b.grammar  c13js.js > c01bjs.js
# node      i01a.grammar  c01bjs.js > t

# Step 14   [ ]
# node      i04a.grammar  c12js.js >t.js
# node      i03.grammar   t.js     >c02.asm.copy2

#rm -f c01.asm c00.asm c02.asm.copy c03.asm c04.asm c04.asm.copy c05.asm c06.asm c07.asm c07.asm.copy c08.asm c07jf.js c09.asm c10.asm c10.asm.copy c11.asm c12.asm c12.asm.copy c12.js c12js.js c01ajs.js
