[BITS    16]
[ORG 0x7E00]

kernelmain:
        call    SetupVESA

        ;Save LFB in 00000000h format
        mov     eax, [LFBAddress]
        call    saveLFB

        ;Print LFBAddress (0xFD000000)
        mov     si, hexString
        call    printstr

        ;First color to fill the screen
        xor     eax, eax

draw:
        ;Load Linear Frame Buffer
        mov     edi, [LFBAddress]

        ;X starts with 0
        xor     ecx, ecx

        ;Time register
        inc     ebp

        draw.loop:
                ;Calculate a pattern based on
                ;the pixel position.
                call    pattern

                ;Set pixel
                mov     [es:edi], eax

                ;Next byte in the Video Buffer
                add     edi, 0x01

                ;Next X pos
                inc     ecx

                ;See if reached the end of the screen
                ;If it's true, draw next frame
                cmp     ecx, 640*480
                jae      draw

                ;If it's false, draw next pixel
                jmp     draw.loop

                jmp     $

%include "Graphics/vesa.asm"
%include "Graphics/print.asm"
%include "Kernel/patterns.asm"

times (512 * 8) - ($ - $$) db 0x00
