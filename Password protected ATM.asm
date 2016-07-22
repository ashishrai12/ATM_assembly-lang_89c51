//Assume Password as 1234

org 0000h

LJMP main

ORG 0050H

dB &#39;Active&#39;,0,0

ORG 0095H

dB &#39;Password&#39;

ORG 00B0H

dB &#39;1&#39;,&#39;2&#39;,&#39;3&#39;,&#39;4&#39;

main:

mov p1,#0FH //Partially input mode (for votes)

mov p2,#07H //Keypad

mov p0,#00H //LCD data

mov DPTR,#0095H

acall update_LCD

acall password_check

mov DPTR,#0050H

acall update_LCD

here:mov a,p1

anl a,#07//Mask to check vote

jz here

jb acc.0,BJP

jb acc.1,CONGRESS

jb acc.2,OTHERS

BJP:inc R2

sjmp main

CONGRESS: inc R3

sjmp main

OTHERS: inc R4

sjmp main

password_check:

l4:mov r1,#0B0h

mov r2,#4

l2:acall check_data

mov a,r0

jz l2 //got some data

movx a,@r1

subb a,r0

jnz l4 //incorrect

inc r1

djnz r2,l2

RET

check_data:mov r0,#0

l3:clr a

mov a,#01111000b

orl 0A0H,a

acall delay

clr a

orl a,0A0H//Check P2 status

anl a,#07H //mask bit 0,1,2 to check column status

jb acc.0,col0

sjmp l3

jb acc.1,col1

sjmp l3

jb acc.2,col2

sjmp l3

col0:

mov p2,#7FH

clr p2.3

mov a,0A0H

jnb acc.2,done1

sjmp next1

done1:mov r0,#1

next1:mov p2,#7FH

clr p2.4

mov a,0A0H

jnb acc.2,done4

sjmp next4

done4:mov r0,#4

next4:mov p2,#7FH

clr p2.5

mov a,0A0H

jnb acc.2,done7

sjmp col1

done7:mov r0,#7

col1:mov p2,#7FH

clr p2.3

mov a,0A0H

jnb acc.1,done2

sjmp next2

done2:mov r0,#2

next2:mov p2,#7FH

clr p2.4

mov a,0A0H

jnb acc.1,done5

sjmp next5

done5:mov r0,#5

next5:mov p2,#7FH

clr p2.5

mov a,0A0H

jnb acc.1,done8

sjmp col2

done8:mov r0,#8

col2: mov p2,#7FH

clr p2.3

mov a,0A0H

jnb acc.0,done3

sjmp next3

done3:mov r0,#3

next3:mov p2,#7FH

clr p2.4

mov a,0A0H

jnb acc.0,done6

sjmp next6

done6:mov r0,#6

next6:

mov p2,#7FH

clr p2.5

mov a,0A0H

jnb acc.0,done9

sjmp next9

done9:mov r0,#9

next9:RET

update_LCD:

mov r6,#8//LCD data count

acall lcd_init

clr a

l1:inc DPTR

movx a,@dptr

acall ldata

djnz r6,l1

RET

lcd_init:mov a,#38h

acall cmd

mov a,#06h

acall cmd

mov a,#01h

acall cmd

mov a,#0e0h

acall cmd

mov a,#80h

acall cmd

RET

cmd:clr p1.7

mov p0,a

setb p3.6

acall delay

clr p1.6

acall delay

ret

ldata:setb p1.7

mov p0,a

setb p1.6

acall delay

clr p1.6

acall delay

ret

delay:djnz r7,delay

ret

end