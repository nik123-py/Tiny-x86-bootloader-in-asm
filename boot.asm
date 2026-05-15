
	bits 16

	mov ax, 07C0h
	mov ds, ax
	mov ax, 07E0h		; 07E0h = (07C00h+200h)/10h, beginning of stack segment.
	mov ss, ax
	mov sp, 2000h		; 8k of stack space.

	call clearscreen

	push 0000h
	call movecursor
	add sp, 2

	push msg
	call print
	add sp, 2

	cli
	hlt

clearscreen:
	push bp
	mov bp, sp
	pusha

	mov ah, 07h		; tells BIOS to scroll down window
	mov al, 00h		; clear entire window
    	mov bh, 07h    		; white on black
	mov cx, 00h  		; specifies top left of screen as (0,0)
	mov dh, 18h		; 18h = 24 rows of chars
	mov dl, 4fh		; 4fh = 79 cols of chars
	int 10h			; calls video interrupt

	popa
	mov sp, bp
	pop bp
	ret

movecursor:
	push bp
	mov bp, sp
	pusha

	mov dx, [bp+4] 		;
	mov ah, 02h 		; 
	mov bh, 00h		
	int 10h

	popa
	mov sp, bp
	pop bp
	ret

print:
	push bp
	mov bp, sp
	pusha
	mov si, [bp+4]	 	
	mov bh, 00h	       
	mov bl, 00h		
	mov ah, 0Eh  	
 .char:
	mov al, [si]   		
	add si, 1		
	or al, 0
	je .return        	
	int 10h         	
	jmp .char	  	
 .return:
	popa
	mov sp, bp
	pop bp
	ret


msg:	db " love assembly!", 0

	times 510-($-$$) db 0
	dw 0xAA55

