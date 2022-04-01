ori     $1, $0, 0x3f3f
addu    $2, $1, $1
beq     $2, $2, lab
nop
addu    $2, $1, $2
lab:
beq     $0, $0, lab
nop
