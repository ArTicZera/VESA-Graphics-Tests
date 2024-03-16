[BITS    16]

printstr:
        pusha
                mov     ah, 0x0E
                mov     al, [si]
                mov     bl, 0x0F
                
                printstr.loop:
                        int     0x10

                        inc     si
                        mov     al, [si]

                        cmp     al, 0x00
                        jne     printstr.loop
        popa

        ret

;IN: REG AX = VALUE; REG BL = COLOR
;OUT: NOTHING
printdec:
        pusha
                xor cx, cx
                xor dx, dx

                printdec.loop:
                        cmp ax, 0x00
                        je printdec.print

                        mov bx, 0x0A
                        div bx

                        ;Save number
                        push dx

                        inc cx

                        xor dx, dx
                        jmp printdec.loop

                printdec.print:
                        cmp cx, 0x00
                        je printdec.exit

                        pop dx

                        add dx, '0'

                        mov ah, 0x0E
                        mov al, dl
                        int 0x10

                        dec cx

                        jmp printdec.print

printdec.exit:
        popa

        ret

;EAX = Number
saveLFB:    
        mov     ebx, 16
        mov     ecx, hexString + 8

        saveLFB.convertLoop:
                mov edx, 0
                div ebx

                add dl, '0'

                cmp dl, '9'
                jbe saveLFB.storeDigit
                
                add dl, 7
        saveLFB.storeDigit:
                dec ecx  

                mov [ecx], dl

                test eax, eax
                jnz saveLFB.convertLoop
        ret

hexString: db "00000000h", 0x00
