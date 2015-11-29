(use gauche.time)
(use util.queue)
(use ggc.skimu.frame-buffer)

;;;
;;;
;;;
(define lwp-queue (make-queue))

(define (lwp thunk)
  (enqueue! lwp-queue (lambda () (thunk) (lwp-next))))

(define (lwp-start)
  (lwp-pause)
  (if (queue-empty? lwp-queue)
      #t
      (lwp-start)))

(define (lwp-next)
  (let ((next (dequeue! lwp-queue)))
    (next)))

(define (lwp-pause)
  (call/cc (lambda (k)
             (lwp (lambda () (k #f)))
             (lwp-next))))

;;;
;;;
;;;
(define clw (cross-limit (compose-painter border wave) 3))

;;;
;;;  animation
;;;
(define base   "aa")
(define count  0)

(define (draw-line fb p1 p2)
  (let* ((x1 (xcor-vect p1))
         (y1 (ycor-vect p1))
	 (x2 (xcor-vect p2))
         (y2 (ycor-vect p2)))
    (lwp-pause)
    (fb-draw-line! fb
                   (round->exact x1)
                   (round->exact y1)
                   (round->exact x2)
                   (round->exact y2)
                   0 0 0)
    (save-frame-buffer-as-png-file fb (format #f "~a/~5,'0d.png" base count))
    (inc! count)
    ))

(define (draw-painter painter width height filename)
  (let* ((fb     (make-frame-buffer width height))
         (frame  (make-frame fb
                             (make-vect 0.0 height)
                             (make-vect width 0.0)
                             (make-vect 0.0 (- height)))))
    (set! count   0)
    (set! base filename)
    (lwp (lambda () (painter frame)))
    (lwp-start)
    #;(sys-system #"convert -loop 1 ~|base|*.png ~|base|.gif")
    #;(sys-system #"rm ~|base|*.png")
    ))

(time (draw-painter clw 300 300 "pa"))

;;;
;;;  parallel version BESIDE and BELOW
;;;
(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              split-point
                              (make-vect 0.0 1.0)))
          (paint-right
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.0)
                              (make-vect 0.5 1.0))))
      (lambda (frame)
        (lwp (lambda () (paint-left  frame)))
        (lwp (lambda () (paint-right frame)))
  	))))

(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-below
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              (make-vect 1.0 0.0)
                              split-point))
          (paint-above
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.5)
                              (make-vect 0.0 1.0))))
      (lambda (frame)
        (lwp (lambda () (paint-below frame)))
        (lwp (lambda () (paint-above frame)))
  	))))

(define clw (cross-limit (compose-painter border wave) 3))
(time (draw-painter clw 300 300 "pb"))
