(define (chars-to-string char-list)
  (apply string char-list))  
(define (read-lines port)
  (let loop ((current-line '()) (lines '()))
    (let ((ch (read-char port)))
      (cond
        ((eof-object? ch)              
         (reverse (if (null? current-line)
                      lines
                      (cons (chars-to-string (reverse current-line)) lines))))
        ((char=? ch #\newline)          
         (loop '() (cons (chars-to-string (reverse current-line)) lines)))
        (else
         (loop (cons ch current-line) lines))))))
(define (read-file file-path)
  (let ((in-port (open-input-file file-path)))
    (let ((lines (read-lines in-port)))
      (close-input-port in-port)
      lines)))
(define (extract-first-numbers lines)
  (let loop ((lines lines) (numbers '()))
    (if (null? lines)
        (reverse numbers) 
        (let* ((line (car lines))
               (parts (string-split line " ")))
          (if (and (not (null? parts)) (string->number (car parts))) 
              (loop (cdr lines) (cons (string->number (car parts)) numbers)) 
              (loop (cdr lines) numbers))))))
(define (extract-second-numbers lines)
  (let loop ((lines lines) (numbers '()))
    (if (null? lines)
        (reverse numbers)
        (let* ((line (car lines))
               (parts (string-split line " "))) 
          (if (and (>= (length parts) 2) (string->number (cadr parts)))
              (loop (cdr lines) (cons (string->number (cadr parts)) numbers)) 
              (loop (cdr lines) numbers)))))) 
(define (string-split str delimiter)
  (let loop ((chars (string->list str)) (current '()) (result '()))
    (cond
      ((null? chars) 
       (reverse (if (null? current) result (cons (list->string (reverse current)) result))))
      ((char=? (car chars) (string-ref delimiter 0)) 
       (loop (cdr chars) '() (if (null? current) result (cons (list->string (reverse current)) result)))) 
      (else (loop (cdr chars) (cons (car chars) current) result))))) 
(define file-contents (read-file "example.txt"))
(define first-numbers (extract-first-numbers file-contents))
(display first-numbers)
(define second-numbers (extract-second-numbers file-contents))
(display second-numbers) 
(display file-contents)